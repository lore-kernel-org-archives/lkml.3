Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab3DATWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:22:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759521Ab3DATWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:22:14 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 27/27] perf tools: Add kbuild support into Makefile.kbuild
Date: Mon,  1 Apr 2013 21:18:50 +0200
Message-Id: <1364843930-17974-28-git-send-email-jolsa@redhat.com>
In-Reply-To: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding kbuild support into Makefile.kbuild. The 'legacy'
Makefile still stays untouched as it was.

It's possible to use kbuild by running 'make -f Makefile.kbuild'
with any option supported by 'legacy' Makefile.

We now have 2 config files:
  '.config' - user configured setup
  '.config-detected' - system detected setup

The '.config-detected' affects '.config' and if there's
configured feature in '.config' which was not detected
it is automatically disabled.

The '.config-detected' is re/created if:
  - there's no '.config-detected'
  - '.config' was changed

In a cleaned tree the perf is built with 'allyesconfig'
having disabled all non-detected features, just as it is
done now.

You can change '.config' via:
  make -f Makefile.kbuild menuconfig

There's difference for O=DIR build. The DIR is populated
based on kernel source tree, so the final binary is created
under DIR/tools/perf.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Kbuild                                |  47 +++
 tools/perf/Kconfig                               | 256 ++++++++++++++
 tools/perf/Makefile                              |   2 +-
 tools/perf/Makefile.kbuild                       | 411 +++++++++++++++++++++++
 tools/perf/arch/Kbuild                           |   3 +
 tools/perf/arch/x86/Kbuild                       |   1 +
 tools/perf/arch/x86/util/Kbuild                  |   3 +
 tools/perf/bench/Kbuild                          |   9 +
 tools/perf/builtin-cmds.h                        |   4 +
 tools/perf/config/Makefile                       |  46 +++
 tools/perf/config/Makefile.fix-config            | 104 ++++++
 tools/perf/config/Makefile.fix-legacy            |  46 +++
 tools/perf/config/defconfig                      |  54 +++
 tools/perf/scripts/perl/Perf-Trace-Util/Kbuild   |   3 +
 tools/perf/scripts/python/Perf-Trace-Util/Kbuild |   4 +
 tools/perf/tests/Kbuild                          |  23 ++
 tools/perf/ui/Kbuild                             |  14 +
 tools/perf/ui/browsers/Kbuild                    |   6 +
 tools/perf/ui/gtk/Kbuild                         |   7 +
 tools/perf/ui/stdio/Kbuild                       |   1 +
 tools/perf/ui/tui/Kbuild                         |   4 +
 tools/perf/util/Kbuild                           | 113 +++++++
 tools/perf/util/PERF-VERSION-GEN                 |   6 +-
 tools/perf/util/generate-cmdlist.sh              |   8 +-
 tools/perf/util/scripting-engines/Kbuild         |   7 +
 tools/perf/util/setup.py                         |  10 +-
 26 files changed, 1183 insertions(+), 9 deletions(-)
 create mode 100644 tools/perf/Kbuild
 create mode 100644 tools/perf/Kconfig
 create mode 100644 tools/perf/Makefile.kbuild
 create mode 100644 tools/perf/arch/Kbuild
 create mode 100644 tools/perf/arch/x86/Kbuild
 create mode 100644 tools/perf/arch/x86/util/Kbuild
 create mode 100644 tools/perf/bench/Kbuild
 create mode 100644 tools/perf/config/Makefile.fix-config
 create mode 100644 tools/perf/config/Makefile.fix-legacy
 create mode 100644 tools/perf/config/defconfig
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/Kbuild
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/Kbuild
 create mode 100644 tools/perf/tests/Kbuild
 create mode 100644 tools/perf/ui/Kbuild
 create mode 100644 tools/perf/ui/browsers/Kbuild
 create mode 100644 tools/perf/ui/gtk/Kbuild
 create mode 100644 tools/perf/ui/stdio/Kbuild
 create mode 100644 tools/perf/ui/tui/Kbuild
 create mode 100644 tools/perf/util/Kbuild
 create mode 100644 tools/perf/util/scripting-engines/Kbuild

