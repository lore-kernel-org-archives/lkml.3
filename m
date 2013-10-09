Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3JIHB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:01:59 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:40769 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3JIHBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:01:54 -0400
Date: Wed, 9 Oct 2013 09:01:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [GIT PULL] tools/perf/build: Speed up the perf build system
Message-ID: <20131009070149.GA32023@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

Please pull the tools/perf/build git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tmp.tools/perf/build

   # HEAD: 165108a92fc554d51e73b143b69b77e7c278da78 tools/perf/build: Clean up feature_print_code()

This tree contains the build system speedup series described at:

   https://lkml.org/lkml/2013/10/7/199

Reviewed by David Ahern and Jiri Olsa (thanks guys!).

 Thanks,

	Ingo

------------------>
Ingo Molnar (52):
      tools/perf: Standardize feature support define names to: HAVE_{FEATURE}_SUPPORT
      tools/perf/build: Add feature check core code
      tools/perf/build: Add 'autodep' functionality, generate feature test dependencies automatically
      tools/perf/build: Split out feature check: 'libnuma'
      tools/perf/build: Split out feature check: 'stackprotector-all'
      tools/perf/build: Split out feature check: 'stackprotector'
      tools/perf/build: Split out feature check: 'volatile-register-var'
      tools/perf/build: Split out feature check: 'fortify-source'
      tools/perf/build: Split out feature check: 'bionic'
      tools/perf/build: Clean up the libelf logic in config/Makefile
      tools/perf/build: Split out feature check: 'libelf'
      tools/perf/build: Split out feature check: 'glibc'
      tools/perf/build: Split out feature check: 'dwarf'
      tools/perf/build: Clean up the mmap logic in config/Makefile
      tools/perf/build: Split out feature check: 'libelf-mmap'
      tools/perf/build: Split out feature check: 'libelf-getphdrnum'
      tools/perf/build: Clean up the libunwind logic in config/Makefile
      tools/perf/build: Split out feature check: 'libunwind'
      tools/perf/build: Split out feature check: 'libaudit'
      tools/perf/build: Split out feature check: 'libslang'
      tools/perf/build: Split out feature check: 'gtk2'
      tools/perf/build: Split out feature check: 'gtk2-infobar'
      tools/perf/build: Split out feature check: 'libperl'
      tools/perf/build: Split out feature check: 'libpython'
      tools/perf/build: Split out feature check: 'libpython-version'
      tools/perf/build: Split out feature check: 'libbfd'
      tools/perf/build: Split out feature check: 'strlcpy'
      tools/perf/build: Split out feature check: 'on-exit'
      tools/perf/build: Split out feature check: 'backtrace'
      tools/perf: Clean up util/include/linux/compiler.h
      tools/perf: Turn strlcpy() into a __weak function
      tools/perf/build: Speed up auto-detection of features by adding a 'test-all' target
      tools/perf/build: Speed up git-version test on re-make
      tools/perf/build: Speed up the final link
      tools/perf: Fix double/triple-build of the feature detection logic during 'make install' et al
      tools/perf/build: Invoke feature-checks 'clean' target from the main Makefile
      tools/perf/build: Speed up auto-detection
      tools/perf/build: Improve printout-of auto-detected features
      tools/perf/build: Automatically build in parallel, based on number of CPUs in the system
      tools/perf/build: Flip Makefile.parallel and Makefile.perf
      tools/perf/build: Standardize the various messages output by parallel make
      tools/perf/build: Split out feature checks: 'liberty', 'liberty-z', 'cplus-demangle'
      tools/perf/build: Remove unused config/feature-tests.mak
      tools/perf/build: Clean up various testcases
      tools/perf/build: Collapse the test-all.c testcase
      tools/perf/build: Pass through all targets to Makefile.perf
      tools/perf/build: Make sure autodep feature binaries honor the O= setting
      tools/perf/build: Exclude MAKEFLAGS from nested invocation
      tools/perf/build: Fix non-canonical directory names in O=
      tools/perf/build: Fix O=/some/dir perf.o type of targets
      tools/perf/build: Harmonize the style of the feature testcases
      tools/perf/build: Pass through LDFLAGS to feature tests

Jiri Olsa (1):
      tools/perf/build: Clean up feature_print_code()


 tools/perf/Documentation/Makefile                  |  17 +-
 tools/perf/Makefile                                | 841 ++------------------
 tools/perf/Makefile.perf                           | 856 +++++++++++++++++++++
 tools/perf/arch/x86/include/perf_regs.h            |   6 +-
 tools/perf/arch/x86/util/unwind.c                  |   4 +-
 tools/perf/bench/mem-memcpy-arch.h                 |   2 +-
 tools/perf/bench/mem-memcpy.c                      |   2 +-
 tools/perf/bench/mem-memset-arch.h                 |   2 +-
 tools/perf/bench/mem-memset.c                      |   2 +-
 tools/perf/builtin-bench.c                         |   4 +-
 tools/perf/builtin-inject.c                        |   2 +-
 tools/perf/builtin-probe.c                         |  14 +-
 tools/perf/builtin-record.c                        |  12 +-
 tools/perf/config/Makefile                         | 337 +++++---
 tools/perf/config/feature-checks/Makefile          | 148 ++++
 tools/perf/config/feature-checks/test-all.c        | 106 +++
 tools/perf/config/feature-checks/test-backtrace.c  |  13 +
 tools/perf/config/feature-checks/test-bionic.c     |   6 +
 .../config/feature-checks/test-cplus-demangle.c    |  14 +
 tools/perf/config/feature-checks/test-dwarf.c      |  10 +
 .../config/feature-checks/test-fortify-source.c    |   6 +
 tools/perf/config/feature-checks/test-glibc.c      |   8 +
 .../perf/config/feature-checks/test-gtk2-infobar.c |  11 +
 tools/perf/config/feature-checks/test-gtk2.c       |  10 +
 tools/perf/config/feature-checks/test-hello.c      |   6 +
 tools/perf/config/feature-checks/test-libaudit.c   |  10 +
 tools/perf/config/feature-checks/test-libbfd.c     |  15 +
 .../config/feature-checks/test-libelf-getphdrnum.c |   8 +
 .../perf/config/feature-checks/test-libelf-mmap.c  |   8 +
 tools/perf/config/feature-checks/test-libelf.c     |   8 +
 tools/perf/config/feature-checks/test-libnuma.c    |   9 +
 tools/perf/config/feature-checks/test-libperl.c    |   9 +
 .../config/feature-checks/test-libpython-version.c |  10 +
 tools/perf/config/feature-checks/test-libpython.c  |   8 +
 tools/perf/config/feature-checks/test-libslang.c   |   6 +
 tools/perf/config/feature-checks/test-libunwind.c  |  27 +
 tools/perf/config/feature-checks/test-on-exit.c    |  15 +
 .../feature-checks/test-stackprotector-all.c       |   6 +
 .../config/feature-checks/test-stackprotector.c    |   6 +
 .../feature-checks/test-volatile-register-var.c    |   6 +
 tools/perf/config/feature-tests.mak                | 246 ------
 tools/perf/config/utilities.mak                    |  14 -
 tools/perf/perf.c                                  |   4 +-
 tools/perf/ui/gtk/browser.c                        |   2 +-
 tools/perf/ui/gtk/gtk.h                            |   4 +-
 tools/perf/ui/gtk/util.c                           |   4 +-
 tools/perf/ui/ui.h                                 |   4 +-
 tools/perf/util/annotate.h                         |   4 +-
 tools/perf/util/cache.h                            |   3 +-
 tools/perf/util/generate-cmdlist.sh                |   4 +-
 tools/perf/util/hist.h                             |   4 +-
 tools/perf/util/include/dwarf-regs.h               |   2 +-
 tools/perf/util/include/linux/compiler.h           |  19 +-
 tools/perf/util/map.c                              |   2 +-
 tools/perf/util/path.c                             |  10 +-
 tools/perf/util/perf_regs.h                        |   4 +-
 tools/perf/util/probe-event.c                      |   4 +-
 tools/perf/util/probe-finder.h                     |   4 +-
 tools/perf/util/symbol-elf.c                       |   2 +-
 tools/perf/util/symbol.h                           |   8 +-
 tools/perf/util/unwind.h                           |   4 +-
 tools/perf/util/util.c                             |   4 +-
 62 files changed, 1688 insertions(+), 1258 deletions(-)
 create mode 100644 tools/perf/Makefile.perf
 create mode 100644 tools/perf/config/feature-checks/Makefile
 create mode 100644 tools/perf/config/feature-checks/test-all.c
 create mode 100644 tools/perf/config/feature-checks/test-backtrace.c
 create mode 100644 tools/perf/config/feature-checks/test-bionic.c
 create mode 100644 tools/perf/config/feature-checks/test-cplus-demangle.c
 create mode 100644 tools/perf/config/feature-checks/test-dwarf.c
 create mode 100644 tools/perf/config/feature-checks/test-fortify-source.c
 create mode 100644 tools/perf/config/feature-checks/test-glibc.c
 create mode 100644 tools/perf/config/feature-checks/test-gtk2-infobar.c
 create mode 100644 tools/perf/config/feature-checks/test-gtk2.c
 create mode 100644 tools/perf/config/feature-checks/test-hello.c
 create mode 100644 tools/perf/config/feature-checks/test-libaudit.c
 create mode 100644 tools/perf/config/feature-checks/test-libbfd.c
 create mode 100644 tools/perf/config/feature-checks/test-libelf-getphdrnum.c
 create mode 100644 tools/perf/config/feature-checks/test-libelf-mmap.c
 create mode 100644 tools/perf/config/feature-checks/test-libelf.c
 create mode 100644 tools/perf/config/feature-checks/test-libnuma.c
 create mode 100644 tools/perf/config/feature-checks/test-libperl.c
 create mode 100644 tools/perf/config/feature-checks/test-libpython-version.c
 create mode 100644 tools/perf/config/feature-checks/test-libpython.c
 create mode 100644 tools/perf/config/feature-checks/test-libslang.c
 create mode 100644 tools/perf/config/feature-checks/test-libunwind.c
 create mode 100644 tools/perf/config/feature-checks/test-on-exit.c
 create mode 100644 tools/perf/config/feature-checks/test-stackprotector-all.c
 create mode 100644 tools/perf/config/feature-checks/test-stackprotector.c
 create mode 100644 tools/perf/config/feature-checks/test-volatile-register-var.c
 delete mode 100644 tools/perf/config/feature-tests.mak

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index 5a37a7c..eaa477f 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -192,13 +192,14 @@ do-install-man: man
 
 install-man: check-man-tools man
 
-try-install-man:
 ifdef missing_tools
-	$(warning Please install $(missing_tools) to have the man pages installed)
+  DO_INSTALL_MAN = $(warning Please install $(missing_tools) to have the man pages installed)
 else
-	$(MAKE) do-install-man
+  DO_INSTALL_MAN = do-install-man
 endif
 
+try-install-man: $(DO_INSTALL_MAN)
+
 install-info: info
 	$(INSTALL) -d -m 755 $(DESTDIR)$(infodir)
 	$(INSTALL) -m 644 $(OUTPUT)perf.info $(OUTPUT)perfman.info $(DESTDIR)$(infodir)
@@ -216,14 +217,6 @@ install-pdf: pdf
 #install-html: html
 #	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(DESTDIR)$(htmldir)
 
