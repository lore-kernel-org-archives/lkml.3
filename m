Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbbATQk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:40:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882AbbATQky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:40:54 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/36] perf build: Add tests objects building
Date: Tue, 20 Jan 2015 17:39:04 +0100
Message-Id: <1421771973-6022-8-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move test objects building under build framework.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Build           |  1 +
 tools/perf/Makefile.perf   | 55 ----------------------------------------------
 tools/perf/config/Makefile | 10 +++++++++
 tools/perf/tests/Build     | 42 +++++++++++++++++++++++++++++++++++
 4 files changed, 53 insertions(+), 55 deletions(-)
 create mode 100644 tools/perf/tests/Build

diff --git a/tools/perf/Build b/tools/perf/Build
index 9ea828de3fde..b4b6a7ca760b 100644
--- a/tools/perf/Build
+++ b/tools/perf/Build
@@ -1,2 +1,3 @@
 perf-y += builtin-bench.o
 perf-y += bench/
+perf-y += tests/
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 710730308618..43620bd640ae 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -425,45 +425,6 @@ LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
 
 LIB_OBJS += $(OUTPUT)arch/common.o
 
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
-LIB_OBJS += $(OUTPUT)tests/fdarray.o
-LIB_OBJS += $(OUTPUT)tests/pmu.o
-LIB_OBJS += $(OUTPUT)tests/hists_common.o
-LIB_OBJS += $(OUTPUT)tests/hists_link.o
-LIB_OBJS += $(OUTPUT)tests/hists_filter.o
-LIB_OBJS += $(OUTPUT)tests/hists_output.o
-LIB_OBJS += $(OUTPUT)tests/hists_cumulate.o
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
-ifndef NO_DWARF_UNWIND
-ifeq ($(ARCH),$(filter $(ARCH),x86 arm))
-LIB_OBJS += $(OUTPUT)tests/dwarf-unwind.o
-endif
-endif
-LIB_OBJS += $(OUTPUT)tests/mmap-thread-lookup.o
-LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
-LIB_OBJS += $(OUTPUT)tests/switch-tracking.o
-
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
 BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
@@ -483,7 +444,6 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
 BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
-BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
 
 PERFLIBS = $(LIB_FILE) $(LIBAPIKFS) $(LIBTRACEEVENT)
@@ -525,7 +485,6 @@ endif
 ifndef NO_LIBUNWIND
   LIB_OBJS += $(OUTPUT)util/unwind-libunwind.o
 endif
-LIB_OBJS += $(OUTPUT)tests/keep-tracking.o
 
 ifndef NO_LIBAUDIT
   BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
@@ -700,20 +659,6 @@ $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 		'-DPREFIX="$(prefix_SQ)"' \
 		$<
 
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
-$(OUTPUT)tests/dwarf-unwind.o: tests/dwarf-unwind.c
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -fno-optimize-sibling-calls $<
-
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 1938432969ab..10a0ad839390 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -20,10 +20,13 @@ CFLAGS := $(EXTRA_CFLAGS) $(EXTRA_WARNINGS)
 
 include $(src-perf)/config/Makefile.arch
 
+$(call detected_var,ARCH)
+
 NO_PERF_REGS := 1
 
 # Additional ARCH settings for x86
 ifeq ($(ARCH),x86)
+  $(call detected,CONFIG_X86)
   ifeq (${IS_64_BIT}, 1)
     CFLAGS += -DHAVE_ARCH_X86_64_SUPPORT
     ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
@@ -418,6 +421,7 @@ endif
 
 ifeq ($(dwarf-post-unwind),1)
   CFLAGS += -DHAVE_DWARF_UNWIND_SUPPORT
+  $(call detected,CONFIG_DWARF_UNWIND)
 else
   NO_DWARF_UNWIND := 1
 endif
@@ -815,3 +819,9 @@ endif
 ifeq ($(display_lib),1)
   $(info )
 endif
+
+$(call detected_var,bindir_SQ)
+$(call detected_var,PYTHON_WORD)
+ifneq ($(OUTPUT),)
+$(call detected_var,OUTPUT)
+endif
diff --git a/tools/perf/tests/Build b/tools/perf/tests/Build
new file mode 100644
index 000000000000..2de01a4b4084
--- /dev/null
+++ b/tools/perf/tests/Build
@@ -0,0 +1,42 @@
+perf-y += builtin-test.o
+perf-y += parse-events.o
+perf-y += dso-data.o
+perf-y += attr.o
+perf-y += vmlinux-kallsyms.o
+perf-y += open-syscall.o
+perf-y += open-syscall-all-cpus.o
+perf-y += open-syscall-tp-fields.o
+perf-y += mmap-basic.o
+perf-y += perf-record.o
+perf-y += rdpmc.o
+perf-y += evsel-roundtrip-name.o
+perf-y += evsel-tp-sched.o
+perf-y += fdarray.o
+perf-y += pmu.o
+perf-y += hists_common.o
+perf-y += hists_link.o
+perf-y += hists_filter.o
+perf-y += hists_output.o
+perf-y += hists_cumulate.o
+perf-y += python-use.o
+perf-y += bp_signal.o
+perf-y += bp_signal_overflow.o
+perf-y += task-exit.o
+perf-y += sw-clock.o
+perf-y += mmap-thread-lookup.o
+perf-y += thread-mg-share.o
+perf-y += switch-tracking.o
+perf-y += keep-tracking.o
+perf-y += code-reading.o
+perf-y += sample-parsing.o
+perf-y += parse-no-sample-id-all.o
+
+perf-$(CONFIG_X86) += perf-time-to-tsc.o
+
+ifeq ($(ARCH),$(filter $(ARCH),x86 arm))
+perf-$(CONFIG_DWARF_UNWIND) += dwarf-unwind.o
+endif
+
+CFLAGS_attr.o         += -DBINDIR="BUILD_STR($(bindir_SQ))" -DPYTHON="BUILD_STR($(PYTHON_WORD))"
+CFLAGS_python-use.o   += -DPYTHONPATH="BUILD_STR($(OUTPUT)python)" -DPYTHON="BUILD_STR($(PYTHON_WORD))"
+CFLAGS_dwarf-unwind.o += -fno-optimize-sibling-calls
-- 
1.9.3