diff --git a/tools/perf/Kbuild b/tools/perf/Kbuild
new file mode 100644
index 0000000..80b9184
--- /dev/null
+++ b/tools/perf/Kbuild
@@ -0,0 +1,47 @@
+obj-y += perf.o
+
+obj-$(CONFIG_BUILTIN_ANNOTATE)      += builtin-annotate.o
+obj-$(CONFIG_BUILTIN_BENCH)         += builtin-bench.o
+obj-$(CONFIG_BUILTIN_BENCH)         += bench/
+obj-$(CONFIG_BUILTIN_BUILDID_CACHE) += builtin-buildid-cache.o
+obj-$(CONFIG_BUILTIN_BUILDID_LIST)  += builtin-buildid-list.o
+obj-$(CONFIG_BUILTIN_DIFF)          += builtin-diff.o
+obj-$(CONFIG_BUILTIN_EVLIST)        += builtin-evlist.o
+obj-$(CONFIG_BUILTIN_HELP)          += builtin-help.o
+obj-$(CONFIG_BUILTIN_INJECT)        += builtin-inject.o
+obj-$(CONFIG_BUILTIN_KMEM)          += builtin-kmem.o
+obj-$(CONFIG_BUILTIN_KVM)           += builtin-kvm.o
+obj-$(CONFIG_BUILTIN_LIST)          += builtin-list.o
+obj-$(CONFIG_BUILTIN_LOCK)          += builtin-lock.o
+obj-$(CONFIG_BUILTIN_PROBE)         += builtin-probe.o
+obj-$(CONFIG_BUILTIN_RECORD)        += builtin-record.o
+obj-$(CONFIG_BUILTIN_REPORT)        += builtin-report.o
+obj-$(CONFIG_BUILTIN_SCHED)         += builtin-sched.o
+obj-$(CONFIG_BUILTIN_SCRIPT)        += builtin-script.o
+obj-$(CONFIG_BUILTIN_STAT)          += builtin-stat.o
+obj-$(CONFIG_BUILTIN_TIMECHART)     += builtin-timechart.o
+obj-$(CONFIG_BUILTIN_TOP)           += builtin-top.o
+obj-$(CONFIG_BUILTIN_TRACE)         += builtin-trace.o
+obj-$(CONFIG_BUILTIN_MEM)           += builtin-mem.o
+obj-$(CONFIG_BUILTIN_TEST)          += tests/
+
+obj-y += ../../lib/rbtree.o
+
+obj-y += util/
+obj-y += ui/
+obj-y += arch/
+
+obj-$(CONFIG_LIBPERL)   += scripts/perl/Perf-Trace-Util/
+obj-$(CONFIG_LIBPYTHON) += scripts/python/Perf-Trace-Util/
+
+
+CFLAGS_rbtree.o += -Wno-unused-parameter
+
+CFLAGS_perf.o += -D"PERF_HTML_PATH=KBUILD_STR($(htmldir_SQ))"
+CFLAGS_perf.o += -include PERF-VERSION-FILE
+
+$(obj)/perf.o: $(obj)/PERF-VERSION-FILE
+
+CFLAGS_builtin-help.o += -D"PERF_HTML_PATH=KBUILD_STR($(htmldir_SQ))"
+CFLAGS_builtin-help.o += -D"PERF_INFO_PATH=KBUILD_STR($(infodir_SQ))"
+CFLAGS_builtin-help.o += -D"PERF_MAN_PATH=KBUILD_STR($(mandir_SQ))"
diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
new file mode 100644
index 0000000..5f3a6b7
--- /dev/null
+++ b/tools/perf/Kconfig
@@ -0,0 +1,256 @@
+
+mainmenu "The perf configuration"
+
+menu "Built-in commands"
+
+config BUILTIN_RECORD
+	bool "record"
+	default y
+        ---help---
+	  record
+
+config BUILTIN_REPORT
+	bool "report"
+	default y
+        ---help---
+	  report
+
+config BUILTIN_STAT
+	bool "stat"
+	default y
+        ---help---
+	  stat
+
+config BUILTIN_TOP
+	bool "top"
+	default n
+        ---help---
+	  top
+
+config BUILTIN_TRACE
+	bool "trace"
+	default n
+	depends on CONFIG_LIBAUDIT
+        ---help---
+	  trace
+
+config BUILTIN_ANNOTATE
+	bool "annotate"
+	default n
+        ---help---
+	  annotate
+
+config BUILTIN_BENCH
+	bool "bench"
+	default n
+        ---help---
+	  bench
+
+config BUILTIN_BUILDID_CACHE
+	bool "buildid-cache"
+	default n
+        ---help---
+	  buildid-cache
+
+config BUILTIN_BUILDID_LIST
+	bool "buildid-list"
+	default n
+        ---help---
+	  buildid-list
+
+config BUILTIN_DIFF
+	bool "diff"
+	default y
+        ---help---
+	  diff
+
+config BUILTIN_EVLIST
+	bool "evlist"
+	default n
+        ---help---
+	  evlist
+
+config BUILTIN_HELP
+	bool "help"
+	default y
+        ---help---
+	  help
+
+config BUILTIN_INJECT
+	bool "inject"
+	default n
+        ---help---
+	  inject
+
+config BUILTIN_KMEM
+	bool "kmem"
+	default n
+        ---help---
+	  kmem
+
+config BUILTIN_KVM
+	bool "kvm"
+	default n
+        ---help---
+	  kvm
+
+config BUILTIN_LIST
+	bool "list"
+	default n
+        ---help---
+	  list
+
+config BUILTIN_LOCK
+	bool "lock"
+	default n
+        ---help---
+	  lock
+
+config BUILTIN_PROBE
+	bool "probe"
+	default n
+	depends on LIBELF
+        ---help---
+	  probe
+
+config BUILTIN_SCHED
+	bool "sched"
+	default n
+        ---help---
+	  sched
+
+config BUILTIN_SCRIPT
+	bool "script"
+	default y
+        ---help---
+	  script
+
+config BUILTIN_TIMECHART
+	bool "timechart"
+	default n
+        ---help---
+	  timechart
+
+config BUILTIN_MEM
+	bool "mem"
+	default y
+        ---help---
+	  mem
+
+config BUILTIN_TEST
+	bool "test"
+	default y
+        ---help---
+	  test
+
+endmenu
+
+menu "Libraries"
+
+config LIBAUDIT
+	bool "Audit (libaudit)"
+	default n
+        ---help---
+	  libaudit
+
+config LIBPERL
+	bool "Perl"
+	default n
+        ---help---
+	  Perl
+
+config LIBPYTHON
+	bool "Python"
+	default n
+        ---help---
+	  Python
+
+choice
+	prompt "Elf library"
+	default LIBELF
+
+	config LIBELF
+	bool "elf"
+	---help---
+	  libelf
+
+	config LIBELF_MINIMAL
+	bool "builtin support"
+	---help---
+	  builtin elf support
+endchoice
+
+config LIBUNWIND
+	bool "User space libunwind callchains"
+        ---help---
+	  libunwind
+
+config LIBUNWIND_DIR
+	string "libunwind directory"
+	depends on LIBUNWIND
+        ---help---
+	  libunwind directory
+
+
+config NUMA
+	bool "Numa support (bench)"
+	default n
+        ---help---
+	  numa
+
+config DEMANGLE
+	bool "Demangle symbols"
+	default n
+        ---help---
+	  demangle
+
+config BIONIC
+	bool "Bionic support"
+	default n
+        ---help---
+	  bionic
+
+endmenu
+
+menu "GUI"
+
+config STDIO
+	bool "Terminal"
+	default y
+        ---help---
+	  stdio
+
+config TUI
+	bool "Tui (newt based)"
+	default n
+        ---help---
+	  stdio
+
+config GTK2
+	bool "Gtk2"
+	default n
+        ---help---
+	  stdio
+
+endmenu
+
+menu "Build"
+config DEBUG
+	bool "Compile with debug info"
+	default n
+        ---help---
+	  debug info
+
+config DEBUG_PARSER
+	bool "Compile with parsers debug info"
+	default n
+        ---help---
+	  debug info
+
+config BACKTRACE
+	bool "Compile with dump_stack support"
+	default n
+        ---help---
+	  dump_stack support
+
+endmenu
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bc35337..e13c07e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -545,7 +545,7 @@ $(OUTPUT)builtin-timechart.o: builtin-timechart.c $(OUTPUT)common-cmds.h $(OUTPU
 $(OUTPUT)common-cmds.h: util/generate-cmdlist.sh command-list.txt
 
 $(OUTPUT)common-cmds.h: $(wildcard Documentation/perf-*.txt)
-	$(QUIET_GEN). util/generate-cmdlist.sh > $@+ && mv $@+ $@
+	$(QUIET_GEN). util/generate-cmdlist.sh ./ > $@+ && mv $@+ $@
 
 $(SCRIPTS) : % : %.sh
 	$(QUIET_GEN)$(INSTALL) '$@.sh' '$(OUTPUT)$@'
diff --git a/tools/perf/Makefile.kbuild b/tools/perf/Makefile.kbuild
new file mode 100644
index 0000000..41beb83
--- /dev/null
+++ b/tools/perf/Makefile.kbuild
@@ -0,0 +1,411 @@
+srctree := $(abspath $(if $(KBUILD_SRC),$(KBUILD_SRC),$(CURDIR)/../../))
+objtree := $(abspath $(if $(KBUILD_SRC),$(CURDIR),$(CURDIR)/../..))
+
+VPATH   := $(srctree)
+
+export srctree VPATH
+
+MAKEFLAGS += --include-dir=$(srctree)
+MAKEFLAGS += --no-builtin-rules
+MAKEFLAGS += --no-print-directory
+
+ifeq ("$(origin V)", "command line")
+KBUILD_VERBOSE = $(V)
+endif
+
+ifndef KBUILD_VERBOSE
+KBUILD_VERBOSE = 0
+endif
+
+ifeq ($(KBUILD_VERBOSE),1)
+quiet =
+Q =
+else
+quiet=quiet_
+Q = @
+endif
+
+# If the user is running make -s (silent mode), suppress echoing of
+# commands
+ifneq ($(filter s% -s%,$(MAKEFLAGS)),)
+quiet=silent_
+endif
+
+export quiet Q KBUILD_VERBOSE
+
+ifndef V
+QUIET_LINK  = @echo '  LD      $@';
+QUIET_GEN   = @echo '  GEN     $@';
+QUIET_CLEAN = @echo '  CLEAN   tools/perf';
+endif
+
+export QUIET_BISON QUIET_FLEX
+
+ifeq ($(KBUILD_SRC),)
+
+ifeq ("$(origin O)", "command line")
+KBUILD_OUTPUT := $(O)
+else
+KBUILD_OUTPUT := $(objtree)
+endif
+
+# Invoke a second make in the output directory, passing relevant variables
+# check that the output directory actually exists
+saved-output := $(KBUILD_OUTPUT)
+KBUILD_OUTPUT := $(shell cd $(KBUILD_OUTPUT) && /bin/pwd)
+$(if $(KBUILD_OUTPUT),, \
+     $(error output directory "$(saved-output)" does not exist))
+
+dummy := $(shell mkdir -p $(KBUILD_OUTPUT)/lib)
+dummy := $(shell mkdir -p $(KBUILD_OUTPUT)/include/config)
+dummy := $(shell mkdir -p $(KBUILD_OUTPUT)/tools/perf)
+
+PHONY += $(MAKECMDGOALS) sub-make
+
+$(filter-out sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) all: sub-make
+        @:
+
+sub-make: FORCE
+	$(if $(KBUILD_VERBOSE:1=),@)$(MAKE) -C $(KBUILD_OUTPUT) \
+	KBUILD_SRC=$(srctree) \
+	-f $(CURDIR)/Makefile.kbuild \
+	$(filter-out sub-make,$(MAKECMDGOALS))
+
+# Leave processing to above invocation of make
+skip-makefile := 1
+endif # ifeq ($(KBUILD_SRC),)
+
+export KBUILD_SRC
+
+ifeq ($(skip-makefile),)
+
+build := -f $(srctree)/scripts/Makefile.build obj
+
+src-kernel := $(srctree)
+src-perf   := $(srctree)/tools/perf
+obj-kernel := $(objtree)
+obj-perf   := $(objtree)/tools/perf
+
+VPATH += $(src-perf)
+
+export src-perf obj-perf
+
+OUTPUT := $(obj-perf)
+
+export OUTPUT
+
+AS      = as
+LD      = ld
+CC      = gcc
+CPP     = $(CC) -E
+HOSTCC  = gcc
+FLEX    = flex
+BISON   = bison
+INSTALL = install
+
+export AS LD CC CPP HOSTCC FLEX BISON
+
+# kbuild related config
+CONFIG_SHELL          := /bin/sh
+
+KBUILD_KCONFIG        := $(src-perf)/Kconfig
+KBUILD_AUTOCONF       := $(obj-perf)/include/config/auto.conf
+
+KCONFIG_CONFIG        ?= $(obj-perf)/.config
+KCONFIG_TRISTATE      := $(obj-perf)/include/config/tristate.conf
+KCONFIG_AUTOHEADER    := $(obj-perf)/include/generated/autoconf.h
+KCONFIG_AUTOCONFIG    := $(KBUILD_AUTOCONF)
+KCONFIG_AUTOCONFIGDEP := $(KBUILD_AUTOCONF).cmd
+
+export CONFIG_SHELL
+export KBUILD_KCONFIG KBUILD_AUTOCONF
+export KCONFIG_CONFIG KCONFIG_TRISTATE KCONFIG_AUTOHEADER
+export KCONFIG_AUTOCONFIG KCONFIG_AUTOCONFIGDEP
+
+# perf detected config
+CONFIG_DETECTED := $(obj-perf)/.config-detected
+
+export CONFIG_DETECTED
+
+# external .a libs
+LK_DIR          := $(srctree)/tools/lib/lk/
+TRACE_EVENT_DIR := $(srctree)/tools/lib/traceevent/
+
+LIBTRACEEVENT   := $(obj-kernel)/tools/lib/traceevent/libtraceevent.a
+LIBLK           := $(obj-kernel)/tools/lib/lk/liblk.a
+LIBS_A          := $(LIBTRACEEVENT) $(LIBLK)
+
+export TRACE_EVENT_DIR LK_DIR LIBTRACEEVENT LIBLK
+
+all:
+
+scripts_basic:
+	$(Q)$(MAKE) $(build)=scripts/basic
+
+defconfig: scripts_basic
+	$(Q)cp $(src-perf)/config/defconfig $(KCONFIG_CONFIG)
+	$(Q)$(MAKE) -s $(build)=scripts/kconfig oldconfig
+
+%config: scripts_basic
+	$(Q)$(MAKE) -s $(build)=scripts/kconfig $@
+
+$(KCONFIG_CONFIG):
+	$(Q)$(MAKE) $(build)=scripts/basic
+	$(Q)$(MAKE) -s $(build)=scripts/kconfig allyesconfig
+
+$(CONFIG_DETECTED): $(KCONFIG_CONFIG)
+	$(Q)$(MAKE) -f $(src-perf)/config/Makefile
+
+# no need to include auto.conf.cmd, because .config
+# is the only dependency here
+$(KCONFIG_AUTOCONFIG): $(KCONFIG_CONFIG) $(CONFIG_DETECTED)
+	$(Q)$(MAKE) -f $(src-perf)/config/Makefile.fix-config
+	$(Q)mkdir -p $(obj-perf)/include/config
+	$(Q)mkdir -p $(obj-perf)/include/generated
+	$(Q)$(MAKE) -s $(build)=scripts/kconfig silentoldconfig
+	@touch $(CONFIG_DETECTED) # final touch.. to keep the time dependency correct
+
+clean-dirs := $(addprefix _clean_, tools/perf/)
+
+$(clean-dirs):
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.clean obj=$(patsubst _clean_%,%,$@)
+
+clean: $(clean-dirs) $(LIBTRACEEVENT)-clean $(LIBLK)-clean
+	$(Q)$(QUIET_CLEAN)
+	$(Q)rm -f $(obj-perf)/perf
+	$(Q)rm -f $(obj-perf)/common-cmds.h
+	$(Q)rm -f $(obj-perf)/python/perf.so
+	$(Q)rm -rf $(obj-perf)/include/generated $(obj-perf)/include/config
+	$(Q)find $(obj-perf) \
+		\( -name '*.[oas]' -o -name '.*.cmd' \
+		-o -name '.*.d' -o -name '.*.tmp' \
+		-o -name '*-flex.[ch]' -o -name '*-bison.[ch]' \
+		\) -type f -print | xargs rm -f
+	$(Q)$(python-clean)
+	$(Q)rm -f $(CONFIG_DETECTED) $(KCONFIG_CONFIG)
+
+TAGS tags:
+	$(Q)rm -f $(src-perf)/tags
+	$(QUIET_GEN)cd $(src-perf); find . -name '*.[hcS]' -print | xargs ctags -a
+
+cscope:
+	$(Q)rm -f $(src-perf)/cscope*
+	$(QUIET_GEN)cd $(src-perf); find . -name '*.[hcS]' -print | xargs cscope -b
+
+PHONY += clean $(clean-dirs) tags TAGS cscope
+
+ifneq ($(filter %config help clean tags TAGS cscope,$(MAKECMDGOALS)),)
+dont-detect := 1
+endif
+
+ifndef dont-detect
+# detected config variables
+include $(CONFIG_DETECTED)
+
+# Following variables are needed within Kbuild files, we need
+# to export them as they are not part of the .config set.
+export CONFIG_ARCH := $(ARCH)
+export CONFIG_X86_64
+export htmldir_SQ
+export infodir_SQ
+export mandir_SQ
+export perfexecdir_SQ
+export prefix_SQ
+export PARSER_DEBUG_BISON
+export PARSER_DEBUG_FLEX
+export ETC_PERFCONFIG_SQ
+export PYTHON_EMBED_CCOPTS
+export PERL_EMBED_CCOPTS
+endif
+
+# let sources know it's kbuild
+CFLAGS += -DCONFIG_KBUILD
+
+# kbuild related config
+LINUXINCLUDE    := $(CFLAGS)
+KBUILD_BUILTIN  := 1
+KBUILD_CHECKSRC := 0
+
+export LINUXINCLUDE
+export KBUILD_BUILTIN KBUILD_CHECKSRC
+
+# pyuthon language binding
+PYTHON_EXTBUILD     := $(src-perf)/python_ext_build/
+PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
+PYTHON_EXTBUILD_TMP := $(PYTHON_EXTBUILD)tmp/
+
+export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
+
+python-clean := rm -rf $(PYTHON_EXTBUILD) $(obj-perf)/python/perf.so
+
+PYTHON_EXT_SRCS   := $(addprefix $(src-perf)/,$(shell grep -v ^\# $(src-perf)/util/python-ext-sources))
+PYTHON_EXT_DEPS   := $(src-perf)/util/python-ext-sources $(src-perf)/util/setup.py
+PYTHON_EXT_CFLAGS := $(CFLAGS) -w
+
+export PYTHON_EXT_SRCS
+
+
+$(obj-perf)/python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
+	$(QUIET_GEN)CFLAGS='$(PYTHON_EXT_CFLAGS)' $(PYTHON_WORD) $(src-perf)/util/setup.py \
+	  --quiet build_ext; \
+	mkdir -p $(obj-perf)/python && \
+	cp $(PYTHON_EXTBUILD_LIB)perf.so $(obj-perf)/python/
+
+all: tools/perf/PERF-VERSION-FILE scripts_basic $(KBUILD_AUTOCONF) tools/perf/perf $(LANG_BINDINGS)
+
+$(obj-perf)/common-cmds.h: $(src-perf)/util/generate-cmdlist.sh $(src-perf)/command-list.txt
+	$(QUIET_GEN)$(src-perf)/util/generate-cmdlist.sh $(src-perf) > $@+ && mv $@+ $@
+
+PHONY += all scripts_basic
+
+$(obj-perf)/built-in.o: $(obj-perf)/common-cmds.h FORCE
+	$(Q)$(MAKE) $(build)=tools/perf
+
+LIBS = -Wl,--whole-archive $^ -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
+
+tools/perf/perf: $(obj-perf)/built-in.o $(LIBS_A)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(LIBS)
+
+$(LIBTRACEEVENT): FORCE
+	@mkdir -p $(obj-kernel)/tools/lib/traceevent
+	$(Q)$(MAKE) -C $(src-kernel)/tools/lib/traceevent O=$(obj-kernel)/tools/lib/traceevent
+
+$(LIBTRACEEVENT)-clean: FORCE
+	@mkdir -p $(obj-kernel)/tools/lib/traceevent
+	$(Q)$(MAKE) -sC $(srctree)/tools/lib/traceevent O=$(obj-kernel)/tools/lib/traceevent clean
+
+PHONY += $(TRACE_EVENT_DIR) $(TRACE_EVENT_DIR)-clean
+
+$(LIBLK): FORCE
+	@mkdir -p $(obj-kernel)/tools/lib/lk
+	$(Q)$(MAKE) -C $(srctree)/tools/lib/lk O=$(obj-kernel)/tools/lib/lk
+
+$(LIBLK)-clean: FORCE
+	@mkdir -p $(obj-kernel)/tools/lib/lk
+	$(Q)$(MAKE) -sC $(srctree)/tools/lib/lk O=$(obj-kernel)/tools/lib/lk clean
+
+tools/perf/PERF-VERSION-FILE: FORCE
+	$(QUIET_GEN)$(SHELL_PATH) $(src-perf)/util/PERF-VERSION-GEN $(obj-perf)/
+
+
+# Single targets
+# ---------------------------------------------------------------------------
+# Single targets are compatible with:
+# - build with mixed source and output
+# - build with separate output dir 'make O=...'
+# - external modules
+#
+#  target-dir => where to store outputfile
+#  build-dir  => directory in kernel source tree to use
+
+build-dir  = $(patsubst $(obj-kernel)/%,%,$(abspath $(obj-perf)/$(patsubst %/,%,$(dir $@))))
+target-dir = $(patsubst $(obj-kernel)/%,%,$(abspath $(obj-perf)/$(dir $@)))
+
+%.o: %.c scripts_basic FORCE
+	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)/$(notdir $@)
+%.s: %.c scripts_basic FORCE
+	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)/$(notdir $@)
+%.i: %.c scripts_basic FORCE
+	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)/$(notdir $@)
+%.s: %.S scripts_basic FORCE
+	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)/$(notdir $@)
+%.o: %.S scripts_basic FORCE
+	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)/$(notdir $@)
+
+SCRIPT_SH += $(src-perf)/perf-archive.sh
+SCRIPTS    = $(patsubst %.sh,%,$(SCRIPT_SH))
+
+$(SCRIPTS) : % : %.sh
+	$(QUIET_GEN)$(INSTALL) '$@.sh' '$(perf-obj)$@'
+
+all: $(SCRIPTS)
+
+install-bin: all
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
+	$(INSTALL) $(obj-perf)/perf '$(DESTDIR_SQ)$(bindir_SQ)'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
+	$(INSTALL) $(src-perf)/perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
+	$(INSTALL) $(src-perf)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
+	$(INSTALL) $(src-perf)/scripts/perl/*.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'
+	$(INSTALL) $(src-perf)/scripts/perl/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
+	$(INSTALL) $(src-perf)/scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
+	$(INSTALL) $(src-perf)/scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
+	$(INSTALL) $(src-perf)/scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d'
+	$(INSTALL) $(src-perf)/bash_completion '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d/perf'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
+	$(INSTALL) $(src-perf)/tests/attr.py '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
+	$(INSTALL) $(src-perf)/tests/attr/* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
+
+install: install-bin try-install-man
+
+DOC_TARGETS := doc man html info pdf
+
+$(DOC_TARGETS):
+	$(Q)$(MAKE) -C $(src-perf)/Documentation $(@:doc=all)
+
+INSTALL_DOC_TARGETS := $(patsubst %,install-%,$(DOC_TARGETS)) try-install-man
+INSTALL_DOC_TARGETS += quick-install-doc quick-install-man quick-install-html
+
+# 'make install-doc' should call 'make -C Documentation install'
+$(INSTALL_DOC_TARGETS):
+	$(Q)$(MAKE) -C $(src-perf)/Documentation $(@:-doc=)
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
+ifdef MAKE_DEBUG
+dummy := $(info DEBUG MAKEFLAGS             $(MAKEFLAGS))
+dummy := $(info DEBUG VPATH                 $(VPATH))
+dummy := $(info DEBUG srctree               $(srctree))
+dummy := $(info DEBUG objtree               $(objtree))
+dummy := $(info DEBUG src-kernel            $(src-kernel))
+dummy := $(info DEBUG src-perf              $(src-perf))
+dummy := $(info DEBUG obj-kernel            $(obj-kernel))
+dummy := $(info DEBUG obj-perf              $(obj-perf))
+dummy := $(info DEBUG KBUILD_KCONFIG        $(KBUILD_KCONFIG))
+dummy := $(info DEBUG KBUILD_AUTOCONF       $(KBUILD_AUTOCONF))
+dummy := $(info DEBUG KCONFIG_CONFIG        $(KCONFIG_CONFIG))
+dummy := $(info DEBUG KCONFIG_TRISTATE      $(KCONFIG_TRISTATE))
+dummy := $(info DEBUG KCONFIG_AUTOHEADER    $(KCONFIG_AUTOHEADER))
+dummy := $(info DEBUG KCONFIG_AUTOCONFIG    $(KCONFIG_AUTOCONFIG))
+dummy := $(info DEBUG KCONFIG_AUTOCONFIGDEP $(KCONFIG_AUTOCONFIGDEP))
+dummy := $(info DEBUG TRACE_EVENT_DIR       $(TRACE_EVENT_DIR))
+dummy := $(info DEBUG LK_DIR                $(LK_DIR))
+endif
+
+endif  # skip-makefile
+
+PHONY += FORCE
+.PHONY: $(PHONY)
diff --git a/tools/perf/arch/Kbuild b/tools/perf/arch/Kbuild
new file mode 100644
index 0000000..5cf419e
--- /dev/null
+++ b/tools/perf/arch/Kbuild
@@ -0,0 +1,3 @@
+obj-y += common.o
+
+obj-y += $(CONFIG_ARCH)/
diff --git a/tools/perf/arch/x86/Kbuild b/tools/perf/arch/x86/Kbuild
new file mode 100644
index 0000000..52fd6fa
--- /dev/null
+++ b/tools/perf/arch/x86/Kbuild
@@ -0,0 +1 @@
+obj-y += util/
diff --git a/tools/perf/arch/x86/util/Kbuild b/tools/perf/arch/x86/util/Kbuild
new file mode 100644
index 0000000..0ba617a
--- /dev/null
+++ b/tools/perf/arch/x86/util/Kbuild
@@ -0,0 +1,3 @@
+obj-y += dwarf-regs.o
+obj-y += header.o
+obj-$(CONFIG_LIBUNWIND) += unwind.o
diff --git a/tools/perf/bench/Kbuild b/tools/perf/bench/Kbuild
new file mode 100644
index 0000000..8883de9
--- /dev/null
+++ b/tools/perf/bench/Kbuild
@@ -0,0 +1,9 @@
+obj-y += mem-memcpy.o
+obj-y += mem-memset.o
+obj-y += sched-messaging.o
+obj-y += sched-pipe.o
+
+obj-$(CONFIG_NUMA) += numa.o
+
+obj-$(CONFIG_X86_64) += mem-memcpy-x86-64-asm.o
+obj-$(CONFIG_X86_64) += mem-memset-x86-64-asm.o
diff --git a/tools/perf/builtin-cmds.h b/tools/perf/builtin-cmds.h
index fec342a..936842d 100644
--- a/tools/perf/builtin-cmds.h
+++ b/tools/perf/builtin-cmds.h
@@ -1,6 +1,7 @@
 #ifndef BUILTIN_CMDS_H
 #define BUILTIN_CMDS_H
 
+#ifndef CONFIG_KBUILD
 #define CONFIG_BUILTIN_REPORT 1
 #define CONFIG_BUILTIN_SCRIPT 1
 #define CONFIG_BUILTIN_BENCH 1
@@ -23,5 +24,8 @@
 #define CONFIG_BUILTIN_HELP 1
 #define CONFIG_BUILTIN_PROBE 1
 #define CONFIG_BUILTIN_MEM 1
+#else
+#include <generated/autoconf.h>
+#endif /* CONFIG_KBUILD */
 
 #endif /* BUILTIN_CMDS_H */
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index cc464f1..7bdc0ad 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -28,6 +28,7 @@ ifeq ($(ARCH),x86_64)
 	endif
 	NO_PERF_REGS := 0
 	LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
