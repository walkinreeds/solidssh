SHELL = /bin/sh

VERSION= 0.99
#DOCGENERATOR= happydoc
DOCGENERATOR= pydoc -w
# This is for GNU Make. This does not work on BSD Make.
MANIFEST_LINES := $(shell cat MANIFEST)
# This is for BSD Make. This does not work on GNU Make.
#MANIFEST_LINES != cat MANIFEST

all: dist examples docs

# *.py README.txt MANIFEST

dist/pexpect-$(VERSION).tar.gz: $(MANIFEST_LINES)
	rm -f *.pyc
	rm -f pexpect-*.tgz
	rm -f dist/pexpect-$(VERSION).tar.gz
	/usr/bin/env python setup.py sdist

install: dist
	cd dist;\
	tar zxf pexpect-$(VERSION).tar.gz;\
	cd pexpect-$(VERSION);\
	/usr/bin/env python setup.py install

dist: pexpect-current.tgz

pexpect-current.tgz: dist/pexpect-$(VERSION).tar.gz
	rm -f pexpect-current.tgz
	cp dist/pexpect-$(VERSION).tar.gz ./pexpect-current.tgz
	cp dist/pexpect-$(VERSION).tar.gz ./pexpect-$(VERSION).tgz

docs: pexpect-doc.tgz

pexpect-doc.tgz: doc/*
	rm -f pexpect-doc.tgz
	-rm -f `ls doc/*.html | sed -e 's/doc\/index\.html//'` 
	$(DOCGENERATOR) `echo "$(MANIFEST_LINES)" | sed -e "s/\.py//g"`
	mv *.html doc/
	tar zcf pexpect-doc.tgz doc/

examples: pexpect-examples.tgz

pexpect-examples.tgz: examples/*
	rm -f pexpect-examples.tgz
	tar zcf pexpect-examples.tgz examples/

clean:
	rm -f *.pyc
	rm -f tests/*.pyc
	rm -f dist/pexpect-$(VERSION).tar.gz
	cd dist;rm -rf pexpect-$(VERSION)/
	rm -f pexpect-$(VERSION).tgz
	rm -f pexpect-current.tgz
	rm -f pexpect-examples.tgz
	rm -f pexpect-doc.tgz
	-rm -f `ls doc/*.html | sed -e 's/doc\/index\.html//'` 
	rm -f python.core
	rm -f core
	