-ifneq ($(MAKECMDGOALS),clean)
-ifneq ($(MAKECMDGOALS),tags)
-$(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
-	$(QUIET_SUBDIR0)../ $(QUIET_SUBDIR1) $(OUTPUT)PERF-VERSION-FILE
-
--include $(OUTPUT)PERF-VERSION-FILE
-endif
-endif
 
 #
 # Determine "include::" file references in asciidoc files.
@@ -342,5 +335,3 @@ $(patsubst %.txt,%.html,$(wildcard howto/*.txt)): %.html : %.txt
 
 #quick-install-html:
 #	'$(SHELL_PATH_SQ)' ./install-doc-quick.sh $(HTML_REF) $(DESTDIR)$(htmldir)
-
-.PHONY: .FORCE-PERF-VERSION-FILE
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 64c043b..9580ebe 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1,819 +1,66 @@
-include ../scripts/Makefile.include
-
-# The default target of this Makefile is...
-all:
-
-include config/utilities.mak
-
-# Define V to have a more verbose compile.
-#
-# Define O to save output files in a separate directory.
-#
-# Define ARCH as name of target architecture if you want cross-builds.
-#
-# Define CROSS_COMPILE as prefix name of compiler if you want cross-builds.
-#
-# Define NO_LIBPERL to disable perl script extension.
-#
-# Define NO_LIBPYTHON to disable python script extension.
-#
-# Define PYTHON to point to the python binary if the default
-# `python' is not correct; for example: PYTHON=python2
-#
-# Define PYTHON_CONFIG to point to the python-config binary if
-# the default `$(PYTHON)-config' is not correct.
 #
-# Define ASCIIDOC8 if you want to format documentation with AsciiDoc 8
+# This is a simple wrapper Makefile that calls the main Makefile.perf
+# with a -j option to do parallel builds
 #
-# Define DOCBOOK_XSL_172 if you want to format man pages with DocBook XSL v1.72.
+# If you want to invoke the perf build in some non-standard way then
+# you can use the 'make -f Makefile.perf' method to invoke it.
 #
-# Define LDFLAGS=-static to build a static binary.
-#
-# Define EXTRA_CFLAGS=-m64 or EXTRA_CFLAGS=-m32 as appropriate for cross-builds.
-#
-# Define NO_DWARF if you do not want debug-info analysis feature at all.
-#
-# Define WERROR=0 to disable treating any warnings as errors.
-#
-# Define NO_NEWT if you do not want TUI support. (deprecated)
-#
-# Define NO_SLANG if you do not want TUI support.
-#
-# Define NO_GTK2 if you do not want GTK+ GUI support.
+
 #
-# Define NO_DEMANGLE if you do not want C++ symbol demangling.
+# Clear out the built-in rules GNU make defines by default (such as .o targets),
+# so that we pass through all targets to Makefile.perf:
 #
-# Define NO_LIBELF if you do not want libelf dependency (e.g. cross-builds)
+.SUFFIXES:
+
 #
-# Define NO_LIBUNWIND if you do not want libunwind dependency for dwarf
-# backtrace post unwind.
+# We don't want to pass along options like -j:
 #
-# Define NO_BACKTRACE if you do not want stack backtrace debug feature
+unexport MAKEFLAGS
+
 #
-# Define NO_LIBNUMA if you do not want numa perf benchmark
+# Do a parallel build with multiple jobs, based on the number of CPUs online
+# in this system: 'make -j8' on a 8-CPU system, etc.
 #
-# Define NO_LIBAUDIT if you do not want libaudit support
+# (To override it, run 'make JOBS=1' and similar.)
 #
-# Define NO_LIBBIONIC if you do not want bionic support
-
-ifeq ($(srctree),)
-srctree := $(patsubst %/,%,$(dir $(shell pwd)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
-#$(info Determined 'srctree' to be $(srctree))
-endif
-
-ifneq ($(objtree),)
-#$(info Determined 'objtree' to be $(objtree))
-endif
-
-ifneq ($(OUTPUT),)
-#$(info Determined 'OUTPUT' to be $(OUTPUT))
-endif
-
-$(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
-	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
-
-CC = $(CROSS_COMPILE)gcc
-AR = $(CROSS_COMPILE)ar
-
-RM      = rm -f
-MKDIR   = mkdir
-FIND    = find
-INSTALL = install
-FLEX    = flex
-BISON   = bison
-STRIP   = strip
-
-LK_DIR          = $(srctree)/tools/lib/lk/
-TRACE_EVENT_DIR = $(srctree)/tools/lib/traceevent/
-
-# include config/Makefile by default and rule out
-# non-config cases
-config := 1
-
-NON_CONFIG_TARGETS := clean TAGS tags cscope help
-
-ifdef MAKECMDGOALS
-ifeq ($(filter-out $(NON_CONFIG_TARGETS),$(MAKECMDGOALS)),)
-  config := 0
-endif
-endif
-
-ifeq ($(config),1)
-include config/Makefile
+ifeq ($(JOBS),)
+  JOBS := $(shell grep -c ^processor /proc/cpuinfo 2>/dev/null)
+  ifeq ($(JOBS),)
+    JOBS := 1
+  endif
 endif
 
-export prefix bindir sharedir sysconfdir
-
-# sparse is architecture-neutral, which means that we need to tell it
-# explicitly what architecture to check for. Fix this up for yours..
-SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
-
-# Guard against environment variables
-BUILTIN_OBJS =
-LIB_H =
-LIB_OBJS =
-PYRF_OBJS =
-SCRIPT_SH =
-
-SCRIPT_SH += perf-archive.sh
-
-grep-libs = $(filter -l%,$(1))
-strip-libs = $(filter-out -l%,$(1))
-
-ifneq ($(OUTPUT),)
-  TE_PATH=$(OUTPUT)
-ifneq ($(subdir),)
-  LK_PATH=$(OUTPUT)/../lib/lk/
-else
-  LK_PATH=$(OUTPUT)
-endif
-else
-  TE_PATH=$(TRACE_EVENT_DIR)
-  LK_PATH=$(LK_DIR)
+#
+# Only pass canonical directory names as the output directory:
+#
+ifneq ($(O),)
+  FULL_O := $(shell readlink -f $(O))
 endif
 
-LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
-export LIBTRACEEVENT
-
-LIBLK = $(LK_PATH)liblk.a
-export LIBLK
-
-# python extension build directories
-PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
-PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
-PYTHON_EXTBUILD_TMP := $(PYTHON_EXTBUILD)tmp/
-export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
-
-python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
+define print_msg
+  @printf '    BUILD: Doing '\''make \033[33m-j'$(JOBS)'\033[m'\'' parallel build\n'
+endef
 
-PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
-PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT) $(LIBLK)
+define make
+  @$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) O=$(FULL_O) $@
+endef
 
-$(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
-	$(QUIET_GEN)CFLAGS='$(CFLAGS)' $(PYTHON_WORD) util/setup.py \
-	  --quiet build_ext; \
-	mkdir -p $(OUTPUT)python && \
-	cp $(PYTHON_EXTBUILD_LIB)perf.so $(OUTPUT)python/
 #
-# No Perl scripts right now:
+# Needed if no target specified:
 #
-
-SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
+all:
+	$(print_msg)
+	$(make)
 
 #
-# Single 'perf' binary right now:
+# The clean target is not really parallel, don't print the jobs info:
 #
-PROGRAMS += $(OUTPUT)perf
-
-# what 'all' will build and 'install' will install, in perfexecdir
-ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS)
-
-# what 'all' will build but not install in perfexecdir
-OTHER_PROGRAMS = $(OUTPUT)perf
-
-# Set paths to tools early so that they can be used for version tests.
-ifndef SHELL_PATH
-  SHELL_PATH = /bin/sh
-endif
-ifndef PERL_PATH
-  PERL_PATH = /usr/bin/perl
-endif
-
-export PERL_PATH
-
-$(OUTPUT)util/parse-events-flex.c: util/parse-events.l $(OUTPUT)util/parse-events-bison.c
-	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
-
-$(OUTPUT)util/parse-events-bison.c: util/parse-events.y
-	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c -p parse_events_
-
-$(OUTPUT)util/pmu-flex.c: util/pmu.l $(OUTPUT)util/pmu-bison.c
-	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
-
-$(OUTPUT)util/pmu-bison.c: util/pmu.y
-	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c -p perf_pmu_
-
-$(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
-$(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
-
-LIB_FILE=$(OUTPUT)libperf.a
-
-LIB_H += ../../include/uapi/linux/perf_event.h
-LIB_H += ../../include/linux/rbtree.h
-LIB_H += ../../include/linux/list.h
-LIB_H += ../../include/uapi/linux/const.h
-LIB_H += ../../include/linux/hash.h
-LIB_H += ../../include/linux/stringify.h
-LIB_H += util/include/linux/bitmap.h
-LIB_H += util/include/linux/bitops.h
-LIB_H += util/include/linux/compiler.h
-LIB_H += util/include/linux/const.h
-LIB_H += util/include/linux/ctype.h
-LIB_H += util/include/linux/kernel.h
-LIB_H += util/include/linux/list.h
-LIB_H += util/include/linux/export.h
-LIB_H += util/include/linux/magic.h
-LIB_H += util/include/linux/poison.h
-LIB_H += util/include/linux/prefetch.h
-LIB_H += util/include/linux/rbtree.h
-LIB_H += util/include/linux/rbtree_augmented.h
-LIB_H += util/include/linux/string.h
-LIB_H += util/include/linux/types.h
-LIB_H += util/include/linux/linkage.h
-LIB_H += util/include/asm/asm-offsets.h
-LIB_H += util/include/asm/bug.h
-LIB_H += util/include/asm/byteorder.h
-LIB_H += util/include/asm/hweight.h
-LIB_H += util/include/asm/swab.h
-LIB_H += util/include/asm/system.h
-LIB_H += util/include/asm/uaccess.h
-LIB_H += util/include/dwarf-regs.h
-LIB_H += util/include/asm/dwarf2.h
-LIB_H += util/include/asm/cpufeature.h
-LIB_H += util/include/asm/unistd_32.h
-LIB_H += util/include/asm/unistd_64.h
-LIB_H += perf.h
-LIB_H += util/annotate.h
-LIB_H += util/cache.h
-LIB_H += util/callchain.h
-LIB_H += util/build-id.h
-LIB_H += util/debug.h
-LIB_H += util/sysfs.h
-LIB_H += util/pmu.h
-LIB_H += util/event.h
-LIB_H += util/evsel.h
-LIB_H += util/evlist.h
-LIB_H += util/exec_cmd.h
-LIB_H += util/types.h
-LIB_H += util/levenshtein.h
-LIB_H += util/machine.h
-LIB_H += util/map.h
-LIB_H += util/parse-options.h
-LIB_H += util/parse-events.h
-LIB_H += util/quote.h
-LIB_H += util/util.h
-LIB_H += util/xyarray.h
-LIB_H += util/header.h
-LIB_H += util/help.h
-LIB_H += util/session.h
-LIB_H += util/strbuf.h
-LIB_H += util/strlist.h
-LIB_H += util/strfilter.h
-LIB_H += util/svghelper.h
-LIB_H += util/tool.h
-LIB_H += util/run-command.h
-LIB_H += util/sigchain.h
-LIB_H += util/dso.h
-LIB_H += util/symbol.h
-LIB_H += util/color.h
-LIB_H += util/values.h
-LIB_H += util/sort.h
-LIB_H += util/hist.h
-LIB_H += util/thread.h
-LIB_H += util/thread_map.h
-LIB_H += util/trace-event.h
-LIB_H += util/probe-finder.h
-LIB_H += util/dwarf-aux.h
-LIB_H += util/probe-event.h
-LIB_H += util/pstack.h
-LIB_H += util/cpumap.h
-LIB_H += util/top.h
-LIB_H += $(ARCH_INCLUDE)
-LIB_H += util/cgroup.h
-LIB_H += $(LIB_INCLUDE)traceevent/event-parse.h
-LIB_H += util/target.h
-LIB_H += util/rblist.h
-LIB_H += util/intlist.h
-LIB_H += util/perf_regs.h
-LIB_H += util/unwind.h
-LIB_H += util/vdso.h
-LIB_H += ui/helpline.h
-LIB_H += ui/progress.h
-LIB_H += ui/util.h
-LIB_H += ui/ui.h
-
-LIB_OBJS += $(OUTPUT)util/abspath.o
-LIB_OBJS += $(OUTPUT)util/alias.o
-LIB_OBJS += $(OUTPUT)util/annotate.o
-LIB_OBJS += $(OUTPUT)util/build-id.o
-LIB_OBJS += $(OUTPUT)util/config.o
-LIB_OBJS += $(OUTPUT)util/ctype.o
-LIB_OBJS += $(OUTPUT)util/sysfs.o
-LIB_OBJS += $(OUTPUT)util/pmu.o
-LIB_OBJS += $(OUTPUT)util/environment.o
-LIB_OBJS += $(OUTPUT)util/event.o
-LIB_OBJS += $(OUTPUT)util/evlist.o
-LIB_OBJS += $(OUTPUT)util/evsel.o
-LIB_OBJS += $(OUTPUT)util/exec_cmd.o
-LIB_OBJS += $(OUTPUT)util/help.o
-LIB_OBJS += $(OUTPUT)util/levenshtein.o
-LIB_OBJS += $(OUTPUT)util/parse-options.o
-LIB_OBJS += $(OUTPUT)util/parse-events.o
-LIB_OBJS += $(OUTPUT)util/path.o
-LIB_OBJS += $(OUTPUT)util/rbtree.o
-LIB_OBJS += $(OUTPUT)util/bitmap.o
-LIB_OBJS += $(OUTPUT)util/hweight.o
-LIB_OBJS += $(OUTPUT)util/run-command.o
-LIB_OBJS += $(OUTPUT)util/quote.o
-LIB_OBJS += $(OUTPUT)util/strbuf.o
-LIB_OBJS += $(OUTPUT)util/string.o
-LIB_OBJS += $(OUTPUT)util/strlist.o
-LIB_OBJS += $(OUTPUT)util/strfilter.o
-LIB_OBJS += $(OUTPUT)util/top.o
-LIB_OBJS += $(OUTPUT)util/usage.o
-LIB_OBJS += $(OUTPUT)util/wrapper.o
-LIB_OBJS += $(OUTPUT)util/sigchain.o
-LIB_OBJS += $(OUTPUT)util/dso.o
-LIB_OBJS += $(OUTPUT)util/symbol.o
-LIB_OBJS += $(OUTPUT)util/symbol-elf.o
-LIB_OBJS += $(OUTPUT)util/color.o
-LIB_OBJS += $(OUTPUT)util/pager.o
-LIB_OBJS += $(OUTPUT)util/header.o
-LIB_OBJS += $(OUTPUT)util/callchain.o
-LIB_OBJS += $(OUTPUT)util/values.o
-LIB_OBJS += $(OUTPUT)util/debug.o
-LIB_OBJS += $(OUTPUT)util/machine.o
-LIB_OBJS += $(OUTPUT)util/map.o
-LIB_OBJS += $(OUTPUT)util/pstack.o
-LIB_OBJS += $(OUTPUT)util/session.o
-LIB_OBJS += $(OUTPUT)util/thread.o
-LIB_OBJS += $(OUTPUT)util/thread_map.o
-LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
-LIB_OBJS += $(OUTPUT)util/parse-events-flex.o
-LIB_OBJS += $(OUTPUT)util/parse-events-bison.o
-LIB_OBJS += $(OUTPUT)util/pmu-flex.o
-LIB_OBJS += $(OUTPUT)util/pmu-bison.o
-LIB_OBJS += $(OUTPUT)util/trace-event-read.o
-LIB_OBJS += $(OUTPUT)util/trace-event-info.o
-LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
-LIB_OBJS += $(OUTPUT)util/svghelper.o
-LIB_OBJS += $(OUTPUT)util/sort.o
-LIB_OBJS += $(OUTPUT)util/hist.o
-LIB_OBJS += $(OUTPUT)util/probe-event.o
-LIB_OBJS += $(OUTPUT)util/util.o
-LIB_OBJS += $(OUTPUT)util/xyarray.o
-LIB_OBJS += $(OUTPUT)util/cpumap.o
-LIB_OBJS += $(OUTPUT)util/cgroup.o
-LIB_OBJS += $(OUTPUT)util/target.o
-LIB_OBJS += $(OUTPUT)util/rblist.o
-LIB_OBJS += $(OUTPUT)util/intlist.o
-LIB_OBJS += $(OUTPUT)util/vdso.o
-LIB_OBJS += $(OUTPUT)util/stat.o
-LIB_OBJS += $(OUTPUT)util/record.o
-
-LIB_OBJS += $(OUTPUT)ui/setup.o
-LIB_OBJS += $(OUTPUT)ui/helpline.o
-LIB_OBJS += $(OUTPUT)ui/progress.o
-LIB_OBJS += $(OUTPUT)ui/util.o
-LIB_OBJS += $(OUTPUT)ui/hist.o
-LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
-
-LIB_OBJS += $(OUTPUT)arch/common.o
-
-LIB_OBJS += $(OUTPUT)tests/parse-events.o
-LIB_OBJS += $(OUTPUT)tests/dso-data.o
-LIB_OBJS += $(OUTPUT)tests/attr.o
-LIB_OBJS += $(OUTPUT)tests/vmlinux-kallsyms.o
-LIB_OBJS += $(OUTPUT)tests/open-syscall.o
-LIB_OBJS += $(OUTPUT)tests/open-syscall-all-cpus.o
-LIB_OBJS += $(OUTPUT)tests/open-syscall-tp-fields.o
-LIB_OBJS += $(OUTPUT)tests/mmap-basic.o
-LIB_OBJS += $(OUTPUT)tests/perf-record.o
-LIB_OBJS += $(OUTPUT)tests/rdpmc.o
-LIB_OBJS += $(OUTPUT)tests/evsel-roundtrip-name.o
-LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
-LIB_OBJS += $(OUTPUT)tests/pmu.o
-LIB_OBJS += $(OUTPUT)tests/hists_link.o
-LIB_OBJS += $(OUTPUT)tests/python-use.o
-LIB_OBJS += $(OUTPUT)tests/bp_signal.o
-LIB_OBJS += $(OUTPUT)tests/bp_signal_overflow.o
-LIB_OBJS += $(OUTPUT)tests/task-exit.o
-LIB_OBJS += $(OUTPUT)tests/sw-clock.o
-ifeq ($(ARCH),x86)
-LIB_OBJS += $(OUTPUT)tests/perf-time-to-tsc.o
-endif
-LIB_OBJS += $(OUTPUT)tests/code-reading.o
-LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
-LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
-
-BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
-BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
-# Benchmark modules
-BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
-BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
-ifeq ($(RAW_ARCH),x86_64)
-BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
-BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
-endif
-BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
-BUILTIN_OBJS += $(OUTPUT)bench/mem-memset.o
-
-BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
-BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
-BUILTIN_OBJS += $(OUTPUT)builtin-help.o
-BUILTIN_OBJS += $(OUTPUT)builtin-sched.o
-BUILTIN_OBJS += $(OUTPUT)builtin-buildid-list.o
-BUILTIN_OBJS += $(OUTPUT)builtin-buildid-cache.o
-BUILTIN_OBJS += $(OUTPUT)builtin-list.o
-BUILTIN_OBJS += $(OUTPUT)builtin-record.o
-BUILTIN_OBJS += $(OUTPUT)builtin-report.o
-BUILTIN_OBJS += $(OUTPUT)builtin-stat.o
-BUILTIN_OBJS += $(OUTPUT)builtin-timechart.o
-BUILTIN_OBJS += $(OUTPUT)builtin-top.o
-BUILTIN_OBJS += $(OUTPUT)builtin-script.o
-BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
-BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
-BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
-BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
-BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
-BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
-BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
-
-PERFLIBS = $(LIB_FILE) $(LIBLK) $(LIBTRACEEVENT)
-
-# We choose to avoid "if .. else if .. else .. endif endif"
-# because maintaining the nesting to match is a pain.  If
-# we had "elif" things would have been much nicer...
-
--include arch/$(ARCH)/Makefile
-
-ifneq ($(OUTPUT),)
-  CFLAGS += -I$(OUTPUT)
-endif
-
-ifdef NO_LIBELF
-EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
-
-# Remove ELF/DWARF dependent codes
-LIB_OBJS := $(filter-out $(OUTPUT)util/symbol-elf.o,$(LIB_OBJS))
-LIB_OBJS := $(filter-out $(OUTPUT)util/dwarf-aux.o,$(LIB_OBJS))
-LIB_OBJS := $(filter-out $(OUTPUT)util/probe-event.o,$(LIB_OBJS))
-LIB_OBJS := $(filter-out $(OUTPUT)util/probe-finder.o,$(LIB_OBJS))
-
-BUILTIN_OBJS := $(filter-out $(OUTPUT)builtin-probe.o,$(BUILTIN_OBJS))
-
-# Use minimal symbol handling
-LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
-
-else # NO_LIBELF
-ifndef NO_DWARF
-  LIB_OBJS += $(OUTPUT)util/probe-finder.o
-  LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
-endif # NO_DWARF
-endif # NO_LIBELF
-
-ifndef NO_LIBUNWIND
-  LIB_OBJS += $(OUTPUT)util/unwind.o
-endif
-LIB_OBJS += $(OUTPUT)tests/keep-tracking.o
-
-ifndef NO_LIBAUDIT
-  BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
-endif
+clean:
+	$(make)
 
-ifndef NO_SLANG
-  LIB_OBJS += $(OUTPUT)ui/browser.o
-  LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
-  LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
-  LIB_OBJS += $(OUTPUT)ui/browsers/map.o
-  LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
-  LIB_OBJS += $(OUTPUT)ui/tui/setup.o
-  LIB_OBJS += $(OUTPUT)ui/tui/util.o
-  LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
-  LIB_OBJS += $(OUTPUT)ui/tui/progress.o
-  LIB_H += ui/browser.h
-  LIB_H += ui/browsers/map.h
-  LIB_H += ui/keysyms.h
-  LIB_H += ui/libslang.h
-endif
-
-ifndef NO_GTK2
-  LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/hists.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/util.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/annotate.o
-endif
-
-ifndef NO_LIBPERL
-  LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
-  LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
-endif
-
-ifndef NO_LIBPYTHON
-  LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
-  LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
-endif
-
-ifeq ($(NO_PERF_REGS),0)
-  ifeq ($(ARCH),x86)
-    LIB_H += arch/x86/include/perf_regs.h
-  endif
-endif
-
-ifndef NO_LIBNUMA
-  BUILTIN_OBJS += $(OUTPUT)bench/numa.o
-endif
-
-ifdef ASCIIDOC8
-  export ASCIIDOC8
-endif
-
-LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
-
-export INSTALL SHELL_PATH
-
-### Build rules
-
-SHELL = $(SHELL_PATH)
-
-all: shell_compatibility_test $(ALL_PROGRAMS) $(LANG_BINDINGS) $(OTHER_PROGRAMS)
-
-please_set_SHELL_PATH_to_a_more_modern_shell:
-	@$$(:)
-
-shell_compatibility_test: please_set_SHELL_PATH_to_a_more_modern_shell
-
-strip: $(PROGRAMS) $(OUTPUT)perf
-	$(STRIP) $(STRIP_OPTS) $(PROGRAMS) $(OUTPUT)perf
-
-$(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -include $(OUTPUT)PERF-VERSION-FILE \
-		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
-		$(CFLAGS) -c $(filter %.c,$^) -o $@
-
-$(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
-	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(OUTPUT)perf.o \
-               $(BUILTIN_OBJS) $(LIBS) -o $@
-
-$(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
-		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
-		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
-		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
-
-$(OUTPUT)builtin-timechart.o: builtin-timechart.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
-		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
-		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
-		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
-
-$(OUTPUT)common-cmds.h: util/generate-cmdlist.sh command-list.txt
-
-$(OUTPUT)common-cmds.h: $(wildcard Documentation/perf-*.txt)
-	$(QUIET_GEN). util/generate-cmdlist.sh > $@+ && mv $@+ $@
-
-$(SCRIPTS) : % : %.sh
-	$(QUIET_GEN)$(INSTALL) '$@.sh' '$(OUTPUT)$@'
-
-# These can record PERF_VERSION
-$(OUTPUT)perf.o perf.spec \
-	$(SCRIPTS) \
-	: $(OUTPUT)PERF-VERSION-FILE
-
-.SUFFIXES:
-.SUFFIXES: .o .c .S .s
-
-# These two need to be here so that when O= is not used they take precedence
-# over the general rule for .o
-
-$(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(CFLAGS) -w $<
-
-$(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w $<
-
-$(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $<
-$(OUTPUT)%.i: %.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -E $(CFLAGS) $<
-$(OUTPUT)%.s: %.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -S $(CFLAGS) $<
-$(OUTPUT)%.o: %.S
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $<
-$(OUTPUT)%.s: %.S
-	$(QUIET_CC)$(CC) -o $@ -E $(CFLAGS) $<
-
-$(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
-		'-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
-		'-DPREFIX="$(prefix_SQ)"' \
-		$<
-
-$(OUTPUT)tests/attr.o: tests/attr.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
-		'-DBINDIR="$(bindir_SQ)"' -DPYTHON='"$(PYTHON_WORD)"' \
-		$<
-
-$(OUTPUT)tests/python-use.o: tests/python-use.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
-		-DPYTHONPATH='"$(OUTPUT)python"' \
-		-DPYTHON='"$(PYTHON_WORD)"' \
-		$<
-
-$(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
-
-$(OUTPUT)ui/browser.o: ui/browser.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
-$(OUTPUT)ui/browsers/annotate.o: ui/browsers/annotate.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
-$(OUTPUT)ui/browsers/hists.o: ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
-$(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
-$(OUTPUT)ui/browsers/scripts.o: ui/browsers/scripts.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
-$(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
-
-$(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-redundant-decls $<
-
-$(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow -Wno-undef -Wno-switch-default $<
-
-$(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs -Wno-undef -Wno-switch-default $<
-
-$(OUTPUT)util/scripting-engines/trace-event-python.o: util/scripting-engines/trace-event-python.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
-
-$(OUTPUT)scripts/python/Perf-Trace-Util/Context.o: scripts/python/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
-
-$(OUTPUT)perf-%: %.o $(PERFLIBS)
-	$(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $(filter %.o,$^) $(LIBS)
-
-$(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
-$(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
-
-# we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
-# we depend the various files onto their directories.
-DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
-$(DIRECTORY_DEPS): | $(sort $(dir $(DIRECTORY_DEPS)))
-# In the second step, we make a rule to actually create these directories
-$(sort $(dir $(DIRECTORY_DEPS))):
-	$(QUIET_MKDIR)$(MKDIR) -p $@ 2>/dev/null
-
-$(LIB_FILE): $(LIB_OBJS)
-	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
-
-# libtraceevent.a
-$(LIBTRACEEVENT):
-	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) libtraceevent.a
-
-$(LIBTRACEEVENT)-clean:
-	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
-
-# if subdir is set, we've been called from above so target has been built
-# already
-$(LIBLK):
-ifeq ($(subdir),)
-	$(QUIET_SUBDIR0)$(LK_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) liblk.a
-endif
-
-$(LIBLK)-clean:
-ifeq ($(subdir),)
-	$(QUIET_SUBDIR0)$(LK_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
-endif
-
-help:
-	@echo 'Perf make targets:'
-	@echo '  doc		- make *all* documentation (see below)'
-	@echo '  man		- make manpage documentation (access with man <foo>)'
-	@echo '  html		- make html documentation'
-	@echo '  info		- make GNU info documentation (access with info <foo>)'
-	@echo '  pdf		- make pdf documentation'
-	@echo '  TAGS		- use etags to make tag information for source browsing'
-	@echo '  tags		- use ctags to make tag information for source browsing'
-	@echo '  cscope	- use cscope to make interactive browsing database'
-	@echo ''
-	@echo 'Perf install targets:'
-	@echo '  NOTE: documentation build requires asciidoc, xmlto packages to be installed'
-	@echo '  HINT: use "make prefix=<path> <install target>" to install to a particular'
-	@echo '        path like make prefix=/usr/local install install-doc'
-	@echo '  install	- install compiled binaries'
-	@echo '  install-doc	- install *all* documentation'
-	@echo '  install-man	- install manpage documentation'
-	@echo '  install-html	- install html documentation'
-	@echo '  install-info	- install GNU info documentation'
-	@echo '  install-pdf	- install pdf documentation'
-	@echo ''
-	@echo '  quick-install-doc	- alias for quick-install-man'
-	@echo '  quick-install-man	- install the documentation quickly'
-	@echo '  quick-install-html	- install the html documentation quickly'
-	@echo ''
-	@echo 'Perf maintainer targets:'
-	@echo '  clean			- clean all binary objects and build output'
-
-
-DOC_TARGETS := doc man html info pdf
-
-INSTALL_DOC_TARGETS := $(patsubst %,install-%,$(DOC_TARGETS)) try-install-man
-INSTALL_DOC_TARGETS += quick-install-doc quick-install-man quick-install-html
-
-# 'make doc' should call 'make -C Documentation all'
-$(DOC_TARGETS):
-	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) $(@:doc=all)
-
-TAGS:
-	$(RM) TAGS
-	$(FIND) . -name '*.[hcS]' -print | xargs etags -a
-
-tags:
-	$(RM) tags
-	$(FIND) . -name '*.[hcS]' -print | xargs ctags -a
-
-cscope:
-	$(RM) cscope*
-	$(FIND) . -name '*.[hcS]' -print | xargs cscope -b
-
-### Detect prefix changes
-TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):\
-             $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ)
-
-$(OUTPUT)PERF-CFLAGS: .FORCE-PERF-CFLAGS
-	@FLAGS='$(TRACK_CFLAGS)'; \
-	    if test x"$$FLAGS" != x"`cat $(OUTPUT)PERF-CFLAGS 2>/dev/null`" ; then \
-		echo 1>&2 "    * new build flags or prefix"; \
-		echo "$$FLAGS" >$(OUTPUT)PERF-CFLAGS; \
-            fi
-
-### Testing rules
-
-# GNU make supports exporting all variables by "export" without parameters.
-# However, the environment gets quite big, and some programs have problems
-# with that.
-
-check: $(OUTPUT)common-cmds.h
-	if sparse; \
-	then \
-		for i in *.c */*.c; \
-		do \
-			sparse $(CFLAGS) $(SPARSE_FLAGS) $$i || exit; \
-		done; \
-	else \
-		exit 1; \
-	fi
-
-### Installation rules
-
-install-bin: all
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
-	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
-	$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
-ifndef NO_LIBPERL
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
-	$(INSTALL) scripts/perl/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
-	$(INSTALL) scripts/perl/*.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'
-	$(INSTALL) scripts/perl/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
-endif
-ifndef NO_LIBPYTHON
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
-	$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
-	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
-	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
-endif
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d'
-	$(INSTALL) bash_completion '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d/perf'
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
-	$(INSTALL) tests/attr.py '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
-	$(INSTALL) tests/attr/* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
-
-install: install-bin try-install-man
-
-install-python_ext:
-	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
-
-# 'make install-doc' should call 'make -C Documentation install'
-$(INSTALL_DOC_TARGETS):
-	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) $(@:-doc=)
-
-### Cleaning rules
-
-clean: $(LIBTRACEEVENT)-clean $(LIBLK)-clean
-	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
-	$(RM) $(ALL_PROGRAMS) perf
-	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
-	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
-	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
-	$(RM) $(OUTPUT)util/*-bison*
-	$(RM) $(OUTPUT)util/*-flex*
-	$(python-clean)
-
-.PHONY: all install clean strip $(LIBTRACEEVENT) $(LIBLK)
-.PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
-.PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope .FORCE-PERF-CFLAGS
+#
+# All other targets get passed through:
+#
+%:
+	$(print_msg)
+	$(make)
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
new file mode 100644
index 0000000..a24f6c2
--- /dev/null
+++ b/tools/perf/Makefile.perf
@@ -0,0 +1,856 @@
+include ../scripts/Makefile.include
+
+# The default target of this Makefile is...
+all:
+
+include config/utilities.mak
+
+# Define V to have a more verbose compile.
+#
+# Define O to save output files in a separate directory.
+#
+# Define ARCH as name of target architecture if you want cross-builds.
+#
+# Define CROSS_COMPILE as prefix name of compiler if you want cross-builds.
+#
+# Define NO_LIBPERL to disable perl script extension.
+#
+# Define NO_LIBPYTHON to disable python script extension.
+#
+# Define PYTHON to point to the python binary if the default
+# `python' is not correct; for example: PYTHON=python2
+#
+# Define PYTHON_CONFIG to point to the python-config binary if
+# the default `$(PYTHON)-config' is not correct.
+#
+# Define ASCIIDOC8 if you want to format documentation with AsciiDoc 8
+#
+# Define DOCBOOK_XSL_172 if you want to format man pages with DocBook XSL v1.72.
+#
+# Define LDFLAGS=-static to build a static binary.
+#
+# Define EXTRA_CFLAGS=-m64 or EXTRA_CFLAGS=-m32 as appropriate for cross-builds.
+#
+# Define NO_DWARF if you do not want debug-info analysis feature at all.
+#
+# Define WERROR=0 to disable treating any warnings as errors.
+#
+# Define NO_NEWT if you do not want TUI support. (deprecated)
+#
+# Define NO_SLANG if you do not want TUI support.
+#
+# Define NO_GTK2 if you do not want GTK+ GUI support.
+#
+# Define NO_DEMANGLE if you do not want C++ symbol demangling.
+#
+# Define NO_LIBELF if you do not want libelf dependency (e.g. cross-builds)
+#
+# Define NO_LIBUNWIND if you do not want libunwind dependency for dwarf
+# backtrace post unwind.
+#
+# Define NO_BACKTRACE if you do not want stack backtrace debug feature
+#
+# Define NO_LIBNUMA if you do not want numa perf benchmark
+#
+# Define NO_LIBAUDIT if you do not want libaudit support
+#
+# Define NO_LIBBIONIC if you do not want bionic support
+
+ifeq ($(srctree),)
+srctree := $(patsubst %/,%,$(dir $(shell pwd)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+#$(info Determined 'srctree' to be $(srctree))
+endif
+
+ifneq ($(objtree),)
+#$(info Determined 'objtree' to be $(objtree))
+endif
+
+ifneq ($(OUTPUT),)
+#$(info Determined 'OUTPUT' to be $(OUTPUT))
+endif
+
+$(OUTPUT)PERF-VERSION-FILE: ../../.git/HEAD
+	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
+	@touch $(OUTPUT)PERF-VERSION-FILE
+
+CC = $(CROSS_COMPILE)gcc
+AR = $(CROSS_COMPILE)ar
+
+RM      = rm -f
+MKDIR   = mkdir
+FIND    = find
+INSTALL = install
+FLEX    = flex
+BISON   = bison
+STRIP   = strip
+
+LK_DIR          = $(srctree)/tools/lib/lk/
+TRACE_EVENT_DIR = $(srctree)/tools/lib/traceevent/
+
+# include config/Makefile by default and rule out
+# non-config cases
+config := 1
+
+NON_CONFIG_TARGETS := clean TAGS tags cscope help
+
+ifdef MAKECMDGOALS
+ifeq ($(filter-out $(NON_CONFIG_TARGETS),$(MAKECMDGOALS)),)
+  config := 0
+endif
+endif
+
+ifeq ($(config),1)
+include config/Makefile
+endif
+
+export prefix bindir sharedir sysconfdir
+
+# sparse is architecture-neutral, which means that we need to tell it
+# explicitly what architecture to check for. Fix this up for yours..
+SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
+
+# Guard against environment variables
+BUILTIN_OBJS =
+LIB_H =
+LIB_OBJS =
+PYRF_OBJS =
+SCRIPT_SH =
+
+SCRIPT_SH += perf-archive.sh
+
+grep-libs = $(filter -l%,$(1))
+strip-libs = $(filter-out -l%,$(1))
+
+ifneq ($(OUTPUT),)
+  TE_PATH=$(OUTPUT)
+ifneq ($(subdir),)
+  LK_PATH=$(OUTPUT)/../lib/lk/
+else
+  LK_PATH=$(OUTPUT)
+endif
+else
+  TE_PATH=$(TRACE_EVENT_DIR)
+  LK_PATH=$(LK_DIR)
+endif
+
+LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
+export LIBTRACEEVENT
+
+LIBLK = $(LK_PATH)liblk.a
+export LIBLK
+
+# python extension build directories
+PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
+PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
+PYTHON_EXTBUILD_TMP := $(PYTHON_EXTBUILD)tmp/
+export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
+
+python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
+
+PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
+PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT) $(LIBLK)
+
+$(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
+	$(QUIET_GEN)CFLAGS='$(CFLAGS)' $(PYTHON_WORD) util/setup.py \
+	  --quiet build_ext; \
+	mkdir -p $(OUTPUT)python && \
+	cp $(PYTHON_EXTBUILD_LIB)perf.so $(OUTPUT)python/
+#
+# No Perl scripts right now:
+#
+
+SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
+
+#
+# Single 'perf' binary right now:
+#
+PROGRAMS += $(OUTPUT)perf
+
+# what 'all' will build and 'install' will install, in perfexecdir
+ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS)
+
+# what 'all' will build but not install in perfexecdir
+OTHER_PROGRAMS = $(OUTPUT)perf
+
+# Set paths to tools early so that they can be used for version tests.
+ifndef SHELL_PATH
+  SHELL_PATH = /bin/sh
+endif
+ifndef PERL_PATH
+  PERL_PATH = /usr/bin/perl
+endif
+
+export PERL_PATH
+
+$(OUTPUT)util/parse-events-flex.c: util/parse-events.l $(OUTPUT)util/parse-events-bison.c
+	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
+
+$(OUTPUT)util/parse-events-bison.c: util/parse-events.y
+	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c -p parse_events_
+
+$(OUTPUT)util/pmu-flex.c: util/pmu.l $(OUTPUT)util/pmu-bison.c
+	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
+
+$(OUTPUT)util/pmu-bison.c: util/pmu.y
+	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c -p perf_pmu_
+
+$(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
+$(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
+
+LIB_FILE=$(OUTPUT)libperf.a
+
+LIB_H += ../../include/uapi/linux/perf_event.h
+LIB_H += ../../include/linux/rbtree.h
+LIB_H += ../../include/linux/list.h
+LIB_H += ../../include/uapi/linux/const.h
+LIB_H += ../../include/linux/hash.h
+LIB_H += ../../include/linux/stringify.h
+LIB_H += util/include/linux/bitmap.h
+LIB_H += util/include/linux/bitops.h
+LIB_H += util/include/linux/compiler.h
+LIB_H += util/include/linux/const.h
+LIB_H += util/include/linux/ctype.h
+LIB_H += util/include/linux/kernel.h
+LIB_H += util/include/linux/list.h
+LIB_H += util/include/linux/export.h
+LIB_H += util/include/linux/magic.h
+LIB_H += util/include/linux/poison.h
+LIB_H += util/include/linux/prefetch.h
+LIB_H += util/include/linux/rbtree.h
+LIB_H += util/include/linux/rbtree_augmented.h
+LIB_H += util/include/linux/string.h
+LIB_H += util/include/linux/types.h
+LIB_H += util/include/linux/linkage.h
+LIB_H += util/include/asm/asm-offsets.h
+LIB_H += util/include/asm/bug.h
+LIB_H += util/include/asm/byteorder.h
+LIB_H += util/include/asm/hweight.h
+LIB_H += util/include/asm/swab.h
+LIB_H += util/include/asm/system.h
+LIB_H += util/include/asm/uaccess.h
+LIB_H += util/include/dwarf-regs.h
+LIB_H += util/include/asm/dwarf2.h
+LIB_H += util/include/asm/cpufeature.h
+LIB_H += util/include/asm/unistd_32.h
+LIB_H += util/include/asm/unistd_64.h
+LIB_H += perf.h
+LIB_H += util/annotate.h
+LIB_H += util/cache.h
+LIB_H += util/callchain.h
+LIB_H += util/build-id.h
+LIB_H += util/debug.h
+LIB_H += util/sysfs.h
+LIB_H += util/pmu.h
+LIB_H += util/event.h
+LIB_H += util/evsel.h
+LIB_H += util/evlist.h
+LIB_H += util/exec_cmd.h
+LIB_H += util/types.h
+LIB_H += util/levenshtein.h
+LIB_H += util/machine.h
+LIB_H += util/map.h
+LIB_H += util/parse-options.h
+LIB_H += util/parse-events.h
+LIB_H += util/quote.h
+LIB_H += util/util.h
+LIB_H += util/xyarray.h
+LIB_H += util/header.h
+LIB_H += util/help.h
+LIB_H += util/session.h
+LIB_H += util/strbuf.h
+LIB_H += util/strlist.h
+LIB_H += util/strfilter.h
+LIB_H += util/svghelper.h
+LIB_H += util/tool.h
+LIB_H += util/run-command.h
+LIB_H += util/sigchain.h
+LIB_H += util/dso.h
+LIB_H += util/symbol.h
+LIB_H += util/color.h
+LIB_H += util/values.h
+LIB_H += util/sort.h
+LIB_H += util/hist.h
+LIB_H += util/thread.h
+LIB_H += util/thread_map.h
+LIB_H += util/trace-event.h
+LIB_H += util/probe-finder.h
+LIB_H += util/dwarf-aux.h
+LIB_H += util/probe-event.h
+LIB_H += util/pstack.h
+LIB_H += util/cpumap.h
+LIB_H += util/top.h
+LIB_H += $(ARCH_INCLUDE)
+LIB_H += util/cgroup.h
+LIB_H += $(LIB_INCLUDE)traceevent/event-parse.h
+LIB_H += util/target.h
+LIB_H += util/rblist.h
+LIB_H += util/intlist.h
+LIB_H += util/perf_regs.h
+LIB_H += util/unwind.h
+LIB_H += util/vdso.h
+LIB_H += ui/helpline.h
+LIB_H += ui/progress.h
+LIB_H += ui/util.h
+LIB_H += ui/ui.h
+
+LIB_OBJS += $(OUTPUT)util/abspath.o
+LIB_OBJS += $(OUTPUT)util/alias.o
+LIB_OBJS += $(OUTPUT)util/annotate.o
+LIB_OBJS += $(OUTPUT)util/build-id.o
+LIB_OBJS += $(OUTPUT)util/config.o
+LIB_OBJS += $(OUTPUT)util/ctype.o
+LIB_OBJS += $(OUTPUT)util/sysfs.o
+LIB_OBJS += $(OUTPUT)util/pmu.o
+LIB_OBJS += $(OUTPUT)util/environment.o
+LIB_OBJS += $(OUTPUT)util/event.o
+LIB_OBJS += $(OUTPUT)util/evlist.o
+LIB_OBJS += $(OUTPUT)util/evsel.o
+LIB_OBJS += $(OUTPUT)util/exec_cmd.o
+LIB_OBJS += $(OUTPUT)util/help.o
+LIB_OBJS += $(OUTPUT)util/levenshtein.o
+LIB_OBJS += $(OUTPUT)util/parse-options.o
+LIB_OBJS += $(OUTPUT)util/parse-events.o
+LIB_OBJS += $(OUTPUT)util/path.o
+LIB_OBJS += $(OUTPUT)util/rbtree.o
+LIB_OBJS += $(OUTPUT)util/bitmap.o
+LIB_OBJS += $(OUTPUT)util/hweight.o
+LIB_OBJS += $(OUTPUT)util/run-command.o
+LIB_OBJS += $(OUTPUT)util/quote.o
+LIB_OBJS += $(OUTPUT)util/strbuf.o
+LIB_OBJS += $(OUTPUT)util/string.o
+LIB_OBJS += $(OUTPUT)util/strlist.o
+LIB_OBJS += $(OUTPUT)util/strfilter.o
+LIB_OBJS += $(OUTPUT)util/top.o
+LIB_OBJS += $(OUTPUT)util/usage.o
+LIB_OBJS += $(OUTPUT)util/wrapper.o
+LIB_OBJS += $(OUTPUT)util/sigchain.o
+LIB_OBJS += $(OUTPUT)util/dso.o
+LIB_OBJS += $(OUTPUT)util/symbol.o
+LIB_OBJS += $(OUTPUT)util/symbol-elf.o
+LIB_OBJS += $(OUTPUT)util/color.o
+LIB_OBJS += $(OUTPUT)util/pager.o
+LIB_OBJS += $(OUTPUT)util/header.o
+LIB_OBJS += $(OUTPUT)util/callchain.o
+LIB_OBJS += $(OUTPUT)util/values.o
+LIB_OBJS += $(OUTPUT)util/debug.o
+LIB_OBJS += $(OUTPUT)util/machine.o
+LIB_OBJS += $(OUTPUT)util/map.o
+LIB_OBJS += $(OUTPUT)util/pstack.o
+LIB_OBJS += $(OUTPUT)util/session.o
+LIB_OBJS += $(OUTPUT)util/thread.o
+LIB_OBJS += $(OUTPUT)util/thread_map.o
+LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
+LIB_OBJS += $(OUTPUT)util/parse-events-flex.o
+LIB_OBJS += $(OUTPUT)util/parse-events-bison.o
+LIB_OBJS += $(OUTPUT)util/pmu-flex.o
+LIB_OBJS += $(OUTPUT)util/pmu-bison.o
+LIB_OBJS += $(OUTPUT)util/trace-event-read.o
+LIB_OBJS += $(OUTPUT)util/trace-event-info.o
+LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
+LIB_OBJS += $(OUTPUT)util/svghelper.o
+LIB_OBJS += $(OUTPUT)util/sort.o
+LIB_OBJS += $(OUTPUT)util/hist.o
+LIB_OBJS += $(OUTPUT)util/probe-event.o
+LIB_OBJS += $(OUTPUT)util/util.o
+LIB_OBJS += $(OUTPUT)util/xyarray.o
+LIB_OBJS += $(OUTPUT)util/cpumap.o
+LIB_OBJS += $(OUTPUT)util/cgroup.o
+LIB_OBJS += $(OUTPUT)util/target.o
+LIB_OBJS += $(OUTPUT)util/rblist.o
+LIB_OBJS += $(OUTPUT)util/intlist.o
+LIB_OBJS += $(OUTPUT)util/vdso.o
+LIB_OBJS += $(OUTPUT)util/stat.o
+LIB_OBJS += $(OUTPUT)util/record.o
+
+LIB_OBJS += $(OUTPUT)ui/setup.o
+LIB_OBJS += $(OUTPUT)ui/helpline.o
+LIB_OBJS += $(OUTPUT)ui/progress.o
+LIB_OBJS += $(OUTPUT)ui/util.o
+LIB_OBJS += $(OUTPUT)ui/hist.o
+LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
+
+LIB_OBJS += $(OUTPUT)arch/common.o
+
+LIB_OBJS += $(OUTPUT)tests/parse-events.o
+LIB_OBJS += $(OUTPUT)tests/dso-data.o
+LIB_OBJS += $(OUTPUT)tests/attr.o
+LIB_OBJS += $(OUTPUT)tests/vmlinux-kallsyms.o
+LIB_OBJS += $(OUTPUT)tests/open-syscall.o
+LIB_OBJS += $(OUTPUT)tests/open-syscall-all-cpus.o
+LIB_OBJS += $(OUTPUT)tests/open-syscall-tp-fields.o
+LIB_OBJS += $(OUTPUT)tests/mmap-basic.o
+LIB_OBJS += $(OUTPUT)tests/perf-record.o
+LIB_OBJS += $(OUTPUT)tests/rdpmc.o
+LIB_OBJS += $(OUTPUT)tests/evsel-roundtrip-name.o
+LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
+LIB_OBJS += $(OUTPUT)tests/pmu.o
+LIB_OBJS += $(OUTPUT)tests/hists_link.o
+LIB_OBJS += $(OUTPUT)tests/python-use.o
+LIB_OBJS += $(OUTPUT)tests/bp_signal.o
+LIB_OBJS += $(OUTPUT)tests/bp_signal_overflow.o
+LIB_OBJS += $(OUTPUT)tests/task-exit.o
+LIB_OBJS += $(OUTPUT)tests/sw-clock.o
+ifeq ($(ARCH),x86)
+LIB_OBJS += $(OUTPUT)tests/perf-time-to-tsc.o
+endif
+LIB_OBJS += $(OUTPUT)tests/code-reading.o
+LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
+LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
+
+BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
+BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
+# Benchmark modules
+BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
+BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
+ifeq ($(RAW_ARCH),x86_64)
+BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
+BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
+endif
+BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
+BUILTIN_OBJS += $(OUTPUT)bench/mem-memset.o
+
+BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
+BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
+BUILTIN_OBJS += $(OUTPUT)builtin-help.o
+BUILTIN_OBJS += $(OUTPUT)builtin-sched.o
+BUILTIN_OBJS += $(OUTPUT)builtin-buildid-list.o
+BUILTIN_OBJS += $(OUTPUT)builtin-buildid-cache.o
+BUILTIN_OBJS += $(OUTPUT)builtin-list.o
+BUILTIN_OBJS += $(OUTPUT)builtin-record.o
+BUILTIN_OBJS += $(OUTPUT)builtin-report.o
+BUILTIN_OBJS += $(OUTPUT)builtin-stat.o
+BUILTIN_OBJS += $(OUTPUT)builtin-timechart.o
+BUILTIN_OBJS += $(OUTPUT)builtin-top.o
+BUILTIN_OBJS += $(OUTPUT)builtin-script.o
+BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
+BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
+BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
+BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
+BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
+BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
+BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
+
+PERFLIBS = $(LIB_FILE) $(LIBLK) $(LIBTRACEEVENT)
+
+# We choose to avoid "if .. else if .. else .. endif endif"
+# because maintaining the nesting to match is a pain.  If
+# we had "elif" things would have been much nicer...
+
+-include arch/$(ARCH)/Makefile
+
+ifneq ($(OUTPUT),)
+  CFLAGS += -I$(OUTPUT)
+endif
+
+ifdef NO_LIBELF
+EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
+
+# Remove ELF/DWARF dependent codes
+LIB_OBJS := $(filter-out $(OUTPUT)util/symbol-elf.o,$(LIB_OBJS))
+LIB_OBJS := $(filter-out $(OUTPUT)util/dwarf-aux.o,$(LIB_OBJS))
+LIB_OBJS := $(filter-out $(OUTPUT)util/probe-event.o,$(LIB_OBJS))
+LIB_OBJS := $(filter-out $(OUTPUT)util/probe-finder.o,$(LIB_OBJS))
+
+BUILTIN_OBJS := $(filter-out $(OUTPUT)builtin-probe.o,$(BUILTIN_OBJS))
+
+# Use minimal symbol handling
+LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
+
+else # NO_LIBELF
+ifndef NO_DWARF
+  LIB_OBJS += $(OUTPUT)util/probe-finder.o
+  LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
+endif # NO_DWARF
+endif # NO_LIBELF
+
+ifndef NO_LIBUNWIND
+  LIB_OBJS += $(OUTPUT)util/unwind.o
+endif
+LIB_OBJS += $(OUTPUT)tests/keep-tracking.o
+
+ifndef NO_LIBAUDIT
+  BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
+endif
+
+ifndef NO_SLANG
+  LIB_OBJS += $(OUTPUT)ui/browser.o
+  LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
+  LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
+  LIB_OBJS += $(OUTPUT)ui/browsers/map.o
+  LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
+  LIB_OBJS += $(OUTPUT)ui/tui/setup.o
+  LIB_OBJS += $(OUTPUT)ui/tui/util.o
+  LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
+  LIB_OBJS += $(OUTPUT)ui/tui/progress.o
+  LIB_H += ui/browser.h
+  LIB_H += ui/browsers/map.h
+  LIB_H += ui/keysyms.h
+  LIB_H += ui/libslang.h
+endif
+
+ifndef NO_GTK2
+  LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
+  LIB_OBJS += $(OUTPUT)ui/gtk/hists.o
+  LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
+  LIB_OBJS += $(OUTPUT)ui/gtk/util.o
+  LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
+  LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
+  LIB_OBJS += $(OUTPUT)ui/gtk/annotate.o
+endif
+
+ifndef NO_LIBPERL
+  LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
+  LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
+endif
+
+ifndef NO_LIBPYTHON
+  LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
+  LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
+endif
+
+ifeq ($(NO_PERF_REGS),0)
+  ifeq ($(ARCH),x86)
+    LIB_H += arch/x86/include/perf_regs.h
+  endif
+endif
+
+ifndef NO_LIBNUMA
+  BUILTIN_OBJS += $(OUTPUT)bench/numa.o
+endif
+
+ifdef ASCIIDOC8
+  export ASCIIDOC8
+endif
+
+LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
+
+export INSTALL SHELL_PATH
+
+### Build rules
+
+SHELL = $(SHELL_PATH)
+
+all: shell_compatibility_test $(ALL_PROGRAMS) $(LANG_BINDINGS) $(OTHER_PROGRAMS)
+
+please_set_SHELL_PATH_to_a_more_modern_shell:
+	@$$(:)
+
+shell_compatibility_test: please_set_SHELL_PATH_to_a_more_modern_shell
+
+strip: $(PROGRAMS) $(OUTPUT)perf
+	$(STRIP) $(STRIP_OPTS) $(PROGRAMS) $(OUTPUT)perf
+
+$(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -include $(OUTPUT)PERF-VERSION-FILE \
+		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
+		$(CFLAGS) -c $(filter %.c,$^) -o $@
+
+$(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
+	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(OUTPUT)perf.o \
+               $(BUILTIN_OBJS) $(LIBS) -o $@
+
+$(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
+		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
+		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
+		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
+
+$(OUTPUT)builtin-timechart.o: builtin-timechart.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
+		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
+		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
+		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
+
+$(OUTPUT)common-cmds.h: util/generate-cmdlist.sh command-list.txt
+
+$(OUTPUT)common-cmds.h: $(wildcard Documentation/perf-*.txt)
+	$(QUIET_GEN). util/generate-cmdlist.sh > $@+ && mv $@+ $@
+
+$(SCRIPTS) : % : %.sh
+	$(QUIET_GEN)$(INSTALL) '$@.sh' '$(OUTPUT)$@'
+
+# These can record PERF_VERSION
+$(OUTPUT)perf.o perf.spec \
+	$(SCRIPTS) \
+	: $(OUTPUT)PERF-VERSION-FILE
+
+.SUFFIXES:
+
+#
+# If a target does not match any of the later rules then prefix it by $(OUTPUT)
+# This makes targets like 'make O=/tmp/perf perf.o' work in a natural way.
+#
+ifneq ($(OUTPUT),)
+%.o: $(OUTPUT)%.o
+	@echo "    # Redirected target $@ => $(OUTPUT)$@"
+util/%.o: $(OUTPUT)util/%.o
+	@echo "    # Redirected target $@ => $(OUTPUT)util/$@"
+bench/%.o: $(OUTPUT)bench/%.o
+	@echo "    # Redirected target $@ => $(OUTPUT)bench/$@"
+tests/%.o: $(OUTPUT)tests/%.o
+	@echo "    # Redirected target $@ => $(OUTPUT)tests/$@"
+endif
+
+# These two need to be here so that when O= is not used they take precedence
+# over the general rule for .o
+
+$(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(CFLAGS) -w $<
+
+$(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w $<
+
+$(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $<
+$(OUTPUT)%.i: %.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -E $(CFLAGS) $<
+$(OUTPUT)%.s: %.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -S $(CFLAGS) $<
+$(OUTPUT)%.o: %.S
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $<
+$(OUTPUT)%.s: %.S
+	$(QUIET_CC)$(CC) -o $@ -E $(CFLAGS) $<
+
+$(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
+		'-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
+		'-DPREFIX="$(prefix_SQ)"' \
+		$<
+
+$(OUTPUT)tests/attr.o: tests/attr.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
+		'-DBINDIR="$(bindir_SQ)"' -DPYTHON='"$(PYTHON_WORD)"' \
+		$<
+
+$(OUTPUT)tests/python-use.o: tests/python-use.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
+		-DPYTHONPATH='"$(OUTPUT)python"' \
+		-DPYTHON='"$(PYTHON_WORD)"' \
+		$<
+
+$(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+
+$(OUTPUT)ui/browser.o: ui/browser.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
+$(OUTPUT)ui/browsers/annotate.o: ui/browsers/annotate.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
+$(OUTPUT)ui/browsers/hists.o: ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
+$(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
+$(OUTPUT)ui/browsers/scripts.o: ui/browsers/scripts.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
+$(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+
+$(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-redundant-decls $<
+
+$(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow -Wno-undef -Wno-switch-default $<
+
+$(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs -Wno-undef -Wno-switch-default $<
+
+$(OUTPUT)util/scripting-engines/trace-event-python.o: util/scripting-engines/trace-event-python.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
+
+$(OUTPUT)scripts/python/Perf-Trace-Util/Context.o: scripts/python/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
+
+$(OUTPUT)perf-%: %.o $(PERFLIBS)
+	$(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $(filter %.o,$^) $(LIBS)
+
+$(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
+$(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
+
+# we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
+# we depend the various files onto their directories.
+DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
+$(DIRECTORY_DEPS): | $(sort $(dir $(DIRECTORY_DEPS)))
+# In the second step, we make a rule to actually create these directories
+$(sort $(dir $(DIRECTORY_DEPS))):
+	$(QUIET_MKDIR)$(MKDIR) -p $@ 2>/dev/null
+
+$(LIB_FILE): $(LIB_OBJS)
+	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
+
+# libtraceevent.a
+TE_SOURCES = $(wildcard $(TRACE_EVENT_DIR)*.[ch])
+
+$(LIBTRACEEVENT): $(TE_SOURCES)
+	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) libtraceevent.a
+
+$(LIBTRACEEVENT)-clean:
+	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
+
+LIBLK_SOURCES = $(wildcard $(LK_PATH)*.[ch])
+
+# if subdir is set, we've been called from above so target has been built
+# already
+$(LIBLK): $(LIBLK_SOURCES)
+ifeq ($(subdir),)
+	$(QUIET_SUBDIR0)$(LK_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) liblk.a
+endif
+
+$(LIBLK)-clean:
+ifeq ($(subdir),)
+	$(QUIET_SUBDIR0)$(LK_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
+endif
+
+help:
+	@echo 'Perf make targets:'
+	@echo '  doc		- make *all* documentation (see below)'
+	@echo '  man		- make manpage documentation (access with man <foo>)'
+	@echo '  html		- make html documentation'
+	@echo '  info		- make GNU info documentation (access with info <foo>)'
+	@echo '  pdf		- make pdf documentation'
+	@echo '  TAGS		- use etags to make tag information for source browsing'
+	@echo '  tags		- use ctags to make tag information for source browsing'
+	@echo '  cscope	- use cscope to make interactive browsing database'
+	@echo ''
+	@echo 'Perf install targets:'
+	@echo '  NOTE: documentation build requires asciidoc, xmlto packages to be installed'
+	@echo '  HINT: use "make prefix=<path> <install target>" to install to a particular'
+	@echo '        path like make prefix=/usr/local install install-doc'
+	@echo '  install	- install compiled binaries'
+	@echo '  install-doc	- install *all* documentation'
+	@echo '  install-man	- install manpage documentation'
+	@echo '  install-html	- install html documentation'
+	@echo '  install-info	- install GNU info documentation'
+	@echo '  install-pdf	- install pdf documentation'
+	@echo ''
+	@echo '  quick-install-doc	- alias for quick-install-man'
+	@echo '  quick-install-man	- install the documentation quickly'
+	@echo '  quick-install-html	- install the html documentation quickly'
+	@echo ''
+	@echo 'Perf maintainer targets:'
+	@echo '  clean			- clean all binary objects and build output'
+
+
+DOC_TARGETS := doc man html info pdf
+
+INSTALL_DOC_TARGETS := $(patsubst %,install-%,$(DOC_TARGETS)) try-install-man
+INSTALL_DOC_TARGETS += quick-install-doc quick-install-man quick-install-html
+
+# 'make doc' should call 'make -C Documentation all'
+$(DOC_TARGETS):
+	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) $(@:doc=all)
+
+TAGS:
+	$(RM) TAGS
+	$(FIND) . -name '*.[hcS]' -print | xargs etags -a
+
+tags:
+	$(RM) tags
+	$(FIND) . -name '*.[hcS]' -print | xargs ctags -a
+
+cscope:
+	$(RM) cscope*
+	$(FIND) . -name '*.[hcS]' -print | xargs cscope -b
+
+### Detect prefix changes
+TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):\
+             $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ)
+
+$(OUTPUT)PERF-CFLAGS: .FORCE-PERF-CFLAGS
+	@FLAGS='$(TRACK_CFLAGS)'; \
+	    if test x"$$FLAGS" != x"`cat $(OUTPUT)PERF-CFLAGS 2>/dev/null`" ; then \
+		echo 1>&2 "    * new build flags or prefix"; \
+		echo "$$FLAGS" >$(OUTPUT)PERF-CFLAGS; \
+            fi
+
+### Testing rules
+
+# GNU make supports exporting all variables by "export" without parameters.
+# However, the environment gets quite big, and some programs have problems
+# with that.
+
+check: $(OUTPUT)common-cmds.h
+	if sparse; \
+	then \
+		for i in *.c */*.c; \
+		do \
+			sparse $(CFLAGS) $(SPARSE_FLAGS) $$i || exit; \
+		done; \
+	else \
+		exit 1; \
+	fi
+
+### Installation rules
+
+install-bin: all
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
+	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
+	$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
+ifndef NO_LIBPERL
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
+	$(INSTALL) scripts/perl/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
+	$(INSTALL) scripts/perl/*.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'
+	$(INSTALL) scripts/perl/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
+endif
+ifndef NO_LIBPYTHON
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
+	$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
+	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
+	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
+endif
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d'
+	$(INSTALL) bash_completion '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d/perf'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
+	$(INSTALL) tests/attr.py '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
+	$(INSTALL) tests/attr/* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
+
+install: install-bin try-install-man
+
+install-python_ext:
+	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
+
+# 'make install-doc' should call 'make -C Documentation install'
+$(INSTALL_DOC_TARGETS):
+	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) $(@:-doc=)
+
+### Cleaning rules
+
+#
+# This is here, not in config/Makefile, because config/Makefile does
+# not get included for the clean target:
+#
+config-clean:
+	@$(MAKE) -C config/feature-checks clean
+
+clean: $(LIBTRACEEVENT)-clean $(LIBLK)-clean config-clean
+	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
+	$(RM) $(ALL_PROGRAMS) perf
+	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
+	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
+	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
+	$(RM) $(OUTPUT)util/*-bison*
+	$(RM) $(OUTPUT)util/*-flex*
+	$(python-clean)
+
+#
+# Trick: if ../../.git does not exist - we are building out of tree for example,
+# then force version regeneration:
+#
+ifeq ($(wildcard ../../.git/HEAD),)
+    GIT-HEAD-PHONY = ../../.git/HEAD
+else
+    GIT-HEAD-PHONY =
+endif
+
+.PHONY: all install clean config-clean strip
+.PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
+.PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS
+
diff --git a/tools/perf/arch/x86/include/perf_regs.h b/tools/perf/arch/x86/include/perf_regs.h
index 7fcdcdb..e84ca76 100644
--- a/tools/perf/arch/x86/include/perf_regs.h
+++ b/tools/perf/arch/x86/include/perf_regs.h
@@ -5,7 +5,7 @@
 #include "../../util/types.h"
 #include <asm/perf_regs.h>
 
-#ifndef ARCH_X86_64
+#ifndef HAVE_ARCH_X86_64_SUPPORT
 #define PERF_REGS_MASK ((1ULL << PERF_REG_X86_32_MAX) - 1)
 #else
 #define REG_NOSUPPORT ((1ULL << PERF_REG_X86_DS) | \
@@ -52,7 +52,7 @@ static inline const char *perf_reg_name(int id)
 		return "FS";
 	case PERF_REG_X86_GS:
 		return "GS";
-#ifdef ARCH_X86_64
+#ifdef HAVE_ARCH_X86_64_SUPPORT
 	case PERF_REG_X86_R8:
 		return "R8";
 	case PERF_REG_X86_R9:
@@ -69,7 +69,7 @@ static inline const char *perf_reg_name(int id)
 		return "R14";
 	case PERF_REG_X86_R15:
 		return "R15";
-#endif /* ARCH_X86_64 */
+#endif /* HAVE_ARCH_X86_64_SUPPORT */
 	default:
 		return NULL;
 	}
diff --git a/tools/perf/arch/x86/util/unwind.c b/tools/perf/arch/x86/util/unwind.c
index 78d956e..456a88c 100644
--- a/tools/perf/arch/x86/util/unwind.c
+++ b/tools/perf/arch/x86/util/unwind.c
@@ -4,7 +4,7 @@
 #include "perf_regs.h"
 #include "../../util/unwind.h"
 
-#ifdef ARCH_X86_64
+#ifdef HAVE_ARCH_X86_64_SUPPORT
 int unwind__arch_reg_id(int regnum)
 {
 	int id;
@@ -108,4 +108,4 @@ int unwind__arch_reg_id(int regnum)
 
 	return id;
 }
-#endif /* ARCH_X86_64 */
+#endif /* HAVE_ARCH_X86_64_SUPPORT */
diff --git a/tools/perf/bench/mem-memcpy-arch.h b/tools/perf/bench/mem-memcpy-arch.h
index a72e36c..57b4ed8 100644
--- a/tools/perf/bench/mem-memcpy-arch.h
+++ b/tools/perf/bench/mem-memcpy-arch.h
@@ -1,5 +1,5 @@
 
-#ifdef ARCH_X86_64
+#ifdef HAVE_ARCH_X86_64_SUPPORT
 
 #define MEMCPY_FN(fn, name, desc)		\
 	extern void *fn(void *, const void *, size_t);
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 8cdca43..5ce71d3 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -58,7 +58,7 @@ struct routine routines[] = {
 	{ "default",
 	  "Default memcpy() provided by glibc",
 	  memcpy },
-#ifdef ARCH_X86_64
+#ifdef HAVE_ARCH_X86_64_SUPPORT
 
 #define MEMCPY_FN(fn, name, desc) { name, desc, fn },
 #include "mem-memcpy-x86-64-asm-def.h"
diff --git a/tools/perf/bench/mem-memset-arch.h b/tools/perf/bench/mem-memset-arch.h
index a040fa7..633800c 100644
--- a/tools/perf/bench/mem-memset-arch.h
+++ b/tools/perf/bench/mem-memset-arch.h
@@ -1,5 +1,5 @@
 
-#ifdef ARCH_X86_64
+#ifdef HAVE_ARCH_X86_64_SUPPORT
 
 #define MEMSET_FN(fn, name, desc)		\
 	extern void *fn(void *, int, size_t);
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
index 4a2f120..9af79d2 100644
--- a/tools/perf/bench/mem-memset.c
+++ b/tools/perf/bench/mem-memset.c
@@ -58,7 +58,7 @@ static const struct routine routines[] = {
 	{ "default",
 	  "Default memset() provided by glibc",
 	  memset },
-#ifdef ARCH_X86_64
+#ifdef HAVE_ARCH_X86_64_SUPPORT
 
 #define MEMSET_FN(fn, name, desc) { name, desc, fn },
 #include "mem-memset-x86-64-asm-def.h"
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 77298bf..33af80f 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -35,7 +35,7 @@ struct bench_suite {
 /* sentinel: easy for help */
 #define suite_all { "all", "Test all benchmark suites", NULL }
 
-#ifdef LIBNUMA_SUPPORT
+#ifdef HAVE_LIBNUMA_SUPPORT
 static struct bench_suite numa_suites[] = {
 	{ "mem",
 	  "Benchmark for NUMA workloads",
@@ -80,7 +80,7 @@ struct bench_subsys {
 };
 
 static struct bench_subsys subsystems[] = {
-#ifdef LIBNUMA_SUPPORT
+#ifdef HAVE_LIBNUMA_SUPPORT
 	{ "numa",
 	  "NUMA scheduling and MM behavior",
 	  numa_suites },
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index afe377b..f51a963 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -231,7 +231,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 				 * account this as unresolved.
 				 */
 			} else {
-#ifdef LIBELF_SUPPORT
+#ifdef HAVE_LIBELF_SUPPORT
 				pr_warning("no symbols found in %s, maybe "
 					   "install a debug package?\n",
 					   al.map->dso->long_name);
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index e8a66f9..89acc17 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -173,7 +173,7 @@ static int opt_set_target(const struct option *opt, const char *str,
 	if  (str && !params.target) {
 		if (!strcmp(opt->long_name, "exec"))
 			params.uprobes = true;
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 		else if (!strcmp(opt->long_name, "module"))
 			params.uprobes = false;
 #endif
@@ -187,7 +187,7 @@ static int opt_set_target(const struct option *opt, const char *str,
 	return ret;
 }
 
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 static int opt_show_lines(const struct option *opt __maybe_unused,
 			  const char *str, int unset __maybe_unused)
 {
@@ -257,7 +257,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
 		"perf probe [<options>] --del '[GROUP:]EVENT' ...",
 		"perf probe --list",
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 		"perf probe [<options>] --line 'LINEDESC'",
 		"perf probe [<options>] --vars 'PROBEPOINT'",
 #endif
@@ -271,7 +271,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
 		opt_del_probe_event),
 	OPT_CALLBACK('a', "add", NULL,
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 		"[EVENT=]FUNC[@SRC][+OFF|%return|:RL|;PT]|SRC:AL|SRC;PT"
 		" [[NAME=]ARG ...]",
 #else
@@ -283,7 +283,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		"\t\tFUNC:\tFunction name\n"
 		"\t\tOFF:\tOffset from function entry (in byte)\n"
 		"\t\t%return:\tPut the probe at function return\n"
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 		"\t\tSRC:\tSource code path\n"
 		"\t\tRL:\tRelative line number from function entry.\n"
 		"\t\tAL:\tAbsolute line number in file.\n"
@@ -296,7 +296,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		opt_add_probe_event),
 	OPT_BOOLEAN('f', "force", &params.force_add, "forcibly add events"
 		    " with existing name"),
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 	OPT_CALLBACK('L', "line", NULL,
 		     "FUNC[:RLN[+NUM|-RLN2]]|SRC:ALN[+NUM|-ALN2]",
 		     "Show source code lines.", opt_show_lines),
@@ -408,7 +408,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		return ret;
 	}
 
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 	if (params.show_lines && !params.uprobes) {
 		if (params.mod_events) {
 			pr_err("  Error: Don't use --line with"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a78db3f..cf36ba2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -29,7 +29,7 @@
 #include <sched.h>
 #include <sys/mman.h>
 
-#ifndef HAVE_ON_EXIT
+#ifndef HAVE_ON_EXIT_SUPPORT
 #ifndef ATEXIT_MAX
 #define ATEXIT_MAX 32
 #endif
@@ -687,7 +687,7 @@ error:
 	return ret;
 }
 
-#ifdef LIBUNWIND_SUPPORT
+#ifdef HAVE_LIBUNWIND_SUPPORT
 static int get_stack_size(char *str, unsigned long *_size)
 {
 	char *endptr;
@@ -713,7 +713,7 @@ static int get_stack_size(char *str, unsigned long *_size)
 	       max_size, str);
 	return -1;
 }
-#endif /* LIBUNWIND_SUPPORT */
+#endif /* HAVE_LIBUNWIND_SUPPORT */
 
 int record_parse_callchain_opt(const struct option *opt,
 			       const char *arg, int unset)
@@ -751,7 +751,7 @@ int record_parse_callchain_opt(const struct option *opt,
 				       "needed for -g fp\n");
 			break;
 
-#ifdef LIBUNWIND_SUPPORT
+#ifdef HAVE_LIBUNWIND_SUPPORT
 		/* Dwarf style */
 		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
 			const unsigned long default_stack_dump_size = 8192;
@@ -771,7 +771,7 @@ int record_parse_callchain_opt(const struct option *opt,
 			if (!ret)
 				pr_debug("callchain: stack dump size %d\n",
 					 opts->stack_dump_size);
-#endif /* LIBUNWIND_SUPPORT */
+#endif /* HAVE_LIBUNWIND_SUPPORT */
 		} else {
 			pr_err("callchain: Unknown -g option "
 			       "value: %s\n", arg);
@@ -818,7 +818,7 @@ static struct perf_record record = {
 
 #define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
 
-#ifdef LIBUNWIND_SUPPORT
+#ifdef HAVE_LIBUNWIND_SUPPORT
 const char record_callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
 #else
 const char record_callchain_help[] = CALLCHAIN_HELP "[fp]";
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5f6f9b3..f5d661f 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -23,7 +23,7 @@ ifeq ($(ARCH),x86_64)
   endif
   ifeq (${IS_X86_64}, 1)
     RAW_ARCH := x86_64
-    CFLAGS += -DARCH_X86_64
+    CFLAGS += -DHAVE_ARCH_X86_64_SUPPORT
     ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
   endif
   NO_PERF_REGS := 0
@@ -31,7 +31,7 @@ ifeq ($(ARCH),x86_64)
 endif
 
 ifeq ($(NO_PERF_REGS),0)
-  CFLAGS += -DHAVE_PERF_REGS
+  CFLAGS += -DHAVE_PERF_REGS_SUPPORT
 endif
 
 ifeq ($(src-perf),)
@@ -51,7 +51,6 @@ LIB_INCLUDE := $(srctree)/tools/lib/
 # include ARCH specific config
 -include $(src-perf)/arch/$(ARCH)/Makefile
 
-include $(src-perf)/config/feature-tests.mak
 include $(src-perf)/config/utilities.mak
 
 ifeq ($(call get-executable,$(FLEX)),)
@@ -89,20 +88,130 @@ CFLAGS += -std=gnu99
 
 EXTLIBS = -lelf -lpthread -lrt -lm -ldl
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
+ifneq ($(OUTPUT),)
+  OUTPUT_FEATURES = $(OUTPUT)config/feature-checks/
+  $(shell mkdir -p $(OUTPUT_FEATURES))
+endif
+
+feature_check = $(eval $(feature_check_code))
+define feature_check_code
+  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS=$(LDFLAGS) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+endef
+
+feature_set = $(eval $(feature_set_code))
+define feature_set_code
+  feature-$(1) := 1
+endef
+
+#
+# Build the feature check binaries in parallel, ignore errors, ignore return value and suppress output:
+#
+
+#
+# Note that this is not a complete list of all feature tests, just
+# those that are typically built on a fully configured system.
+#
+# [ Feature tests not mentioned here have to be built explicitly in
+#   the rule that uses them - an example for that is the 'bionic'
+#   feature check. ]
+#
+CORE_FEATURE_TESTS =			\
+	backtrace			\
+	dwarf				\
+	fortify-source			\
+	glibc				\
+	gtk2				\
+	gtk2-infobar			\
+	libaudit			\
+	libbfd				\
+	libelf				\
+	libelf-getphdrnum		\
+	libelf-mmap			\
+	libnuma				\
+	libperl				\
+	libpython			\
+	libpython-version		\
+	libslang			\
+	libunwind			\
+	on-exit				\
+	stackprotector			\
+	stackprotector-all		\
+	volatile-register-var
+
+#
+# So here we detect whether test-all was rebuilt, to be able
+# to skip the print-out of the long features list if the file
+# existed before and after it was built:
+#
+ifeq ($(wildcard $(OUTPUT)config/feature-checks/test-all),)
+  test-all-failed := 1
+else
+  test-all-failed := 0
+endif
+
+#
+# Special fast-path for the 'all features are available' case:
+#
+$(call feature_check,all,$(MSG))
+
+#
+# Just in case the build freshly failed, make sure we print the
+# feature matrix:
+#
+ifeq ($(feature-all), 0)
+  test-all-failed := 1
+endif
+
+ifeq ($(test-all-failed),1)
+  $(info )
+  $(info Auto-detecting system features:)
+endif
+
+ifeq ($(feature-all), 1)
+  #
+  # test-all.c passed - just set all the core feature flags to 1:
+  #
+  $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_set,$(feat)))
+else
+  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS=$(LDFLAGS) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
+  $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
+endif
+
+#
+# Print the result of the feature test:
+#
+feature_print = $(eval $(feature_print_code)) $(info $(MSG))
+
+define feature_print_code
+  ifeq ($(feature-$(1)), 1)
+    MSG = $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
+  else
+    MSG = $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
+  endif
+endef
+
+#
+# Only print out our features if we rebuilt the testcases or if a test failed:
+#
+ifeq ($(test-all-failed), 1)
+  $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_print,$(feat)))
+  $(info )
+endif
+
+ifeq ($(feature-stackprotector-all), 1)
   CFLAGS += -fstack-protector-all
 endif
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector,-Wstack-protector),y)
+ifeq ($(feature-stackprotector), 1)
   CFLAGS += -Wstack-protector
 endif
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var,-Wvolatile-register-var),y)
+ifeq ($(feature-volatile-register-var), 1)
   CFLAGS += -Wvolatile-register-var
 endif
 
 ifndef PERF_DEBUG
-  ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=2,-D_FORTIFY_SOURCE=2),y)
+  ifeq ($(feature-fortify-source), 1)
     CFLAGS += -D_FORTIFY_SOURCE=2
   endif
 endif
@@ -128,84 +237,82 @@ CFLAGS += -I$(LIB_INCLUDE)
 CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
 ifndef NO_BIONIC
-ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
-  BIONIC := 1
-  EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
-  EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
+  $(feature_check,bionic)
+  ifeq ($(feature-bionic), 1)
+    BIONIC := 1
+    EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
+    EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
+  endif
 endif
-endif # NO_BIONIC
 
 ifdef NO_LIBELF
   NO_DWARF := 1
   NO_DEMANGLE := 1
   NO_LIBUNWIND := 1
 else
-FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
-  FLAGS_GLIBC=$(CFLAGS) $(LDFLAGS)
-  ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
-    LIBC_SUPPORT := 1
-  endif
-  ifeq ($(BIONIC),1)
-    LIBC_SUPPORT := 1
-  endif
-  ifeq ($(LIBC_SUPPORT),1)
-    msg := $(warning No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev);
+  ifeq ($(feature-libelf), 0)
+    ifeq ($(feature-glibc), 1)
+      LIBC_SUPPORT := 1
+    endif
+    ifeq ($(BIONIC),1)
+      LIBC_SUPPORT := 1
+    endif
+    ifeq ($(LIBC_SUPPORT),1)
+      msg := $(warning No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev);
 
-    NO_LIBELF := 1
-    NO_DWARF := 1
-    NO_DEMANGLE := 1
+      NO_LIBELF := 1
+      NO_DWARF := 1
+      NO_DEMANGLE := 1
+    else
+      msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
+    endif
   else
-    msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
-  endif
-else
-  # for linking with debug library, run like:
-  # make DEBUG=1 LIBDW_DIR=/opt/libdw/
-  ifdef LIBDW_DIR
-    LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
-    LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
-  endif
+    # for linking with debug library, run like:
+    # make DEBUG=1 LIBDW_DIR=/opt/libdw/
+    ifdef LIBDW_DIR
+      LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
+      LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
+    endif
 
-  FLAGS_DWARF=$(CFLAGS) $(LIBDW_CFLAGS) -ldw -lz -lelf $(LIBDW_LDFLAGS) $(LDFLAGS) $(EXTLIBS)
-  ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
-    msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
-    NO_DWARF := 1
-  endif # Dwarf support
-endif # SOURCE_LIBELF
+    ifneq ($(feature-dwarf), 1)
+      msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
+      NO_DWARF := 1
+    endif # Dwarf support
+  endif # libelf support
 endif # NO_LIBELF
 
 ifndef NO_LIBELF
-CFLAGS += -DLIBELF_SUPPORT
-FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
-  CFLAGS += -DLIBELF_MMAP
-endif
-ifeq ($(call try-cc,$(SOURCE_ELF_GETPHDRNUM),$(FLAGS_LIBELF),-DHAVE_ELF_GETPHDRNUM),y)
-  CFLAGS += -DHAVE_ELF_GETPHDRNUM
-endif
+  CFLAGS += -DHAVE_LIBELF_SUPPORT
+  FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
 
-# include ARCH specific config
--include $(src-perf)/arch/$(ARCH)/Makefile
+  ifeq ($(feature-libelf-mmap), 1)
+    CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
+  endif
 
-ifndef NO_DWARF
-ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
-  msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
-  NO_DWARF := 1
-else
-  CFLAGS += -DDWARF_SUPPORT $(LIBDW_CFLAGS)
-  LDFLAGS += $(LIBDW_LDFLAGS)
-  EXTLIBS += -lelf -ldw
-endif # PERF_HAVE_DWARF_REGS
-endif # NO_DWARF
+  ifeq ($(feature-libelf-getphdrnum), 1)
+    CFLAGS += -DHAVE_ELF_GETPHDRNUM_SUPPORT
+  endif
 
+  # include ARCH specific config
+  -include $(src-perf)/arch/$(ARCH)/Makefile
+
+  ifndef NO_DWARF
+    ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
+      msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
+      NO_DWARF := 1
+    else
+      CFLAGS += -DHAVE_DWARF_SUPPORT $(LIBDW_CFLAGS)
+      LDFLAGS += $(LIBDW_LDFLAGS)
+      EXTLIBS += -lelf -ldw
+    endif # PERF_HAVE_DWARF_REGS
+  endif # NO_DWARF
 endif # NO_LIBELF
 
 ifndef NO_LIBELF
-CFLAGS += -DLIBELF_SUPPORT
-FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
-  CFLAGS += -DLIBELF_MMAP
-endif # try-cc
+  CFLAGS += -DHAVE_LIBELF_SUPPORT
+  ifeq ($(feature-libelf-mmap), 1)
+    CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
+  endif
 endif # NO_LIBELF
 
 # There's only x86 (both 32 and 64) support for CFI unwind so far
@@ -214,34 +321,35 @@ ifneq ($(ARCH),x86)
 endif
 
 ifndef NO_LIBUNWIND
-# for linking with debug library, run like:
-# make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
-ifdef LIBUNWIND_DIR
-  LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
-  LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
-endif
+  #
+  # For linking with debug library, run like:
+  #
+  #   make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
+  #
+  ifdef LIBUNWIND_DIR
+    LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
+    LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
+  endif
 
-FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(CFLAGS) $(LIBUNWIND_LDFLAGS) $(LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
-  msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
-  NO_LIBUNWIND := 1
-endif # Libunwind support
-endif # NO_LIBUNWIND
+  ifneq ($(feature-libunwind), 1)
+    msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
+    NO_LIBUNWIND := 1
+  endif
+endif
 
 ifndef NO_LIBUNWIND
-  CFLAGS += -DLIBUNWIND_SUPPORT
+  CFLAGS += -DHAVE_LIBUNWIND_SUPPORT
   EXTLIBS += $(LIBUNWIND_LIBS)
   CFLAGS += $(LIBUNWIND_CFLAGS)
   LDFLAGS += $(LIBUNWIND_LDFLAGS)
-endif # NO_LIBUNWIND
+endif
 
 ifndef NO_LIBAUDIT
-  FLAGS_LIBAUDIT = $(CFLAGS) $(LDFLAGS) -laudit
-  ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT),libaudit),y)
+  ifneq ($(feature-libaudit), 1)
     msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
     NO_LIBAUDIT := 1
   else