+	CONFIG_X86_64=y
 endif
 
 ifeq ($(NO_PERF_REGS),0)
@@ -46,6 +47,10 @@ ifneq ($(obj-perf),)
 obj-perf := $(abspath $(obj-perf))/
 endif
 
+ifdef KCONFIG_CONFIG
+include $(src-perf)/config/Makefile.fix-legacy
+endif
+
 # include ARCH specific config
 -include $(src-perf)/arch/$(ARCH)/Makefile
 
@@ -108,6 +113,7 @@ endif
 
 CFLAGS += \
 	-I$(src-perf)/util/include \
+	-I$(obj-perf)/include \
 	-I$(src-perf)/arch/$(ARCH)/include \
 	-I$(srctree)/arch/$(ARCH)/include/uapi \
 	-I$(srctree)/arch/$(ARCH)/include \
@@ -480,3 +486,43 @@ else
 perfexec_instdir = $(prefix)/$(perfexecdir)
 endif
 perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
+
+
+ifdef CONFIG_DETECTED
+
+store = @echo "$(1)=$($(1))" >> $(CONFIG_DETECTED)
+
+all:
+	$(call store,ARCH)
+	$(call store,CFLAGS)
+	$(call store,LDFLAGS)
+	$(call store,EXTLIBS)
+	$(call store,htmldir_SQ)
+	$(call store,infodir_SQ)
+	$(call store,mandir_SQ)
+	$(call store,perfexecdir_SQ)
+	$(call store,prefix_SQ)
+	$(call store,PARSER_DEBUG_BISON)
+	$(call store,PARSER_DEBUG_FLEX)
+	$(call store,PYTHON_EMBED_CCOPTS)
+	$(call store,PERL_EMBED_CCOPTS)
+	$(call store,CONFIG_X86_64)
+	$(call store,NO_LIBUNWIND)
+	$(call store,NO_LIBPERL)
+	$(call store,NO_LIBPYTHON)
+	$(call store,NO_NEWT)
+	$(call store,NO_GTK2)
+	$(call store,NO_DEMANGLE)
+	$(call store,NO_LIBELF)
+	$(call store,NO_LIBUNWIND)
+	$(call store,NO_BACKTRACE)
+	$(call store,NO_LIBNUMA)
+	$(call store,NO_LIBAUDIT)
+	$(call store,NO_LIBBIONIC)
+	$(call store,ETC_PERFCONFIG_SQ)
+	$(call store,DESTDIR_SQ)
+	$(call store,bindir_SQ)
+	$(call store,perfexec_instdir_SQ)
+	$(call store,sysconfdir_SQ)
+
+endif # CONFIG_DETECTED
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
new file mode 100644
index 0000000..7f65fdb
--- /dev/null
+++ b/tools/perf/config/Makefile.fix-config
@@ -0,0 +1,104 @@
+include $(CONFIG_DETECTED)
+include $(KCONFIG_CONFIG)
+
+CONFIG := $(srctree)/scripts/config --file $(KCONFIG_CONFIG)
+
+# NO_LIBPERL
+ifdef CONFIG_LIBPERL
+ifdef NO_LIBPERL
+dummy := $(info Disabling CONFIG_LIBPERL)
+dummy := $(shell $(CONFIG) -d CONFIG_LIBPERL)
+endif
+endif
+
+# NO_LIBPYTHON
+ifdef CONFIG_LIBPYTHON
+ifdef NO_LIBPYTHON
+dummy := $(info Disabling CONFIG_LIBPYTHON)
+dummy := $(shell $(CONFIG) -d CONFIG_LIBPYTHON)
+endif
+endif
+
+# NO_NEWT
+ifdef CONFIG_TUI
+ifdef NO_NEWT
+dummy := $(info Disabling CONFIG_TUI)
+dummy := $(shell $(CONFIG) -d CONFIG_TUI)
+endif
+endif
+
+# NO_NEWT
+ifdef CONFIG_TUI
+ifdef NO_SLANG
+dummy := $(info Disabling CONFIG_TUI)
+dummy := $(shell $(CONFIG) -d CONFIG_TUI)
+endif
+endif
+
+# NO_GTK2
+ifdef CONFIG_GTK2
+ifdef NO_GTK2
+dummy := $(info Disabling CONFIG_GTK2)
+dummy := $(shell $(CONFIG) -d CONFIG_GTK2)
+endif
+endif
+
+# NO_DEMANGLE
+ifdef CONFIG_DEMANGLE
+ifdef NO_DEMANGLE
+dummy := $(info Disabling CONFIG_DEMANGLE)
+dummy := $(shell $(CONFIG) -d CONFIG_DEMANGLE)
+endif
+endif
+
+# NO_LIBELF
+ifdef CONFIG_LIBELF
+ifdef NO_LIBELF
+dummy := $(info Disabling CONFIG_LIBELF)
+dummy := $(info Enabling  CONFIG_LIBELF_MINIMAL)
+dummy := $(shell $(CONFIG) -d CONFIG_LIBELF)
+dummy := $(shell $(CONFIG) -e CONFIG_LIBELF_MINIMAL)
+endif
+endif
+
+# NO_LIBUNWIND
+ifdef CONFIG_LIBUNWIND
+ifdef NO_LIBUNWIND
+dummy := $(info Disabling CONFIG_LIBUNWIND)
+dummy := $(shell $(CONFIG) -d CONFIG_LIBUNWIND)
+endif
+endif
+
+# NO_BACKTRACE
+ifdef CONFIG_BACKTRACE
+ifdef NO_BACKTRACE
+dummy := $(info Disabling CONFIG_BACKTRACE)
+dummy := $(shell $(CONFIG) -d CONFIG_BACKTRACE)
+endif
+endif
+
+# NO_LIBNUMA
+ifdef CONFIG_NUMA
+ifdef NO_LIBNUMA
+dummy := $(info Disabling CONFIG_NUMA)
+dummy := $(shell $(CONFIG) -d CONFIG_NUMA)
+endif
+endif
+
+# NO_LIBAUDIT
+ifdef CONFIG_LIBAUDIT
+ifdef NO_LIBAUDIT
+dummy := $(info Disabling CONFIG_LIBAUDIT)
+dummy := $(shell $(CONFIG) -d CONFIG_LIBAUDIT)
+endif
+endif
+
+# NO_LIBBIONIC
+ifdef CONFIG_BIONIC
+ifdef NO_LIBBIONIC
+dummy := $(info Disabling CONFIG_BIONIC)
+dummy := $(shell $(CONFIG) -d CONFIG_BIONIC)
+endif
+endif
+
+all:
diff --git a/tools/perf/config/Makefile.fix-legacy b/tools/perf/config/Makefile.fix-legacy
new file mode 100644
index 0000000..2ec91f3
--- /dev/null
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -0,0 +1,46 @@
+
+include $(KCONFIG_CONFIG)
+
+ifndef CONFIG_LIBPERL
+NO_LIBPERL := 1
+endif
+
+ifndef CONFIG_LIBPYTHON
+NO_LIBPYTHON := 1
+endif
+
+ifndef CONFIG_TUI
+NO_SLANG := 1
+endif
+
+ifndef CONFIG_GTK2
+NO_GTK2 := 1
+endif
+
+ifndef CONFIG_DEMANGLE
+NO_DEMANGLE := 1
+endif
+
+ifndef CONFIG_LIBELF
+NO_LIBELF := 1
+endif
+
+ifndef CONFIG_LIBUNWIND
+NO_LIBUNWIND := 1
+endif
+
+ifndef CONFIG_BACKTRACE
+NO_BACKTRACE := 1
+endif
+
+ifndef CONFIG_NUMA
+export NO_LIBNUMA := 1
+endif
+
+ifndef CONFIG_LIBAUDIT
+NO_LIBAUDIT := 1
+endif
+
+ifdef CONFIG_BIONIC
+NO_LIBBIONIC := 1
+endif
diff --git a/tools/perf/config/defconfig b/tools/perf/config/defconfig
new file mode 100644
index 0000000..7a385f1
--- /dev/null
+++ b/tools/perf/config/defconfig
@@ -0,0 +1,54 @@
+#
+# Automatically generated file; DO NOT EDIT.
+# Linux Kernel Configuration
+#
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+# CONFIG_BUILTIN_TOP is not set
+# CONFIG_BUILTIN_ANNOTATE is not set
+# CONFIG_BUILTIN_BENCH is not set
+# CONFIG_BUILTIN_BUILDID_CACHE is not set
+# CONFIG_BUILTIN_BUILDID_LIST is not set
+CONFIG_BUILTIN_DIFF=y
+# CONFIG_BUILTIN_EVLIST is not set
+CONFIG_BUILTIN_HELP=y
+# CONFIG_BUILTIN_INJECT is not set
+# CONFIG_BUILTIN_KMEM is not set
+# CONFIG_BUILTIN_KVM is not set
+# CONFIG_BUILTIN_LIST is not set
+# CONFIG_BUILTIN_LOCK is not set
+# CONFIG_BUILTIN_SCHED is not set
+CONFIG_BUILTIN_SCRIPT=y
+# CONFIG_BUILTIN_TIMECHART is not set
+# CONFIG_BUILTIN_TEST is not set
+
+#
+# Libraries
+#
+# CONFIG_LIBAUDIT is not set
+# CONFIG_LIBPERL is not set
+# CONFIG_LIBPYTHON is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_BACKTRACE=y
+# CONFIG_LIBUNWIND is not set
+# CONFIG_NUMA is not set
+# CONFIG_DEMANGLE is not set
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+# CONFIG_TUI is not set
+# CONFIG_GTK2 is not set
+
+#
+# Build
+#
+CONFIG_DEBUG=y
+# CONFIG_DEBUG_PARSER is not set
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Kbuild b/tools/perf/scripts/perl/Perf-Trace-Util/Kbuild
new file mode 100644
index 0000000..fa54dd5
--- /dev/null
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Kbuild
@@ -0,0 +1,3 @@
+obj-y += Context.o
+
+CFLAGS_Context.o += $(PERL_EMBED_CCOPTS)
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/Kbuild b/tools/perf/scripts/python/Perf-Trace-Util/Kbuild
new file mode 100644
index 0000000..0f32b85
--- /dev/null
+++ b/tools/perf/scripts/python/Perf-Trace-Util/Kbuild
@@ -0,0 +1,4 @@
+obj-y += Context.o
+
+CFLAGS_Context.o := $(PYTHON_EMBED_CCOPTS)
+CFLAGS_Context.o += -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs
diff --git a/tools/perf/tests/Kbuild b/tools/perf/tests/Kbuild
new file mode 100644
index 0000000..f2998a6
--- /dev/null
+++ b/tools/perf/tests/Kbuild
@@ -0,0 +1,23 @@
+obj-y += builtin-test.o
+obj-y += attr.o
+obj-y += dso-data.o
+obj-y += evsel-roundtrip-name.o
+obj-y += evsel-tp-sched.o
+obj-y += hists_link.o
+obj-y += mmap-basic.o
+obj-y += open-syscall-all-cpus.o
+obj-y += open-syscall.o
+obj-y += open-syscall-tp-fields.o
+obj-y += parse-events.o
+obj-y += perf-record.o
+obj-y += pmu.o
+obj-y += python-use.o
+obj-y += rdpmc.o
+obj-y += vmlinux-kallsyms.o
+obj-y += bp_signal.o
+obj-y += bp_signal_overflow.o
+obj-y += sw-clock.o
+obj-y += task-exit.o
+
+CFLAGS_python-use.o += -DPYTHON='"$(PYTHON_WORD)"' -DPYTHONPATH='"python"'
+CFLAGS_attr.o += -DPYTHON='"$(PYTHON_WORD)"' -DBINDIR='"$(bindir_SQ)"'
diff --git a/tools/perf/ui/Kbuild b/tools/perf/ui/Kbuild
new file mode 100644
index 0000000..f687132
--- /dev/null
+++ b/tools/perf/ui/Kbuild
@@ -0,0 +1,14 @@
+obj-$(CONFIG_TUI) += browser.o
+obj-y += helpline.o
+obj-y += hist.o
+obj-y += progress.o
+obj-y += setup.o
+obj-y += util.o
+
+obj-y += browsers/
+obj-y += stdio/
+
+obj-$(CONFIG_TUI)  += tui/
+obj-$(CONFIG_GTK2) += gtk/
+
+CFLAGS_browser.o += -DENABLE_SLFUTURE_CONST
diff --git a/tools/perf/ui/browsers/Kbuild b/tools/perf/ui/browsers/Kbuild
new file mode 100644
index 0000000..43bfcbf
--- /dev/null
+++ b/tools/perf/ui/browsers/Kbuild
@@ -0,0 +1,6 @@
+obj-$(CONFIG_TUI) += annotate.o
+obj-$(CONFIG_TUI) += hists.o
+obj-$(CONFIG_TUI) += map.o
+obj-$(CONFIG_TUI) += scripts.o
+
+CFLAGS_hists.o += -DENABLE_SLFUTURE_CONST
diff --git a/tools/perf/ui/gtk/Kbuild b/tools/perf/ui/gtk/Kbuild
new file mode 100644
index 0000000..6964926
--- /dev/null
+++ b/tools/perf/ui/gtk/Kbuild
@@ -0,0 +1,7 @@
+obj-y += browser.o
+obj-y += hists.o
+obj-y += setup.o
+obj-y += util.o
+obj-y += helpline.o
+obj-y += progress.o
+obj-y += annotate.o
diff --git a/tools/perf/ui/stdio/Kbuild b/tools/perf/ui/stdio/Kbuild
new file mode 100644
index 0000000..9de4bd9
--- /dev/null
+++ b/tools/perf/ui/stdio/Kbuild
@@ -0,0 +1 @@
+obj-y += hist.o
diff --git a/tools/perf/ui/tui/Kbuild b/tools/perf/ui/tui/Kbuild
new file mode 100644
index 0000000..e282409
--- /dev/null
+++ b/tools/perf/ui/tui/Kbuild
@@ -0,0 +1,4 @@
+obj-y += helpline.o
+obj-y += progress.o
+obj-y += setup.o
+obj-y += util.o
diff --git a/tools/perf/util/Kbuild b/tools/perf/util/Kbuild
new file mode 100644
index 0000000..10d5376
--- /dev/null
+++ b/tools/perf/util/Kbuild
@@ -0,0 +1,113 @@
+obj-y += abspath.o
+obj-y += alias.o
+obj-y += annotate.o
+obj-y += bitmap.o
+obj-y += build-id.o
+obj-y += callchain.o
+obj-y += cgroup.o
+obj-y += color.o
+obj-y += config.o
+obj-y += cpumap.o
+obj-y += ctype.o
+obj-y += debug.o
+obj-y += dso.o
+obj-y += environment.o
+obj-y += event.o
+obj-y += evlist.o
+obj-y += evsel.o
+obj-y += exec_cmd.o
+obj-y += header.o
+obj-y += help.o
+obj-y += hist.o
+obj-y += hweight.o
+obj-y += intlist.o
+obj-y += levenshtein.o
+obj-y += machine.o
+obj-y += map.o
+obj-y += pager.o
+obj-y += parse-options.o
+obj-y += path.o
+obj-y += pmu-flex.o
+obj-y += pmu-bison.o
+obj-y += pmu.o
+obj-y += pstack.o
+obj-y += quote.o
+obj-y += rblist.o
+obj-y += run-command.o
+obj-y += session.o
+obj-y += sigchain.o
+obj-y += sort.o
+obj-y += stat.o
+obj-y += strbuf.o
+obj-y += strfilter.o
+obj-y += string.o
+obj-y += strlist.o
+obj-y += svghelper.o
+obj-y += symbol.o
+
+obj-$(CONFIG_LIBUNWIND) += unwind.o
+
+obj-$(CONFIG_LIBELF) += symbol-elf.o
+obj-$(CONFIG_LIBELF) += dwarf-aux.o
+obj-$(CONFIG_LIBELF) += probe-event.o
+obj-$(CONFIG_LIBELF) += probe-finder.o
+
+obj-$(CONFIG_LIBELF_MINIMAL) += symbol-minimal.o
+
+obj-y += sysfs.o
+obj-y += target.o
+obj-y += thread.o
+obj-y += thread_map.o
+obj-y += top.o
+obj-y += usage.o
+obj-y += util.o
+obj-y += values.o
+obj-y += xyarray.o
+obj-y += vdso.o
+obj-y += wrapper.o
+obj-y += trace-event-info.o
+obj-y += trace-event-parse.o
+obj-$(CONFIG_BUILTIN_SCRIPT) += trace-event-scripting.o
+obj-y += trace-event-read.o
+
+obj-y += scripting-engines/
+
+define bison
+$(Q)echo '  BI      $@'
+$(Q)$(BISON) -v $< -d $(PARSER_DEBUG_BISON) -o $@ -p $1
+endef
+
+define flex
+$(Q)echo '  FL      $@';
+$(Q)$(FLEX) --header-file=$(basename $@).h $(PARSER_DEBUG_FLEX) -t $< > $@
+endef
+
+obj-y += parse-events-flex.o
+obj-y += parse-events-bison.o
+obj-y += parse-events.o
+
+$(obj)/parse-events-bison.c: $(src)/parse-events.y
+	$(call bison,parse_events_)
+
+$(obj)/parse-events-flex.c: $(src)/parse-events.l $(obj)/parse-events-bison.c
+	$(call flex)
+
+$(src)/parse-events-flex.o: $(src)/parse-events-flex.c
+$(src)/parse-events-bison.o: $(src)/parse-events-bison.c
+
+$(src)/pmu-bison.c: $(src)/pmu.y
+	$(call bison,perf_pmu_)
+
+$(src)/pmu-flex.c: $(src)/pmu.l $(src)/pmu-bison.c
+	$(call flex)
+
+$(src)/pmu-flex.o: $(src)/pmu-flex.c
+$(src)/pmu-bison.o: $(src)/pmu-bison.c
+
+CFLAGS_parse-events-flex.o  += -w
+CFLAGS_parse-events-bison.o += -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w
+CFLAGS_pmu-flex.o  += -w
+CFLAGS_pmu-bison.o += -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w
+
+CFLAGS_config.o += -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"'
+CFLAGS_exec_cmd.o += -DPERF_EXEC_PATH='"$(perfexecdir_SQ)"' -DPREFIX='"$(prefix_SQ)"'
diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 055fef3..9f86bde 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -9,6 +9,10 @@ GVF=${OUTPUT}PERF-VERSION-FILE
 LF='
 '
 
