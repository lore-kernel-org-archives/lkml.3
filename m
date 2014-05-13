Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbaEMWH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:07:58 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41081 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbaEMWFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:45 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 24/34] perf kbuild: remove legacy libdwarf-related build variables
Date: Wed, 14 May 2014 00:03:19 +0200
Message-Id: <1400018609-20486-25-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_DWARF (replaced by CONFIG_LIBDWARF)
Remove HAVE_DWARF_SUPPORT (replaced by CONFIG_LIBDWARF)
---
 tools/perf/Kconfig                   | 13 ++++++
 tools/perf/arch/arm/Makefile         |  2 +-
 tools/perf/arch/powerpc/Makefile     |  2 +-
 tools/perf/arch/s390/Makefile        |  2 +-
 tools/perf/arch/sh/Makefile          |  2 +-
 tools/perf/arch/sparc/Makefile       |  2 +-
 tools/perf/arch/x86/Kbuild           |  1 +
 tools/perf/arch/x86/Makefile         |  6 +--
 tools/perf/arch/x86/tests/Kbuild     |  2 +
 tools/perf/arch/x86/util/Kbuild      |  3 +-
 tools/perf/builtin-probe.c           | 15 +++----
 tools/perf/builtin-record.c          | 10 ++---
 tools/perf/config/Makefile           | 76 +++++++++++++++++-------------------
 tools/perf/tests/builtin-test.c      |  3 +-
 tools/perf/tests/tests.h             |  4 +-
 tools/perf/util/Kbuild               |  3 +-
 tools/perf/util/include/dwarf-regs.h |  4 +-
 tools/perf/util/probe-event.c        |  6 +--
 tools/perf/util/probe-finder.h       |  5 ++-
 tools/perf/util/unwind.h             |  5 ++-
 20 files changed, 93 insertions(+), 73 deletions(-)
 create mode 100644 tools/perf/arch/x86/tests/Kbuild

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index e228e26..8da8409 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -255,6 +255,19 @@ config LIBDWARF
         ---help---
 	  libdwarf
 
+config LIBDWARF_UNWIND
+        depends on LIBDWARF
+	default y
+	bool "Dwarf unwind"
+        ---help---
+	  libdwarf unwind
+
+config LIBDWARF_DIR
+	string "libdwarf directory"
+	depends on LIBDWARF
+        ---help---
+	  libdwarf directory
+
 config LIBUNWIND
         depends on LIBELF
 	bool "User space libunwind callchains"
diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm/Makefile
index 67e9b3d..5f33855 100644
--- a/tools/perf/arch/arm/Makefile
+++ b/tools/perf/arch/arm/Makefile
@@ -1,4 +1,4 @@
-ifndef NO_DWARF
+ifeq ($(LIBDWARF), 1)
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
index 744e629..3c57a2e 100644
--- a/tools/perf/arch/powerpc/Makefile
+++ b/tools/perf/arch/powerpc/Makefile
@@ -1,4 +1,4 @@
-ifndef NO_DWARF
+ifeq ($(LIBDWARF), 1)
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/s390/Makefile b/tools/perf/arch/s390/Makefile
index 15130b5..74e617d 100644
--- a/tools/perf/arch/s390/Makefile
+++ b/tools/perf/arch/s390/Makefile
@@ -1,4 +1,4 @@
-ifndef NO_DWARF
+ifeq ($(LIBDWARF), 1)
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/sh/Makefile b/tools/perf/arch/sh/Makefile
index 15130b5..74e617d 100644
--- a/tools/perf/arch/sh/Makefile
+++ b/tools/perf/arch/sh/Makefile
@@ -1,4 +1,4 @@
-ifndef NO_DWARF
+ifeq ($(LIBDWARF), 1)
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/sparc/Makefile b/tools/perf/arch/sparc/Makefile
index 15130b5..74e617d 100644
--- a/tools/perf/arch/sparc/Makefile
+++ b/tools/perf/arch/sparc/Makefile
@@ -1,4 +1,4 @@
-ifndef NO_DWARF
+ifeq ($(LIBDWARF), 1)
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/x86/Kbuild b/tools/perf/arch/x86/Kbuild
index 52fd6fa..3b9a068 100644
--- a/tools/perf/arch/x86/Kbuild
+++ b/tools/perf/arch/x86/Kbuild
@@ -1 +1,2 @@
 obj-y += util/