-    CFLAGS += -DLIBAUDIT_SUPPORT
+    CFLAGS += -DHAVE_LIBAUDIT_SUPPORT
     EXTLIBS += -laudit
   endif
 endif
@@ -251,28 +359,27 @@ ifdef NO_NEWT
 endif
 
 ifndef NO_SLANG
-  FLAGS_SLANG=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -I/usr/include/slang -lslang
-  ifneq ($(call try-cc,$(SOURCE_SLANG),$(FLAGS_SLANG),libslang),y)
+  ifneq ($(feature-libslang), 1)
     msg := $(warning slang not found, disables TUI support. Please install slang-devel or libslang-dev);
     NO_SLANG := 1
   else
     # Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
     CFLAGS += -I/usr/include/slang
-    CFLAGS += -DSLANG_SUPPORT
+    CFLAGS += -DHAVE_SLANG_SUPPORT
     EXTLIBS += -lslang
   endif
 endif
 
 ifndef NO_GTK2
   FLAGS_GTK2=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
-  ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2),gtk2),y)
+  ifneq ($(feature-gtk2), 1)
     msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
     NO_GTK2 := 1
   else
-    ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
-      CFLAGS += -DHAVE_GTK_INFO_BAR
+    ifeq ($(feature-gtk2-infobar), 1)
+      CFLAGS += -DHAVE_GTK_INFO_BAR_SUPPORT
     endif