+if [ "${srctree}x" = "x" ]; then
+srctree=../..
+fi
+
 #
 # First check if there is a .git to get the version from git describe
 # otherwise try to get the version from the kernel Makefile
@@ -19,7 +23,7 @@ then
 	VN=$(echo $VN"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD))
 	VN=$(echo "$VN" | sed -e 's/-/./g');
 else
-	VN=$(MAKEFLAGS= make -sC ../.. kernelversion)
+	VN=$(MAKEFLAGS= make -sC $srctree kernelversion)
 fi
 
 VN=$(expr "$VN" : v*'\(.*\)')
diff --git a/tools/perf/util/generate-cmdlist.sh b/tools/perf/util/generate-cmdlist.sh
index ef9a4f6..cadaa1a 100755
--- a/tools/perf/util/generate-cmdlist.sh
+++ b/tools/perf/util/generate-cmdlist.sh
@@ -15,7 +15,7 @@ struct cmdname_help
 
 static struct cmdname_help common_cmds[] = {"
 
-sed -n -e 's/^perf-\([^ 	]*\)[ 	].* common.*/\1/p' command-list.txt |
+sed -n -e 's/^perf-\([^ 	]*\)[ 	].* common.*/\1/p' $1/command-list.txt |
 sort |
 while read cmd
 do
@@ -26,12 +26,12 @@ do
             x
             s/.*perf-'"$cmd"' - \(.*\)/  {"'"$cmd"'", "\1"},/
 	    p
-     }' "Documentation/perf-$cmd.txt"
+     }' "$1/Documentation/perf-$cmd.txt"
      echo "#endif"
 done
 
 echo "#ifdef LIBELF_SUPPORT"