+obj-y += tests/
\ No newline at end of file
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 1641542..238f75b 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -1,14 +1,12 @@
-ifndef NO_DWARF
+ifeq ($(LIBDWARF), 1)
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 ifndef NO_LIBUNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
 endif
-ifndef NO_LIBDW_DWARF_UNWIND
+ifeq ($(LIBDWARF_UNWIND), 1)
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libdw.o
-endif
-ifndef NO_DWARF_UNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/dwarf-unwind.o
 endif
diff --git a/tools/perf/arch/x86/tests/Kbuild b/tools/perf/arch/x86/tests/Kbuild
new file mode 100644
index 0000000..31269b4
--- /dev/null
+++ b/tools/perf/arch/x86/tests/Kbuild
@@ -0,0 +1,2 @@
+obj-$(CONFIG_LIBDWARF_UNWIND) += regs_load.o
+obj-$(CONFIG_LIBDWARF_UNWIND) += dwarf-unwind.o
diff --git a/tools/perf/arch/x86/util/Kbuild b/tools/perf/arch/x86/util/Kbuild
index e033b94..0eed9c0 100644
--- a/tools/perf/arch/x86/util/Kbuild
+++ b/tools/perf/arch/x86/util/Kbuild
@@ -1,4 +1,5 @@
 obj-y += dwarf-regs.o
 obj-y += header.o
 obj-y += tsc.o
-obj-$(CONFIG_LIBUNWIND) += unwind.o
+obj-$(CONFIG_LIBUNWIND) += unwind-libunwind.o
+obj-$(CONFIG_LIBDWARF_UNWIND) += unwind-libdw.o
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index cdcd4eb..71b8ecc 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -30,6 +30,7 @@
 #include <stdlib.h>
 #include <string.h>
 
+#include "generated/autoconf.h"
 #include "perf.h"
 #include "builtin.h"
 #include "util/util.h"