-    CFLAGS += -DGTK2_SUPPORT
+    CFLAGS += -DHAVE_GTK2_SUPPORT
     CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
     EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
   endif
@@ -290,7 +397,7 @@ else
   PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
   FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
-  ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED),perl),y)
+  ifneq ($(feature-libperl), 1)
     CFLAGS += -DNO_LIBPERL
     NO_LIBPERL := 1
   else
@@ -335,11 +442,11 @@ else
       PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
       FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
 
-      ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED),python),y)
+      ifneq ($(feature-libpython), 1)
         $(call disable-python,Python.h (for Python 2.x))
       else
 
-        ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED),python version),y)
+        ifneq ($(feature-libpython-version), 1)
           $(warning Python 3 is not yet supported; please set)
           $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
           $(warning If you also have Python 2 installed, then)
@@ -365,30 +472,25 @@ endif
 ifdef NO_DEMANGLE
   CFLAGS += -DNO_DEMANGLE
 else
-  ifdef HAVE_CPLUS_DEMANGLE
+  ifdef HAVE_CPLUS_DEMANGLE_SUPPORT
     EXTLIBS += -liberty
-    CFLAGS += -DHAVE_CPLUS_DEMANGLE
+    CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
   else
-    FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
-    has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
-    ifeq ($(has_bfd),y)
+    ifeq ($(feature-libbfd), 1)
       EXTLIBS += -lbfd
     else