-sed -n -e 's/^perf-\([^ 	]*\)[ 	].* full.*/\1/p' command-list.txt |
+sed -n -e 's/^perf-\([^ 	]*\)[ 	].* full.*/\1/p' $1/command-list.txt |
 sort |
 while read cmd
 do
@@ -42,7 +42,7 @@ do
             x
             s/.*perf-'"$cmd"' - \(.*\)/  {"'"$cmd"'", "\1"},/
 	    p
-     }' "Documentation/perf-$cmd.txt"
+     }' "$1/Documentation/perf-$cmd.txt"
      echo "#endif"
 done
 echo "#endif /* LIBELF_SUPPORT */"
diff --git a/tools/perf/util/scripting-engines/Kbuild b/tools/perf/util/scripting-engines/Kbuild
new file mode 100644
index 0000000..b6360ee
--- /dev/null
+++ b/tools/perf/util/scripting-engines/Kbuild
@@ -0,0 +1,7 @@
+obj-$(CONFIG_LIBPERL)   += trace-event-perl.o
+obj-$(CONFIG_LIBPYTHON) += trace-event-python.o
+
+CFLAGS_trace-event-perl.o   := $(PERL_EMBED_CCOPTS)
+
+CFLAGS_trace-event-python.o := $(PYTHON_EMBED_CCOPTS)
+CFLAGS_trace-event-python.o += -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 93c576b..2d8dcc4 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -2,6 +2,7 @@
 
 from distutils.core import setup, Extension
 from os import getenv
+from os import environ
 
 from distutils.command.build_ext   import build_ext   as _build_ext
 from distutils.command.install_lib import install_lib as _install_lib
@@ -18,16 +19,19 @@ class install_lib(_install_lib):
         self.build_dir = build_lib
 
 
+cflags = getenv('CFLAGS', '').split()
 cflags = ['-fno-strict-aliasing', '-Wno-write-strings', '-Wno-unused-parameter' ]
-cflags += getenv('CFLAGS', '').split()
 
 build_lib = getenv('PYTHON_EXTBUILD_LIB')
 build_tmp = getenv('PYTHON_EXTBUILD_TMP')
 libtraceevent = getenv('LIBTRACEEVENT')
 liblk = getenv('LIBLK')
 
-ext_sources = [f.strip() for f in file('util/python-ext-sources')
-				if len(f.strip()) > 0 and f[0] != '#']
+if environ.has_key('PYTHON_EXT_SRCS'):
+    ext_sources = getenv('PYTHON_EXT_SRCS').split()
+else:
+    ext_sources = [f.strip() for f in file('util/python-ext-sources')
+                                   if len(f.strip()) > 0 and f[0] != '#']
 
 perf = Extension('perf',
 		  sources = ext_sources,
-- 
1.7.11.7