@@ -180,7 +181,7 @@ static int opt_set_target(const struct option *opt, const char *str,
 	if  (str && !params.target) {
 		if (!strcmp(opt->long_name, "exec"))
 			params.uprobes = true;
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 		else if (!strcmp(opt->long_name, "module"))
 			params.uprobes = false;
 #endif
@@ -206,7 +207,7 @@ static int opt_set_target(const struct option *opt, const char *str,
 	return ret;
 }
 
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 static int opt_show_lines(const struct option *opt __maybe_unused,
 			  const char *str, int unset __maybe_unused)
 {
@@ -296,7 +297,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
 		"perf probe [<options>] --del '[GROUP:]EVENT' ...",
 		"perf probe --list",
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 		"perf probe [<options>] --line 'LINEDESC'",
 		"perf probe [<options>] --vars 'PROBEPOINT'",
 #endif
@@ -310,7 +311,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
 		opt_del_probe_event),
 	OPT_CALLBACK('a', "add", NULL,
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 		"[EVENT=]FUNC[@SRC][+OFF|%return|:RL|;PT]|SRC:AL|SRC;PT"
 		" [[NAME=]ARG ...]",
 #else
@@ -322,7 +323,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		"\t\tFUNC:\tFunction name\n"
 		"\t\tOFF:\tOffset from function entry (in byte)\n"
 		"\t\t%return:\tPut the probe at function return\n"
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 		"\t\tSRC:\tSource code path\n"
 		"\t\tRL:\tRelative line number from function entry.\n"
 		"\t\tAL:\tAbsolute line number in file.\n"
@@ -335,7 +336,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		opt_add_probe_event),
 	OPT_BOOLEAN('f', "force", &params.force_add, "forcibly add events"
 		    " with existing name"),
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 	OPT_CALLBACK('L', "line", NULL,
 		     "FUNC[:RLN[+NUM|-RLN2]]|SRC:ALN[+NUM|-ALN2]",
 		     "Show source code lines.", opt_show_lines),
@@ -450,7 +451,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		return ret;
 	}
 
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 	if (params.show_lines) {
 		if (params.mod_events) {
 			pr_err("  Error: Don't use --line with"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 372a812..1a832da 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -651,7 +651,7 @@ error:
 	return ret;
 }
 
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_LIBDWARF_UNWIND
 static int get_stack_size(char *str, unsigned long *_size)
 {
 	char *endptr;
@@ -677,7 +677,7 @@ static int get_stack_size(char *str, unsigned long *_size)
 	       max_size, str);
 	return -1;
 }
-#endif /* HAVE_DWARF_UNWIND_SUPPORT */
+#endif /* CONFIG_LIBDWARF_UNWIND */
 
 int record_parse_callchain(const char *arg, struct record_opts *opts)
 {
@@ -706,7 +706,7 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 				       "needed for -g fp\n");
 			break;
 
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_LIBDWARF_UNWIND
 		/* Dwarf style */
 		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
 			const unsigned long default_stack_dump_size = 8192;
@@ -722,7 +722,7 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 				ret = get_stack_size(tok, &size);
 				opts->stack_dump_size = size;
 			}
-#endif /* HAVE_DWARF_UNWIND_SUPPORT */
+#endif /* CONFIG_LIBDWARF_UNWIND */
 		} else {
 			pr_err("callchain: Unknown --call-graph option "
 			       "value: %s\n", arg);
@@ -825,7 +825,7 @@ static struct record record = {
 
 #define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
 
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_LIBDWARF_UNWIND
 const char record_callchain_help[] = CALLCHAIN_HELP "fp dwarf";
 #else
 const char record_callchain_help[] = CALLCHAIN_HELP "fp";
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c102e91..fa5f4f8 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -35,14 +35,6 @@ ifeq ($(ARCH),arm)
   LIBUNWIND_LIBS = -lunwind -lunwind-arm
 endif
 
-# So far there's only x86 libdw unwind support merged in perf.
-# Disable it on all other architectures in case libdw unwind
-# support is detected in system. Add supported architectures
-# to the check.
-ifneq ($(ARCH),x86)
-  NO_LIBDW_DWARF_UNWIND := 1
-endif
-
 ifeq ($(LIBUNWIND_LIBS),)
   NO_LIBUNWIND := 1
 else
@@ -68,12 +60,10 @@ ifeq ($(NO_PERF_REGS),0)
   CFLAGS += -DHAVE_PERF_REGS_SUPPORT
 endif
 
-ifndef NO_LIBELF
-  # for linking with debug library, run like:
-  # make DEBUG=1 LIBDW_DIR=/opt/libdw/
-  ifdef LIBDW_DIR
-    LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
-    LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
+ifdef CONFIG_LIBELF
+  ifdef CONFIG_LIBDWARF_DIR
+    LIBDW_CFLAGS  := -I$(CONFIG_LIBDWARF_DIR)/include
+    LIBDW_LDFLAGS := -L$(CONFIG_LIBDWARF_DIR)/lib
   endif
   FEATURE_CHECK_CFLAGS-libdw-dwarf-unwind := $(LIBDW_CFLAGS)
   FEATURE_CHECK_LDFLAGS-libdw-dwarf-unwind := $(LIBDW_LDFLAGS) -ldw
@@ -298,16 +288,30 @@ ifdef CONFIG_LIBELF
     endif
   else
     LIBELF = 1
-    ifndef NO_LIBDW_DWARF_UNWIND
-      ifneq ($(feature-libdw-dwarf-unwind),1)
-        NO_LIBDW_DWARF_UNWIND := 1
-        msg := $(warning No libdw DWARF unwind found, Please install elfutils-devel/libdw-dev >= 0.158 and/or set LIBDW_DIR);
-      endif
-    endif
-    ifneq ($(feature-dwarf), 1)
-      msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
-      NO_DWARF := 1
-    endif # Dwarf support
+    ifdef CONFIG_LIBDWARF
+      ifneq ($(feature-dwarf), 1)
+        msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
+        $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF)
+      else
+        LIBDWARF = 1
+      endif # Dwarf support
+      ifdef CONFIG_LIBDWARF_UNWIND
+        # So far there's only x86 libdw unwind support merged in
+        # perf. Disable it on all other architectures in case libdw
+        # unwind support is detected in system. Add supported
+        # architectures to the check.
+        ifeq ($(ARCH),x86)
+          ifneq ($(feature-libdw-dwarf-unwind),1)
+            msg := $(warning No libdw DWARF unwind found, Please install elfutils-devel/libdw-dev >= 0.158 and/or set LIBDW_DIR);
+            $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF_UNWIND)
+          else
+            LIBDWARF_UNWIND = 1
+          endif # Dwarf unwind support
+        else
+          $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF_UNWIND)
+        endif # Arch x86
+      endif # CONFIG_LIBDWARF_UNWIND 
+    endif  # CONFIG_LIBDWARF
   endif # libelf support
 endif # CONFIG_LIBELF
 