-      FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
-      has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY),liberty)
-      ifeq ($(has_bfd_iberty),y)
+      $(feature_check,liberty)
+      ifeq ($(feature-liberty), 1)
         EXTLIBS += -lbfd -liberty
       else
-        FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
-        has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z),libz)
-        ifeq ($(has_bfd_iberty_z),y)
+        $(feature_check,liberty-z)
+        ifeq ($(feature-liberty-z), 1)
           EXTLIBS += -lbfd -liberty -lz
         else
-          FLAGS_CPLUS_DEMANGLE=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -liberty
-          has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE),demangle)
-          ifeq ($(has_cplus_demangle),y)
+          $(feature_check,cplus-demangle)
+          ifeq ($(feature-cplus-demangle), 1)
             EXTLIBS += -liberty
-            CFLAGS += -DHAVE_CPLUS_DEMANGLE
+            CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
           else
             msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
             CFLAGS += -DNO_DEMANGLE
@@ -399,31 +501,24 @@ else
   endif
 endif
 
-ifndef NO_STRLCPY
-  ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY),y)
-    CFLAGS += -DHAVE_STRLCPY
-  endif
-endif
-
 ifndef NO_ON_EXIT
-  ifeq ($(call try-cc,$(SOURCE_ON_EXIT),,-DHAVE_ON_EXIT),y)
-    CFLAGS += -DHAVE_ON_EXIT
+  ifeq ($(feature-on-exit), 1)
+    CFLAGS += -DHAVE_ON_EXIT_SUPPORT
   endif
 endif
 
 ifndef NO_BACKTRACE
