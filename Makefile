# 2012.10.11 
# Steve Rodney

# This Makefile and the associated latex templates are useful
# for quick compilation of different versions of the same paper. 
# For example:
#
# make pdf : generate the compact version with emulateapj and pdflatex
# make manuscript : a manuscript version with lots of white space 
#     for co-authors to scribble comments
# make changetext : highlight in blue any text that you've flagged with
#      the \change{} command (e.g. for submitting a revised version back 
#      to the referee)
# make grayscale : use the grayscale version of figures, when available
# 
# make submission : the journal submission version, compiled with latex
#       (not pdflatex), using manuscript layout, eps figures, grayscale 
#       figs when available, red comments, and no blue text.


# Set the variable PAPER to the root name of your .tex document
PAPER= spock_localbuild

default: nature

all: clean local
clean:
	rm -f *.aux *.log *.bbl *.blg *.lof *.lot *.toc 


#Generate a pdf file using a Nature latex style file
NATUREFILE=spock_natureastronomy_finalsubmission
nature: 
	pdflatex $(NATUREFILE).tex
	pdflatex $(NATUREFILE).tex
	open $(NATUREFILE).pdf

natureupdate: 
	pdflatex $(NATUREFILE).tex
	open $(NATUREFILE).pdf

naturebib: 
	pdflatex $(NATUREFILE).tex
	bibtex $(NATUREFILE)
	pdflatex $(NATUREFILE).tex
	pdflatex $(NATUREFILE).tex
	open $(NATUREFILE).pdf

ARXIVFILE=spock_arxiv
arxiv: 
	pdflatex $(ARXIVFILE).tex
	bibtex $(ARXIVFILE)
	pdflatex $(ARXIVFILE).tex
	pdflatex $(ARXIVFILE).tex
	open $(ARXIVFILE).pdf

arxivupdate: 
	pdflatex $(ARXIVFILE).tex
	open $(ARXIVFILE).pdf



#Generate a pdf file using a modified python script from et_eq
local: 
	local_build_withauthors.py --build-dir . --filename spock_localbuild --title-input --n-runs-after-bibtex 2
	open $(PAPER).pdf

open:
	open $(PAPER).pdf

#quick update (single compile)
update: $(PAPER).tex
	pdflatex $(PAPER); \
	open $(PAPER).pdf


#Changes (marked with \change{} commands) are highlighted in blue text
changetext:
	echo "\\\changetexttrue" > $(PAPER)-options.tex; \
	echo "\\endinput" >> $(PAPER)-options.tex; \
	pdflatex $(PAPER); \
	bibtex $(PAPER); \
	pdflatex $(PAPER); \
	pdflatex $(PAPER); \
	rm $(PAPER)-options.tex; \
	mv $(PAPER).pdf $(PAPER)_changetext.pdf; \
	open $(PAPER)_changetext.pdf