@@ -328,16 +332,16 @@ ifeq ($(LIBELF), 1)
   # include ARCH specific config
   -include $(src-perf)/arch/$(ARCH)/Makefile
 
-  ifndef NO_DWARF
+  ifeq ($(LIBDWARF), 1)
     ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
       msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
-      NO_DWARF := 1
+      $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF)
     else
-      CFLAGS += -DHAVE_DWARF_SUPPORT $(LIBDW_CFLAGS)
+      CFLAGS += $(LIBDW_CFLAGS)
       LDFLAGS += $(LIBDW_LDFLAGS)
       EXTLIBS += -lelf -ldw
     endif # PERF_HAVE_DWARF_REGS
-  endif # NO_DWARF
+  endif # LIBDWARF
 endif # LIBELF
 
 ifndef NO_LIBUNWIND
@@ -352,24 +356,16 @@ dwarf-post-unwind-text := BUG
 
 # setup DWARF post unwinder
 ifdef NO_LIBUNWIND
-  ifdef NO_LIBDW_DWARF_UNWIND
+  ifeq ($(LIBDWARF_UNWIND), 1)
+    dwarf-post-unwind-text := libdw
+  else
     msg := $(warning Disabling post unwind, no support found.);
     dwarf-post-unwind := 0
-  else
-    dwarf-post-unwind-text := libdw
   endif
 else
   dwarf-post-unwind-text := libunwind
   # Enable libunwind support by default.
-  ifndef NO_LIBDW_DWARF_UNWIND
-    NO_LIBDW_DWARF_UNWIND := 1
-  endif
-endif
-
-ifeq ($(dwarf-post-unwind),1)
-  CFLAGS += -DHAVE_DWARF_UNWIND_SUPPORT
-else
-  NO_DWARF_UNWIND := 1
+  $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF_UNWIND)
 endif
 
 ifndef NO_LIBUNWIND
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index b11bf8a..5cc30d2 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -3,6 +3,7 @@
  *
  * Builtin regression testing command: ever growing number of sanity tests
  */
+#include "generated/autoconf.h"
 #include "builtin.h"
 #include "intlist.h"
 #include "tests.h"
