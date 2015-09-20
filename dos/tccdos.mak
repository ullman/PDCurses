# Borland MAKE Makefile for PDCurses library - DOS Borland Turbo C 2.01
# ported by Henrik Ullman
# Usage: make -f[path\]tccdos.mak [DEBUG=] [target]
#
# where target can be any of:
# [all|pdcurses.lib|dist]
#
# Demos are not compiled due to missing header files in Turbo C 2.01
#
# Change the memory MODEL here, if desired
#
#

MODEL = l

O = obj

!if !$d(PDCURSES_SRCDIR)
PDCURSES_SRCDIR = ..
!endif

!include "$(PDCURSES_SRCDIR)\version.mif"
!include "$(PDCURSES_SRCDIR)\libobjs.mif"

osdir           = $(PDCURSES_SRCDIR)\dos

!if $d(DEBUG)
CFLAGS          = -N -v -y -DPDCDEBUG 
!else
CFLAGS          = -O 
!endif

CPPFLAGS        = -I$(PDCURSES_SRCDIR)
CC                      = tcc

BUILD           = $(CC) -1- -K -G -rd -d -w-eff -w-par -c \
-m$(MODEL) $(CFLAGS) $(CPPFLAGS)

LIBEXE          = tlib /C /E

LIBCURSES       = pdcurses.lib


all:    $(LIBCURSES) dist




clean:
	-del *.obj
	-del *.lib
	-del *.map
	-del *.zip

#demos:  $(DEMOS)

$(LIBCURSES) : $(LIBOBJS) $(PDCOBJS)

       -del $(LIBCURSES)
       $(LIBEXE) $(LIBCURSES) @$(osdir)\bccdos.lrf


$(LIBOBJS):
	$(BUILD) $(srcdir)/$*.c

$(PDCOBJS):
	$(BUILD) $(osdir)/$*.c



PLATFORM1 = Borland Turbo C 2.01
PLATFORM2 = Borland Turbo C 2.01 for DOS
ARCNAME = pdc$(VER)tcc
DISTDIR = dist_dir

dist: $(PDCLIBS)
	-mkdir $(DISTDIR)
	-copy $(LIBCURSES) $(DISTDIR)
	-copy $(PDCURSES_SRCDIR)\curses.h $(DISTDIR)
	-copy $(PDCURSES_SRCDIR)\panel.h $(DISTDIR)
	-copy $(PDCURSES_SRCDIR)\HISTORY $(DISTDIR)
	-copy $(PDCURSES_SRCDIR)\README $(DISTDIR)
	-zip -9jrX $(ARCNAME) $(DISTDIR)
	-deltree /Y $(DISTDIR) 