-  ifeq ($(call try-cc,$(SOURCE_BACKTRACE),,-DBACKTRACE_SUPPORT),y)
-    CFLAGS += -DBACKTRACE_SUPPORT
+  ifeq ($(feature-backtrace), 1)
+    CFLAGS += -DHAVE_BACKTRACE_SUPPORT
   endif
 endif
 
 ifndef NO_LIBNUMA
-  FLAGS_LIBNUMA = $(CFLAGS) $(LDFLAGS) -lnuma
-  ifneq ($(call try-cc,$(SOURCE_LIBNUMA),$(FLAGS_LIBNUMA),libnuma),y)
+  ifeq ($(feature-libnuma), 0)
     msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev);
     NO_LIBNUMA := 1
   else
-    CFLAGS += -DLIBNUMA_SUPPORT
+    CFLAGS += -DHAVE_LIBNUMA_SUPPORT
     EXTLIBS += -lnuma
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
new file mode 100644
index 0000000..8ecac19
--- /dev/null
+++ b/tools/perf/config/feature-checks/Makefile
@@ -0,0 +1,148 @@
+
+FILES=					\
+	test-all			\
+	test-backtrace			\
+	test-bionic			\
+	test-dwarf			\
+	test-fortify-source		\
+	test-glibc			\
+	test-gtk2			\
+	test-gtk2-infobar		\
+	test-hello			\
+	test-libaudit			\
+	test-libbfd			\
+	test-liberty			\
+	test-liberty-z			\
+	test-cplus-demangle		\
+	test-libelf			\
+	test-libelf-getphdrnum		\
+	test-libelf-mmap		\
+	test-libnuma			\
+	test-libperl			\
+	test-libpython			\
+	test-libpython-version		\
+	test-libslang			\
+	test-libunwind			\
+	test-on-exit			\
+	test-stackprotector-all		\
+	test-stackprotector		\
+	test-volatile-register-var
+
+CC := $(CC) -MD
+
+all: $(FILES)
+
+BUILD = $(CC) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
+
+###############################
+
+test-all:
+	$(BUILD) -Werror -fstack-protector -fstack-protector-all -Wvolatile-register-var -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lunwind -lunwind-x86_64 -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
+
+test-hello:
+	$(BUILD)
+
+test-stackprotector-all:
+	$(BUILD) -Werror -fstack-protector-all
+
+test-stackprotector:
+	$(BUILD) -Werror -fstack-protector
+
+test-volatile-register-var:
+	$(BUILD) -Werror -Wvolatile-register-var
+
+test-fortify-source:
+	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=2
+
+test-bionic:
+	$(BUILD)
+
+test-libelf:
+	$(BUILD) -lelf
+
+test-glibc:
+	$(BUILD)
+
+test-dwarf:
+	$(BUILD) -ldw
+
+test-libelf-mmap:
+	$(BUILD) -lelf
+
+test-libelf-getphdrnum:
+	$(BUILD) -lelf
+
+test-libnuma:
+	$(BUILD) -lnuma
+
+test-libunwind:
+	$(BUILD) -lunwind -lunwind-x86_64 -lelf
+
+test-libaudit:
+	$(BUILD) -laudit
+
+test-libslang:
+	$(BUILD) -I/usr/include/slang -lslang
+
+test-gtk2:
+	$(BUILD) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+
+test-gtk2-infobar:
+	$(BUILD) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+
+grep-libs  = $(filter -l%,$(1))
+strip-libs = $(filter-out -l%,$(1))
+
+PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
+PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
+PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
+PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
+FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
+
+test-libperl:
+	$(BUILD) $(FLAGS_PERL_EMBED)
+
+override PYTHON := python
+override PYTHON_CONFIG := python-config
+
+escape-for-shell-sq =  $(subst ','\'',$(1))
+shell-sq = '$(escape-for-shell-sq)'
+
+PYTHON_CONFIG_SQ = $(call shell-sq,$(PYTHON_CONFIG))
+
+PYTHON_EMBED_LDOPTS = $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
+PYTHON_EMBED_LDFLAGS = $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
+PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
+PYTHON_EMBED_CCOPTS = $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
+FLAGS_PYTHON_EMBED = $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
+
+test-libpython:
+	$(BUILD) $(FLAGS_PYTHON_EMBED)
+
+test-libpython-version:
+	$(BUILD) $(FLAGS_PYTHON_EMBED)
+
+test-libbfd:
+	$(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
+
+test-liberty:
+	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl -liberty
+
+test-liberty-z:
+	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl -liberty -lz
+
+test-cplus-demangle:
+	$(BUILD) -liberty
+
+test-on-exit:
+	$(BUILD)
+
+test-backtrace:
+	$(BUILD)
+
+-include *.d */*.d
+
+###############################
+
+clean:
+	rm -f $(FILES) *.d
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
new file mode 100644
index 0000000..50d4318
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -0,0 +1,106 @@
+/*
+ * test-all.c: Try to build all the main testcases at once.
+ *
+ * A well-configured system will have all the prereqs installed, so we can speed
+ * up auto-detection on such systems.
+ */
+
+/*
+ * Quirk: Python and Perl headers cannot be in arbitrary places, so keep
+ * these 3 testcases at the top:
+ */
+#define main main_test_libpython
+# include "test-libpython.c"
+#undef main
+
+#define main main_test_libpython_version
+# include "test-libpython-version.c"
+#undef main
+
+#define main main_test_libperl
+# include "test-libperl.c"
+#undef main
+
+#define main main_test_hello
+# include "test-hello.c"
+#undef main
+
+#define main main_test_libelf
+# include "test-libelf.c"
+#undef main
+
+#define main main_test_libelf_mmap
+# include "test-libelf-mmap.c"
+#undef main
+
+#define main main_test_glibc
+# include "test-glibc.c"
+#undef main
+
+#define main main_test_dwarf
+# include "test-dwarf.c"
+#undef main
+
+#define main main_test_libelf_getphdrnum
+# include "test-libelf-getphdrnum.c"
+#undef main
+
+#define main main_test_libunwind
+# include "test-libunwind.c"
+#undef main
+
+#define main main_test_libaudit
+# include "test-libaudit.c"
+#undef main
+
+#define main main_test_libslang
+# include "test-libslang.c"
+#undef main
+
+#define main main_test_gtk2
+# include "test-gtk2.c"
+#undef main
+
+#define main main_test_gtk2_infobar
+# include "test-gtk2-infobar.c"
+#undef main
+
+#define main main_test_libbfd
+# include "test-libbfd.c"
+#undef main
+
+#define main main_test_on_exit
+# include "test-on-exit.c"
+#undef main
+
+#define main main_test_backtrace
+# include "test-backtrace.c"
+#undef main
+
+#define main main_test_libnuma
+# include "test-libnuma.c"
+#undef main
+
+int main(int argc, char *argv[])
+{
+	main_test_libpython();
+	main_test_libpython_version();
+	main_test_libperl();
+	main_test_hello();
+	main_test_libelf();
+	main_test_libelf_mmap();
+	main_test_glibc();
+	main_test_dwarf();
+	main_test_libelf_getphdrnum();
+	main_test_libunwind();
+	main_test_libaudit();
+	main_test_libslang();
+	main_test_gtk2(argc, argv);
+	main_test_gtk2_infobar(argc, argv);
+	main_test_libbfd();
+	main_test_on_exit();
+	main_test_backtrace();
+	main_test_libnuma();
+
+	return 0;
+}
diff --git a/tools/perf/config/feature-checks/test-backtrace.c b/tools/perf/config/feature-checks/test-backtrace.c
new file mode 100644
index 0000000..7124aa1
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-backtrace.c
@@ -0,0 +1,13 @@
+#include <execinfo.h>
+#include <stdio.h>
+
+int main(void)
+{
+	void *backtrace_fns[10];
+	size_t entries;
+
+	entries = backtrace(backtrace_fns, 10);
+	backtrace_symbols_fd(backtrace_fns, entries, 1);
+
+	return 0;
+}
diff --git a/tools/perf/config/feature-checks/test-bionic.c b/tools/perf/config/feature-checks/test-bionic.c
new file mode 100644
index 0000000..eac24e9
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-bionic.c
@@ -0,0 +1,6 @@
+#include <android/api-level.h>
+
+int main(void)
+{
+	return __ANDROID_API__;
+}
diff --git a/tools/perf/config/feature-checks/test-cplus-demangle.c b/tools/perf/config/feature-checks/test-cplus-demangle.c
new file mode 100644
index 0000000..610c686
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-cplus-demangle.c
@@ -0,0 +1,14 @@
+extern int printf(const char *format, ...);
+extern char *cplus_demangle(const char *, int);
+
+int main(void)
+{
+	char symbol[4096] = "FieldName__9ClassNameFd";
+	char *tmp;
+
+	tmp = cplus_demangle(symbol, 0);
+
+	printf("demangled symbol: {%s}\n", tmp);
+
+	return 0;
+}
diff --git a/tools/perf/config/feature-checks/test-dwarf.c b/tools/perf/config/feature-checks/test-dwarf.c
new file mode 100644
index 0000000..3fc1801
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-dwarf.c
@@ -0,0 +1,10 @@
+#include <dwarf.h>
+#include <elfutils/libdw.h>
+#include <elfutils/version.h>
+
+int main(void)
+{
+	Dwarf *dbg = dwarf_begin(0, DWARF_C_READ);
+
+	return (long)dbg;
+}
diff --git a/tools/perf/config/feature-checks/test-fortify-source.c b/tools/perf/config/feature-checks/test-fortify-source.c
new file mode 100644
index 0000000..c9f398d
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-fortify-source.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
diff --git a/tools/perf/config/feature-checks/test-glibc.c b/tools/perf/config/feature-checks/test-glibc.c
new file mode 100644
index 0000000..b082034
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-glibc.c
@@ -0,0 +1,8 @@
+#include <gnu/libc-version.h>
+
+int main(void)
+{
+	const char *version = gnu_get_libc_version();
+
+	return (long)version;
+}
diff --git a/tools/perf/config/feature-checks/test-gtk2-infobar.c b/tools/perf/config/feature-checks/test-gtk2-infobar.c
new file mode 100644
index 0000000..397b464
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-gtk2-infobar.c
@@ -0,0 +1,11 @@
+#pragma GCC diagnostic ignored "-Wstrict-prototypes"
+#include <gtk/gtk.h>
+#pragma GCC diagnostic error "-Wstrict-prototypes"
+
+int main(int argc, char *argv[])
+{
+	gtk_init(&argc, &argv);
+	gtk_info_bar_new();
+
+	return 0;
+}
diff --git a/tools/perf/config/feature-checks/test-gtk2.c b/tools/perf/config/feature-checks/test-gtk2.c
new file mode 100644
index 0000000..6bd80e5
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-gtk2.c
@@ -0,0 +1,10 @@
+#pragma GCC diagnostic ignored "-Wstrict-prototypes"
+#include <gtk/gtk.h>
+#pragma GCC diagnostic error "-Wstrict-prototypes"
+
+int main(int argc, char *argv[])
+{
+	gtk_init(&argc, &argv);
+
+        return 0;
+}
diff --git a/tools/perf/config/feature-checks/test-hello.c b/tools/perf/config/feature-checks/test-hello.c
new file mode 100644
index 0000000..c9f398d
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-hello.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
diff --git a/tools/perf/config/feature-checks/test-libaudit.c b/tools/perf/config/feature-checks/test-libaudit.c
new file mode 100644
index 0000000..afc019f
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libaudit.c
@@ -0,0 +1,10 @@
+#include <libaudit.h>
+
+extern int printf(const char *format, ...);
+
+int main(void)
+{
+	printf("error message: %s\n", audit_errno_to_name(0));
+
+	return audit_open();
+}
diff --git a/tools/perf/config/feature-checks/test-libbfd.c b/tools/perf/config/feature-checks/test-libbfd.c
new file mode 100644
index 0000000..2405990
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libbfd.c
@@ -0,0 +1,15 @@
+#include <bfd.h>
+
+extern int printf(const char *format, ...);
+
+int main(void)
+{
+	char symbol[4096] = "FieldName__9ClassNameFd";
+	char *tmp;
+
+	tmp = bfd_demangle(0, symbol, 0);
+
+	printf("demangled symbol: {%s}\n", tmp);
+
+	return 0;
+}
diff --git a/tools/perf/config/feature-checks/test-libelf-getphdrnum.c b/tools/perf/config/feature-checks/test-libelf-getphdrnum.c
new file mode 100644
index 0000000..d710459
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libelf-getphdrnum.c
@@ -0,0 +1,8 @@
+#include <libelf.h>
+
+int main(void)
+{
+	size_t dst;
+
+	return elf_getphdrnum(0, &dst);
+}
diff --git a/tools/perf/config/feature-checks/test-libelf-mmap.c b/tools/perf/config/feature-checks/test-libelf-mmap.c
new file mode 100644
index 0000000..564427d
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libelf-mmap.c
@@ -0,0 +1,8 @@
+#include <libelf.h>
+
+int main(void)
+{
+	Elf *elf = elf_begin(0, ELF_C_READ_MMAP, 0);
+
+	return (long)elf;
+}
diff --git a/tools/perf/config/feature-checks/test-libelf.c b/tools/perf/config/feature-checks/test-libelf.c
new file mode 100644
index 0000000..08db322
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libelf.c
@@ -0,0 +1,8 @@
+#include <libelf.h>
+
+int main(void)
+{
+	Elf *elf = elf_begin(0, ELF_C_READ, 0);
+
+	return (long)elf;
+}
diff --git a/tools/perf/config/feature-checks/test-libnuma.c b/tools/perf/config/feature-checks/test-libnuma.c
new file mode 100644
index 0000000..4763d9c
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libnuma.c
@@ -0,0 +1,9 @@
+#include <numa.h>
+#include <numaif.h>
+
+int main(void)
+{
+	numa_available();
+
+	return 0;
+}
diff --git a/tools/perf/config/feature-checks/test-libperl.c b/tools/perf/config/feature-checks/test-libperl.c
new file mode 100644
index 0000000..8871f6a
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libperl.c
@@ -0,0 +1,9 @@
+#include <EXTERN.h>
+#include <perl.h>
+
+int main(void)
+{
+	perl_alloc();
+
+	return 0;
+}
diff --git a/tools/perf/config/feature-checks/test-libpython-version.c b/tools/perf/config/feature-checks/test-libpython-version.c
new file mode 100644
index 0000000..facea12
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libpython-version.c
@@ -0,0 +1,10 @@
+#include <Python.h>
+
+#if PY_VERSION_HEX >= 0x03000000
+	#error
+#endif
+
+int main(void)
+{
+	return 0;
+}
diff --git a/tools/perf/config/feature-checks/test-libpython.c b/tools/perf/config/feature-checks/test-libpython.c
new file mode 100644
index 0000000..b24b28a
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libpython.c
@@ -0,0 +1,8 @@
+#include <Python.h>
+
+int main(void)
+{
+	Py_Initialize();
+
+	return 0;
+}
diff --git a/tools/perf/config/feature-checks/test-libslang.c b/tools/perf/config/feature-checks/test-libslang.c
new file mode 100644
index 0000000..22ff22e
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libslang.c
@@ -0,0 +1,6 @@
+#include <slang.h>
+
+int main(void)
+{
+	return SLsmg_init_smg();
+}
diff --git a/tools/perf/config/feature-checks/test-libunwind.c b/tools/perf/config/feature-checks/test-libunwind.c
new file mode 100644
index 0000000..43b9369
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libunwind.c
@@ -0,0 +1,27 @@
+#include <libunwind.h>
+#include <stdlib.h>
+
+extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
+                                      unw_word_t ip,
+                                      unw_dyn_info_t *di,
+                                      unw_proc_info_t *pi,
+                                      int need_unwind_info, void *arg);
+
+
+#define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
+
+static unw_accessors_t accessors;
+
+int main(void)
+{
+	unw_addr_space_t addr_space;
+
+	addr_space = unw_create_addr_space(&accessors, 0);
+	if (addr_space)
+		return 0;
+
+	unw_init_remote(NULL, addr_space, NULL);
+	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
+
+	return 0;
+}
diff --git a/tools/perf/config/feature-checks/test-on-exit.c b/tools/perf/config/feature-checks/test-on-exit.c
new file mode 100644
index 0000000..8f64ed3
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-on-exit.c
@@ -0,0 +1,15 @@
+#include <stdio.h>
+
+static void exit_fn(int status, void *__data)
+{
+	printf("exit status: %d, data: %d\n", status, *(int *)__data);
+}
+
+static int data = 123;
+
+int main(void)
+{
+	on_exit(exit_fn, &data);
+
+	return 321;
+}
diff --git a/tools/perf/config/feature-checks/test-stackprotector-all.c b/tools/perf/config/feature-checks/test-stackprotector-all.c
new file mode 100644
index 0000000..c9f398d
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-stackprotector-all.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
diff --git a/tools/perf/config/feature-checks/test-stackprotector.c b/tools/perf/config/feature-checks/test-stackprotector.c
new file mode 100644
index 0000000..c9f398d
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-stackprotector.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
diff --git a/tools/perf/config/feature-checks/test-volatile-register-var.c b/tools/perf/config/feature-checks/test-volatile-register-var.c
new file mode 100644
index 0000000..c9f398d
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-volatile-register-var.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
deleted file mode 100644
index f793057..0000000
--- a/tools/perf/config/feature-tests.mak
+++ /dev/null
@@ -1,246 +0,0 @@
-define SOURCE_HELLO
-#include <stdio.h>
-int main(void)
-{
-	return puts(\"hi\");
-}
-endef
-
-ifndef NO_DWARF
-define SOURCE_DWARF
-#include <dwarf.h>
-#include <elfutils/libdw.h>
-#include <elfutils/version.h>
-#ifndef _ELFUTILS_PREREQ
-#error
-#endif
-
-int main(void)
-{
-	Dwarf *dbg = dwarf_begin(0, DWARF_C_READ);
-	return (long)dbg;
-}
-endef
-endif
-
-define SOURCE_LIBELF
-#include <libelf.h>
-
-int main(void)
-{
-	Elf *elf = elf_begin(0, ELF_C_READ, 0);
-	return (long)elf;
-}
-endef
-
-define SOURCE_GLIBC
-#include <gnu/libc-version.h>
-
-int main(void)
-{
-	const char *version = gnu_get_libc_version();
-	return (long)version;
-}
-endef
-
-define SOURCE_BIONIC
-#include <android/api-level.h>
-
-int main(void)
-{
-	return __ANDROID_API__;
-}
-endef
-
-define SOURCE_ELF_MMAP
-#include <libelf.h>
-int main(void)
-{
-	Elf *elf = elf_begin(0, ELF_C_READ_MMAP, 0);
-	return (long)elf;
-}
-endef
-
-define SOURCE_ELF_GETPHDRNUM
-#include <libelf.h>
-int main(void)
-{
-	size_t dst;
-	return elf_getphdrnum(0, &dst);
-}
-endef
-
-ifndef NO_SLANG
-define SOURCE_SLANG
-#include <slang.h>
-
-int main(void)
-{
-	return SLsmg_init_smg();
-}
-endef
-endif
-
-ifndef NO_GTK2
-define SOURCE_GTK2
-#pragma GCC diagnostic ignored \"-Wstrict-prototypes\"
-#include <gtk/gtk.h>
-#pragma GCC diagnostic error \"-Wstrict-prototypes\"
-
-int main(int argc, char *argv[])
-{
-        gtk_init(&argc, &argv);
-
-        return 0;
-}
-endef
-
-define SOURCE_GTK2_INFOBAR
-#pragma GCC diagnostic ignored \"-Wstrict-prototypes\"
-#include <gtk/gtk.h>
-#pragma GCC diagnostic error \"-Wstrict-prototypes\"
-
-int main(void)
-{
-	gtk_info_bar_new();
-
-	return 0;
-}
-endef
-endif
-
-ifndef NO_LIBPERL
-define SOURCE_PERL_EMBED
-#include <EXTERN.h>
-#include <perl.h>
-
-int main(void)
-{
-perl_alloc();
-return 0;
-}
-endef
-endif
-
-ifndef NO_LIBPYTHON
-define SOURCE_PYTHON_VERSION
-#include <Python.h>
-#if PY_VERSION_HEX >= 0x03000000
-	#error
-#endif
-int main(void)
-{
-	return 0;
-}
-endef
-define SOURCE_PYTHON_EMBED
-#include <Python.h>
-int main(void)
-{
-	Py_Initialize();
-	return 0;
-}
-endef
-endif
-
-define SOURCE_BFD
-#include <bfd.h>
-
-int main(void)
-{
-	bfd_demangle(0, 0, 0);
-	return 0;
-}
-endef
-
-define SOURCE_CPLUS_DEMANGLE
-extern char *cplus_demangle(const char *, int);
-
-int main(void)
-{
-	cplus_demangle(0, 0);
-	return 0;
-}
-endef
-
-define SOURCE_STRLCPY
-#include <stdlib.h>
-extern size_t strlcpy(char *dest, const char *src, size_t size);
-
-int main(void)
-{
-	strlcpy(NULL, NULL, 0);
-	return 0;
-}
-endef
-
-ifndef NO_LIBUNWIND
-define SOURCE_LIBUNWIND
-#include <libunwind.h>
-#include <stdlib.h>
-
-extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
-                                      unw_word_t ip,
-                                      unw_dyn_info_t *di,
-                                      unw_proc_info_t *pi,
-                                      int need_unwind_info, void *arg);
-
-
-#define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
-
-int main(void)
-{
-	unw_addr_space_t addr_space;
-	addr_space = unw_create_addr_space(NULL, 0);
-	unw_init_remote(NULL, addr_space, NULL);
-	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
-	return 0;
-}
-endef
-endif
-
-ifndef NO_BACKTRACE
-define SOURCE_BACKTRACE
-#include <execinfo.h>
-#include <stdio.h>
-
-int main(void)
-{
-	backtrace(NULL, 0);
-	backtrace_symbols(NULL, 0);
-	return 0;
-}
-endef
-endif
-
-ifndef NO_LIBAUDIT
-define SOURCE_LIBAUDIT
-#include <libaudit.h>
-
-int main(void)
-{
-	printf(\"error message: %s\", audit_errno_to_name(0));
-	return audit_open();
-}
-endef
-endif
-
-define SOURCE_ON_EXIT
-#include <stdio.h>
-
-int main(void)
-{
-	return on_exit(NULL, NULL);
-}
-endef
-
-define SOURCE_LIBNUMA
-#include <numa.h>
-#include <numaif.h>
-
-int main(void)
-{
-	numa_available();
-	return 0;
-}
-endef
diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index 94d2d4f..4d985e0 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -178,17 +178,3 @@ endef
 _ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
 _gea_warn = $(warning The path '$(1)' is not executable.)
 _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
-
-# try-cc
-# Usage: option = $(call try-cc, source-to-build, cc-options, msg)
-ifneq ($(V),1)
-TRY_CC_OUTPUT= > /dev/null 2>&1
-endif
-TRY_CC_MSG=echo "    CHK $(3)" 1>&2;
-
-try-cc = $(shell sh -c						  \
-	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
-	 $(TRY_CC_MSG)						  \
-	 echo "$(1)" |						  \
-	 $(CC) -x c - $(2) -o "$$TMP" $(TRY_CC_OUTPUT) && echo y; \
-	 rm -f "$$TMP"')
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 85e1aed..245020c 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -49,14 +49,14 @@ static struct cmd_struct commands[] = {
 	{ "version",	cmd_version,	0 },
 	{ "script",	cmd_script,	0 },
 	{ "sched",	cmd_sched,	0 },
-#ifdef LIBELF_SUPPORT
+#ifdef HAVE_LIBELF_SUPPORT
 	{ "probe",	cmd_probe,	0 },
 #endif
 	{ "kmem",	cmd_kmem,	0 },
 	{ "lock",	cmd_lock,	0 },
 	{ "kvm",	cmd_kvm,	0 },
 	{ "test",	cmd_test,	0 },
-#ifdef LIBAUDIT_SUPPORT
+#ifdef HAVE_LIBAUDIT_SUPPORT
 	{ "trace",	cmd_trace,	0 },
 #endif
 	{ "inject",	cmd_inject,	0 },
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index c95012c..c24d912 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -43,7 +43,7 @@ const char *perf_gtk__get_percent_color(double percent)
 	return NULL;
 }
 
-#ifdef HAVE_GTK_INFO_BAR
+#ifdef HAVE_GTK_INFO_BAR_SUPPORT
 GtkWidget *perf_gtk__setup_info_bar(void)
 {
 	GtkWidget *info_bar;
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 3d96785..a72acbc 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -12,7 +12,7 @@ struct perf_gtk_context {
 	GtkWidget *main_window;
 	GtkWidget *notebook;
 
-#ifdef HAVE_GTK_INFO_BAR
+#ifdef HAVE_GTK_INFO_BAR_SUPPORT
 	GtkWidget *info_bar;
 	GtkWidget *message_label;
 #endif
@@ -39,7 +39,7 @@ void perf_gtk__resize_window(GtkWidget *window);
 const char *perf_gtk__get_percent_color(double percent);
 GtkWidget *perf_gtk__setup_statusbar(void);
 
-#ifdef HAVE_GTK_INFO_BAR
+#ifdef HAVE_GTK_INFO_BAR_SUPPORT
 GtkWidget *perf_gtk__setup_info_bar(void);
 #else
 static inline GtkWidget *perf_gtk__setup_info_bar(void)
diff --git a/tools/perf/ui/gtk/util.c b/tools/perf/ui/gtk/util.c
index c06942a..696c1fb 100644
--- a/tools/perf/ui/gtk/util.c
+++ b/tools/perf/ui/gtk/util.c
@@ -53,7 +53,7 @@ static int perf_gtk__error(const char *format, va_list args)
 	return 0;
 }
 
-#ifdef HAVE_GTK_INFO_BAR
+#ifdef HAVE_GTK_INFO_BAR_SUPPORT
 static int perf_gtk__warning_info_bar(const char *format, va_list args)
 {
 	char *msg;
@@ -105,7 +105,7 @@ static int perf_gtk__warning_statusbar(const char *format, va_list args)
 
 struct perf_error_ops perf_gtk_eops = {
 	.error		= perf_gtk__error,
-#ifdef HAVE_GTK_INFO_BAR
+#ifdef HAVE_GTK_INFO_BAR_SUPPORT
 	.warning	= perf_gtk__warning_info_bar,
 #else
 	.warning	= perf_gtk__warning_statusbar,
diff --git a/tools/perf/ui/ui.h b/tools/perf/ui/ui.h
index 70cb0d4..1349d14 100644
--- a/tools/perf/ui/ui.h
+++ b/tools/perf/ui/ui.h
@@ -12,7 +12,7 @@ extern int use_browser;
 void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
 
-#ifdef SLANG_SUPPORT
+#ifdef HAVE_SLANG_SUPPORT
 int ui__init(void);
 void ui__exit(bool wait_for_ok);
 #else
@@ -23,7 +23,7 @@ static inline int ui__init(void)
 static inline void ui__exit(bool wait_for_ok __maybe_unused) {}
 #endif
 
-#ifdef GTK2_SUPPORT
+#ifdef HAVE_GTK2_SUPPORT
 int perf_gtk__init(void);
 void perf_gtk__exit(bool wait_for_ok);
 #else
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index af75515..f0699e9 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -150,7 +150,7 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map,
 			 struct perf_evsel *evsel, bool print_lines,
 			 bool full_paths, int min_pcnt, int max_lines);
 
-#ifdef SLANG_SUPPORT
+#ifdef HAVE_SLANG_SUPPORT
 int symbol__tui_annotate(struct symbol *sym, struct map *map,
 			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt);
@@ -165,7 +165,7 @@ static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
 }
 #endif
 
-#ifdef GTK2_SUPPORT
+#ifdef HAVE_GTK2_SUPPORT
 int symbol__gtk_annotate(struct symbol *sym, struct map *map,
 			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt);
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 26e3672..7b176dd 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -70,8 +70,7 @@ extern char *perf_path(const char *fmt, ...) __attribute__((format (printf, 1, 2
 extern char *perf_pathdup(const char *fmt, ...)
 	__attribute__((format (printf, 1, 2)));
 
-#ifndef HAVE_STRLCPY
+/* Matches the libc/libbsd function attribute so we declare this unconditionally: */
 extern size_t strlcpy(char *dest, const char *src, size_t size);
-#endif
 
 #endif /* __PERF_CACHE_H */
diff --git a/tools/perf/util/generate-cmdlist.sh b/tools/perf/util/generate-cmdlist.sh
index 3ac3803..36a885d 100755
--- a/tools/perf/util/generate-cmdlist.sh
+++ b/tools/perf/util/generate-cmdlist.sh
@@ -22,7 +22,7 @@ do
      }' "Documentation/perf-$cmd.txt"
 done
 
-echo "#ifdef LIBELF_SUPPORT"
+echo "#ifdef HAVE_LIBELF_SUPPORT"
 sed -n -e 's/^perf-\([^ 	]*\)[ 	].* full.*/\1/p' command-list.txt |
 sort |
 while read cmd
@@ -35,5 +35,5 @@ do
 	    p
      }' "Documentation/perf-$cmd.txt"
 done
-echo "#endif /* LIBELF_SUPPORT */"
+echo "#endif /* HAVE_LIBELF_SUPPORT */"
 echo "};"
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 6a048c0..ed4f90e 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -187,7 +187,7 @@ struct hist_browser_timer {
 	int refresh;
 };
 
-#ifdef SLANG_SUPPORT
+#ifdef HAVE_SLANG_SUPPORT
 #include "../ui/keysyms.h"
 int hist_entry__tui_annotate(struct hist_entry *he, struct perf_evsel *evsel,
 			     struct hist_browser_timer *hbt);
@@ -228,7 +228,7 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 #define K_SWITCH_INPUT_DATA -3000
 #endif
 
-#ifdef GTK2_SUPPORT
+#ifdef HAVE_GTK2_SUPPORT
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
 				  struct hist_browser_timer *hbt __maybe_unused,
 				  float min_pcnt);
diff --git a/tools/perf/util/include/dwarf-regs.h b/tools/perf/util/include/dwarf-regs.h
index cf6727e..8f14965 100644
--- a/tools/perf/util/include/dwarf-regs.h
+++ b/tools/perf/util/include/dwarf-regs.h
@@ -1,7 +1,7 @@
 #ifndef _PERF_DWARF_REGS_H_
 #define _PERF_DWARF_REGS_H_
 
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 const char *get_arch_regstr(unsigned int n);
 #endif
 
diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
index 96b919d..b003ad7 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/perf/util/include/linux/compiler.h
@@ -2,20 +2,29 @@
 #define _PERF_LINUX_COMPILER_H_
 
 #ifndef __always_inline
-#define __always_inline	inline
+# define __always_inline	inline __attribute__((always_inline))
 #endif
+
 #define __user
+
 #ifndef __attribute_const__
-#define __attribute_const__
+# define __attribute_const__
 #endif
 
 #ifndef __maybe_unused
-#define __maybe_unused		__attribute__((unused))
+# define __maybe_unused		__attribute__((unused))
+#endif
+
+#ifndef __packed
+# define __packed		__attribute__((__packed__))
 #endif
-#define __packed	__attribute__((__packed__))
 
 #ifndef __force
-#define __force
+# define __force
+#endif
+
+#ifndef __weak
+# define __weak			__attribute__((weak))
 #endif
 
 #endif
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 4f6680d..17ee458 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -172,7 +172,7 @@ int map__load(struct map *map, symbol_filter_t filter)
 		pr_warning(", continuing without symbols\n");
 		return -1;
 	} else if (nr == 0) {
-#ifdef LIBELF_SUPPORT
+#ifdef HAVE_LIBELF_SUPPORT
 		const size_t len = strlen(name);
 		const size_t real_len = len - sizeof(DSO__DELETED);
 
diff --git a/tools/perf/util/path.c b/tools/perf/util/path.c
index a8c4954..5d13cb4 100644
--- a/tools/perf/util/path.c
+++ b/tools/perf/util/path.c
@@ -22,19 +22,23 @@ static const char *get_perf_dir(void)
 	return ".";
 }
 
-#ifndef HAVE_STRLCPY
-size_t strlcpy(char *dest, const char *src, size_t size)
+/*
+ * If libc has strlcpy() then that version will override this
+ * implementation:
+ */
+size_t __weak strlcpy(char *dest, const char *src, size_t size)
 {
 	size_t ret = strlen(src);
 
 	if (size) {
 		size_t len = (ret >= size) ? size - 1 : ret;
+
 		memcpy(dest, src, len);
 		dest[len] = '\0';
 	}
+
 	return ret;
 }
-#endif
 
 static char *get_pathname(void)
 {
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
index 5a4f2b6f..a3d42cd 100644
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_REGS_H
 #define __PERF_REGS_H
 
-#ifdef HAVE_PERF_REGS
+#ifdef HAVE_PERF_REGS_SUPPORT
 #include <perf_regs.h>
 #else
 #define PERF_REGS_MASK	0
@@ -10,5 +10,5 @@ static inline const char *perf_reg_name(int id __maybe_unused)
 {
 	return NULL;
 }
-#endif /* HAVE_PERF_REGS */
+#endif /* HAVE_PERF_REGS_SUPPORT */
 #endif /* __PERF_REGS_H */
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index aa04bf9..779b2da 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -201,7 +201,7 @@ static int convert_to_perf_probe_point(struct probe_trace_point *tp,
 	return 0;
 }
 
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 /* Open new debuginfo of given module */
 static struct debuginfo *open_debuginfo(const char *module)
 {
@@ -630,7 +630,7 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 	return ret;
 }
 
-#else	/* !DWARF_SUPPORT */
+#else	/* !HAVE_DWARF_SUPPORT */
 
 static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 					struct perf_probe_point *pp)
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 3b7d630..3f0c29d 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -14,7 +14,7 @@ static inline int is_c_varname(const char *name)
 	return isalpha(name[0]) || name[0] == '_';
 }
 
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 
 #include "dwarf-aux.h"
 
@@ -105,6 +105,6 @@ struct line_finder {
 	int			found;
 };
 
-#endif /* DWARF_SUPPORT */
+#endif /* HAVE_DWARF_SUPPORT */
 
 #endif /*_PROBE_FINDER_H */
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index a9c829b..c376930 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -8,7 +8,7 @@
 #include "symbol.h"
 #include "debug.h"
 
-#ifndef HAVE_ELF_GETPHDRNUM
+#ifndef HAVE_ELF_GETPHDRNUM_SUPPORT
 static int elf_getphdrnum(Elf *elf, size_t *dst)
 {
 	GElf_Ehdr gehdr;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index fd5b70e..2a97bb1 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -13,7 +13,7 @@
 #include <libgen.h>
 #include "build-id.h"
 
-#ifdef LIBELF_SUPPORT
+#ifdef HAVE_LIBELF_SUPPORT
 #include <libelf.h>
 #include <gelf.h>
 #endif
@@ -21,7 +21,7 @@
 
 #include "dso.h"
 
-#ifdef HAVE_CPLUS_DEMANGLE
+#ifdef HAVE_CPLUS_DEMANGLE_SUPPORT
 extern char *cplus_demangle(const char *, int);
 
 static inline char *bfd_demangle(void __maybe_unused *v, const char *c, int i)
@@ -46,7 +46,7 @@ static inline char *bfd_demangle(void __maybe_unused *v,
  * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
  * for newer versions we can use mmap to reduce memory usage:
  */
-#ifdef LIBELF_MMAP
+#ifdef HAVE_LIBELF_MMAP_SUPPORT
 # define PERF_ELF_C_READ_MMAP ELF_C_READ_MMAP
 #else
 # define PERF_ELF_C_READ_MMAP ELF_C_READ
@@ -178,7 +178,7 @@ struct symsrc {
 	int fd;
 	enum dso_binary_type type;
 
-#ifdef LIBELF_SUPPORT
+#ifdef HAVE_LIBELF_SUPPORT
 	Elf *elf;
 	GElf_Ehdr ehdr;
 
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index cb6bc50..ec0c71a 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -13,7 +13,7 @@ struct unwind_entry {
 
 typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry, void *arg);
 
-#ifdef LIBUNWIND_SUPPORT
+#ifdef HAVE_LIBUNWIND_SUPPORT
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine,
 			struct thread *thread,
@@ -31,5 +31,5 @@ unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 {
 	return 0;
 }
-#endif /* LIBUNWIND_SUPPORT */
+#endif /* HAVE_LIBUNWIND_SUPPORT */
 #endif /* __UNWIND_H */
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 6d17b18..ccfdeb6 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,7 +1,7 @@
 #include "../perf.h"
 #include "util.h"
 #include <sys/mman.h>
-#ifdef BACKTRACE_SUPPORT
+#ifdef HAVE_BACKTRACE_SUPPORT
 #include <execinfo.h>
 #endif
 #include <stdio.h>
@@ -204,7 +204,7 @@ int hex2u64(const char *ptr, u64 *long_val)
 }
 
 /* Obtain a backtrace and print it to stdout. */
-#ifdef BACKTRACE_SUPPORT
+#ifdef HAVE_BACKTRACE_SUPPORT
 void dump_stack(void)
 {
 	void *array[16];