@@ -116,7 +117,7 @@ static struct test {
 		.func = test__parse_no_sample_id_all,
 	},
 #if defined(__x86_64__) || defined(__i386__)
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_LIBDWARF_UNWIND
 	{
 		.desc = "Test dwarf unwind",
 		.func = test__dwarf_unwind,
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index a24795c..b939917 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -1,6 +1,8 @@
 #ifndef TESTS_H
 #define TESTS_H
 
+#include "generated/autoconf.h"
+
 #define TEST_ASSERT_VAL(text, cond)					 \
 do {									 \
 	if (!(cond)) {							 \
@@ -43,7 +45,7 @@ int test__parse_no_sample_id_all(void);
 int test__dwarf_unwind(void);
 
 #if defined(__x86_64__) || defined(__i386__)
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_LIBDWARF_UNWIND
 struct thread;
 struct perf_sample;
 int test__arch_unwind_sample(struct perf_sample *sample,
diff --git a/tools/perf/util/Kbuild b/tools/perf/util/Kbuild
index 4d0b6da..8fac37e 100644
--- a/tools/perf/util/Kbuild
+++ b/tools/perf/util/Kbuild
@@ -49,7 +49,8 @@ obj-y += strlist.o
 obj-y += svghelper.o
 obj-y += symbol.o
 
-obj-$(CONFIG_LIBUNWIND) += unwind.o
+obj-$(CONFIG_LIBUNWIND) += unwind-libunwind.o
+obj-$(CONFIG_LIBDWARF_UNWIND) += unwind-libdw.o
 
 obj-$(CONFIG_LIBELF) += symbol-elf.o
 obj-$(CONFIG_LIBELF) += dwarf-aux.o
diff --git a/tools/perf/util/include/dwarf-regs.h b/tools/perf/util/include/dwarf-regs.h
index 8f14965..93cd69c 100644
--- a/tools/perf/util/include/dwarf-regs.h
+++ b/tools/perf/util/include/dwarf-regs.h
@@ -1,7 +1,9 @@
 #ifndef _PERF_DWARF_REGS_H_
 #define _PERF_DWARF_REGS_H_
 
-#ifdef HAVE_DWARF_SUPPORT
+#include "generated/autoconf.h"
+
+#ifdef CONFIG_LIBDWARF
 const char *get_arch_regstr(unsigned int n);
 #endif
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 0d1542f..765307b 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -32,6 +32,7 @@
 #include <limits.h>
 #include <elf.h>
 
+#include "generated/autoconf.h"
 #include "util.h"
 #include "event.h"
 #include "strlist.h"
@@ -255,8 +256,7 @@ static void clear_probe_trace_events(struct probe_trace_event *tevs, int ntevs)
 		clear_probe_trace_event(tevs + i);
 }
 
-#ifdef HAVE_DWARF_SUPPORT
-
+#ifdef CONFIG_LIBDWARF
 /* Open new debuginfo of given module */
 static struct debuginfo *open_debuginfo(const char *module)
 {
@@ -786,7 +786,7 @@ out:
 	return ret;
 }
 
-#else	/* !HAVE_DWARF_SUPPORT */
+#else	/* !CONFIG_LIBDWARF */
 
 static int
 find_perf_probe_point_from_dwarf(struct probe_trace_point *tp __maybe_unused,
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 92590b2..13cb054 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -2,6 +2,7 @@
 #define _PROBE_FINDER_H
 
 #include <stdbool.h>
+#include "generated/autoconf.h"
 #include "util.h"
 #include "intlist.h"
 #include "probe-event.h"
@@ -16,7 +17,7 @@ static inline int is_c_varname(const char *name)
 	return isalpha(name[0]) || name[0] == '_';
 }
 
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 
 #include "dwarf-aux.h"
 
@@ -107,6 +108,6 @@ struct line_finder {
 	int			found;
 };
 
-#endif /* HAVE_DWARF_SUPPORT */
+#endif /* CONFIG_LIBDWARF */
 
 #endif /*_PROBE_FINDER_H */
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index b031316..681ad27 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -1,6 +1,7 @@
 #ifndef __UNWIND_H
 #define __UNWIND_H
 
+#include "generated/autoconf.h"
 #include "types.h"
 #include "event.h"
 #include "symbol.h"
@@ -13,7 +14,7 @@ struct unwind_entry {
 
 typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry, void *arg);
 
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_LIBDWARF_UNWIND
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine,
 			struct thread *thread,
@@ -33,5 +34,5 @@ unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 {
 	return 0;
 }
-#endif /* HAVE_DWARF_UNWIND_SUPPORT */
+#endif /* CONFIG_LIBDWARF_UNWIND */
 #endif /* __UNWIND_H */
-- 
1.9.2

