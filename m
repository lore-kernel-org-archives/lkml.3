Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965462AbaFCWKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:10:41 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56718 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965208AbaFCWJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:09:18 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 29/32] perf kbuild: update build test configurations
Date: Wed,  4 Jun 2014 00:06:22 +0200
Message-Id: <1401833185-10347-30-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/perf/Makefile.kbuild                         |  2 +-
 tools/perf/tests/configs/MINIMAL_config            |  4 +++
 tools/perf/tests/configs/NO_BACKTRACE_config       |  2 ++
 .../perf/tests/configs/NO_BUILTIN_ANNOTATE_config  |  2 ++
 tools/perf/tests/configs/NO_BUILTIN_BENCH_config   |  2 ++
 .../tests/configs/NO_BUILTIN_BUILDID_CACHE_config  |  2 ++
 .../tests/configs/NO_BUILTIN_BUILDID_LIST_config   |  3 +-
 tools/perf/tests/configs/NO_BUILTIN_DIFF_config    |  3 +-
 tools/perf/tests/configs/NO_BUILTIN_EVLIST_config  |  2 ++
 tools/perf/tests/configs/NO_BUILTIN_HELP_config    |  2 ++
 tools/perf/tests/configs/NO_BUILTIN_INJECT_config  |  2 ++
 tools/perf/tests/configs/NO_BUILTIN_KMEM_config    |  2 ++
 tools/perf/tests/configs/NO_BUILTIN_KVM_config     |  2 ++
 tools/perf/tests/configs/NO_BUILTIN_LIST_config    |  2 ++
 tools/perf/tests/configs/NO_BUILTIN_LOCK_config    |  2 ++
 tools/perf/tests/configs/NO_BUILTIN_MEM_config     |  2 ++
 tools/perf/tests/configs/NO_BUILTIN_PROBE_config   |  2 ++
 tools/perf/tests/configs/NO_BUILTIN_RECORD_config  | 11 ++------
 tools/perf/tests/configs/NO_BUILTIN_REPORT_config  |  6 ++--
 tools/perf/tests/configs/NO_BUILTIN_SCHED_config   |  2 ++
 tools/perf/tests/configs/NO_BUILTIN_SCRIPT_config  |  2 ++
 tools/perf/tests/configs/NO_BUILTIN_STAT_config    |  3 +-
 tools/perf/tests/configs/NO_BUILTIN_TEST_config    |  2 ++
 .../perf/tests/configs/NO_BUILTIN_TIMECHART_config |  2 ++
 tools/perf/tests/configs/NO_BUILTIN_TOP_config     |  3 +-
 tools/perf/tests/configs/NO_BUILTIN_TRACE_config   |  2 ++
 tools/perf/tests/configs/NO_DEMANGLE_config        |  2 ++
 tools/perf/tests/configs/NO_GTK2_config            |  2 ++
 tools/perf/tests/configs/NO_LIBAUDIT_config        |  2 ++
 tools/perf/tests/configs/NO_LIBDWARF_config        |  1 +
 tools/perf/tests/configs/NO_LIBELF_MMAP_config     |  2 ++
 tools/perf/tests/configs/NO_LIBGTK2_INFOBAR_config |  2 ++
 tools/perf/tests/configs/NO_LIBGTK2_config         |  3 +-
 tools/perf/tests/configs/NO_LIBNUMA_config         |  2 ++
 tools/perf/tests/configs/NO_LIBPERL_config         |  2 ++
 tools/perf/tests/configs/NO_LIBPYTHON_config       |  2 ++
 tools/perf/tests/configs/NO_LIBSLANG_config        |  2 ++
 .../tests/configs/NO_LIBUNWIND_DEBUG_FRAME_config  |  2 ++
 tools/perf/tests/configs/NO_STDIO_config           |  2 ++
 tools/perf/tests/configs/NO_TIMERFD_config         |  2 ++
 tools/perf/tests/configs/NO_TUI_config             |  2 ++
 .../{NO_LIBUNWIND_config => NO_UNWIND_config}      |  2 +-
 tools/perf/tests/configs/REF_config                |  2 ++
 tools/perf/tests/configs/generate.py               | 33 ++++++++++++++++++++++
 tools/perf/tests/make                              |  7 +++--
 45 files changed, 123 insertions(+), 22 deletions(-)
 rename tools/perf/tests/configs/{NO_LIBUNWIND_config => NO_UNWIND_config} (97%)
 create mode 100644 tools/perf/tests/configs/generate.py

diff --git a/tools/perf/Makefile.kbuild b/tools/perf/Makefile.kbuild
index 7b7641c..5372cc9 100644
--- a/tools/perf/Makefile.kbuild
+++ b/tools/perf/Makefile.kbuild
@@ -259,7 +259,7 @@ $(obj-perf)/common-cmds.h: $(src-perf)/util/generate-cmdlist.sh $(src-perf)/comm
 PHONY += all scripts_basic
 
 $(obj-perf)/built-in.o: $(obj-perf)/common-cmds.h FORCE
-	$(Q)$(MAKE) $(build)=tools/perf
+	$(Q)$(MAKE) LDFLAGS="" $(build)=tools/perf
 
 LIBS = -Wl,--whole-archive $^ -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
 
diff --git a/tools/perf/tests/configs/MINIMAL_config b/tools/perf/tests/configs/MINIMAL_config
index 722282a..6e04dc6 100644
--- a/tools/perf/tests/configs/MINIMAL_config
+++ b/tools/perf/tests/configs/MINIMAL_config
@@ -43,8 +43,12 @@ CONFIG_STDIO=y
 # CONFIG_LIBPYTHON is not set
 # CONFIG_TIMERFD is not set
 CONFIG_ON_EXIT=y
+# CONFIG_LIBBFD is not set
+# CONFIG_LIBIBERTY_ONLY is not set
 # CONFIG_LIBELF is not set
 CONFIG_LIBELF_MINIMAL=y
+# CONFIG_LIBUNWIND is not set
+# CONFIG_LIBDWARF_UNWIND is not set
 # CONFIG_LIBNUMA is not set
 # CONFIG_BIONIC is not set
 
diff --git a/tools/perf/tests/configs/NO_BACKTRACE_config b/tools/perf/tests/configs/NO_BACKTRACE_config
index f44b4f9..ea186e2 100644
--- a/tools/perf/tests/configs/NO_BACKTRACE_config
+++ b/tools/perf/tests/configs/NO_BACKTRACE_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_ANNOTATE_config b/tools/perf/tests/configs/NO_BUILTIN_ANNOTATE_config
index 5fdce32..5f87818 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_ANNOTATE_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_ANNOTATE_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_BENCH_config b/tools/perf/tests/configs/NO_BUILTIN_BENCH_config
index 99d601e..1597197 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_BENCH_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_BENCH_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_BUILDID_CACHE_config b/tools/perf/tests/configs/NO_BUILTIN_BUILDID_CACHE_config
index edcee97..6d3c29f 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_BUILDID_CACHE_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_BUILDID_CACHE_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_BUILDID_LIST_config b/tools/perf/tests/configs/NO_BUILTIN_BUILDID_LIST_config
index 3043178..a4d048a 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_BUILDID_LIST_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_BUILDID_LIST_config
@@ -16,7 +16,6 @@ CONFIG_BUILTIN_EVLIST=y
 CONFIG_BUILTIN_HELP=y
 CONFIG_BUILTIN_INJECT=y
 CONFIG_BUILTIN_KMEM=y
-CONFIG_BUILTIN_KVM=y
 CONFIG_BUILTIN_LIST=y
 CONFIG_BUILTIN_LOCK=y
 CONFIG_BUILTIN_PROBE=y
@@ -53,7 +52,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_DIFF_config b/tools/perf/tests/configs/NO_BUILTIN_DIFF_config
index f553f96..c780d43 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_DIFF_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_DIFF_config
@@ -16,7 +16,6 @@ CONFIG_BUILTIN_EVLIST=y
 CONFIG_BUILTIN_HELP=y
 CONFIG_BUILTIN_INJECT=y
 CONFIG_BUILTIN_KMEM=y
-CONFIG_BUILTIN_KVM=y
 CONFIG_BUILTIN_LIST=y
 CONFIG_BUILTIN_LOCK=y
 CONFIG_BUILTIN_PROBE=y
@@ -53,7 +52,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_EVLIST_config b/tools/perf/tests/configs/NO_BUILTIN_EVLIST_config
index 8198a9d..95f11fb 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_EVLIST_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_EVLIST_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_HELP_config b/tools/perf/tests/configs/NO_BUILTIN_HELP_config
index d897913..76753a9 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_HELP_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_HELP_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_INJECT_config b/tools/perf/tests/configs/NO_BUILTIN_INJECT_config
index 3322780..2052081 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_INJECT_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_INJECT_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_KMEM_config b/tools/perf/tests/configs/NO_BUILTIN_KMEM_config
index 0cb7cba..bda50b7 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_KMEM_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_KMEM_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_KVM_config b/tools/perf/tests/configs/NO_BUILTIN_KVM_config
index d7849bc..4dee035 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_KVM_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_KVM_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_LIST_config b/tools/perf/tests/configs/NO_BUILTIN_LIST_config
index 3eed298d..e58f913 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_LIST_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_LIST_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_LOCK_config b/tools/perf/tests/configs/NO_BUILTIN_LOCK_config
index 6347efd..f8f362d 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_LOCK_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_LOCK_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_MEM_config b/tools/perf/tests/configs/NO_BUILTIN_MEM_config
index d432c6a..d1288e94 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_MEM_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_MEM_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_PROBE_config b/tools/perf/tests/configs/NO_BUILTIN_PROBE_config
index 6dd2f14..7d51c98 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_PROBE_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_PROBE_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_RECORD_config b/tools/perf/tests/configs/NO_BUILTIN_RECORD_config
index e5bca7c..8e15038 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_RECORD_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_RECORD_config
@@ -5,8 +5,6 @@
 # CONFIG_BUILTIN_RECORD is not set
 CONFIG_BUILTIN_REPORT=y
 CONFIG_BUILTIN_STAT=y
-CONFIG_BUILTIN_TOP=y
-CONFIG_BUILTIN_TRACE=y
 CONFIG_BUILTIN_ANNOTATE=y
 CONFIG_BUILTIN_BENCH=y
 CONFIG_BUILTIN_BUILDID_CACHE=y
@@ -15,15 +13,8 @@ CONFIG_BUILTIN_DIFF=y
 CONFIG_BUILTIN_EVLIST=y
 CONFIG_BUILTIN_HELP=y
 CONFIG_BUILTIN_INJECT=y
-CONFIG_BUILTIN_KMEM=y
-CONFIG_BUILTIN_KVM=y
 CONFIG_BUILTIN_LIST=y
-CONFIG_BUILTIN_LOCK=y
 CONFIG_BUILTIN_PROBE=y
-CONFIG_BUILTIN_SCHED=y
-CONFIG_BUILTIN_SCRIPT=y
-CONFIG_BUILTIN_TIMECHART=y
-CONFIG_BUILTIN_MEM=y
 CONFIG_BUILTIN_TEST=y
 
 #
@@ -53,7 +44,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_REPORT_config b/tools/perf/tests/configs/NO_BUILTIN_REPORT_config
index 1d27667..369e951 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_REPORT_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_REPORT_config
@@ -5,7 +5,6 @@
 CONFIG_BUILTIN_RECORD=y
 # CONFIG_BUILTIN_REPORT is not set
 CONFIG_BUILTIN_STAT=y
-CONFIG_BUILTIN_TOP=y
 CONFIG_BUILTIN_TRACE=y
 CONFIG_BUILTIN_ANNOTATE=y
 CONFIG_BUILTIN_BENCH=y
@@ -16,14 +15,11 @@ CONFIG_BUILTIN_EVLIST=y
 CONFIG_BUILTIN_HELP=y
 CONFIG_BUILTIN_INJECT=y
 CONFIG_BUILTIN_KMEM=y
-CONFIG_BUILTIN_KVM=y
 CONFIG_BUILTIN_LIST=y
-CONFIG_BUILTIN_LOCK=y
 CONFIG_BUILTIN_PROBE=y
 CONFIG_BUILTIN_SCHED=y
 CONFIG_BUILTIN_SCRIPT=y
 CONFIG_BUILTIN_TIMECHART=y
-CONFIG_BUILTIN_MEM=y
 CONFIG_BUILTIN_TEST=y
 
 #
@@ -53,7 +49,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_SCHED_config b/tools/perf/tests/configs/NO_BUILTIN_SCHED_config
index 7944d9b..deda613 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_SCHED_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_SCHED_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_SCRIPT_config b/tools/perf/tests/configs/NO_BUILTIN_SCRIPT_config
index 52d4121..fb8cd00 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_SCRIPT_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_SCRIPT_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_STAT_config b/tools/perf/tests/configs/NO_BUILTIN_STAT_config
index 2486420..b0d35f7 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_STAT_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_STAT_config
@@ -16,7 +16,6 @@ CONFIG_BUILTIN_EVLIST=y
 CONFIG_BUILTIN_HELP=y
 CONFIG_BUILTIN_INJECT=y
 CONFIG_BUILTIN_KMEM=y
-CONFIG_BUILTIN_KVM=y
 CONFIG_BUILTIN_LIST=y
 CONFIG_BUILTIN_LOCK=y
 CONFIG_BUILTIN_PROBE=y
@@ -53,7 +52,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_TEST_config b/tools/perf/tests/configs/NO_BUILTIN_TEST_config
index 1c52914..7270364 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_TEST_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_TEST_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_TIMECHART_config b/tools/perf/tests/configs/NO_BUILTIN_TIMECHART_config
index 143a60d..41d21f9 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_TIMECHART_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_TIMECHART_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_TOP_config b/tools/perf/tests/configs/NO_BUILTIN_TOP_config
index 188bcf2..fa231f7 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_TOP_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_TOP_config
@@ -16,7 +16,6 @@ CONFIG_BUILTIN_EVLIST=y
 CONFIG_BUILTIN_HELP=y
 CONFIG_BUILTIN_INJECT=y
 CONFIG_BUILTIN_KMEM=y
-CONFIG_BUILTIN_KVM=y
 CONFIG_BUILTIN_LIST=y
 CONFIG_BUILTIN_LOCK=y
 CONFIG_BUILTIN_PROBE=y
@@ -53,7 +52,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_TRACE_config b/tools/perf/tests/configs/NO_BUILTIN_TRACE_config
index 114d210..8ca377b 100644
--- a/tools/perf/tests/configs/NO_BUILTIN_TRACE_config
+++ b/tools/perf/tests/configs/NO_BUILTIN_TRACE_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_DEMANGLE_config b/tools/perf/tests/configs/NO_DEMANGLE_config
index 2aaaf20..e2a79e3 100644
--- a/tools/perf/tests/configs/NO_DEMANGLE_config
+++ b/tools/perf/tests/configs/NO_DEMANGLE_config
@@ -51,7 +51,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_GTK2_config b/tools/perf/tests/configs/NO_GTK2_config
index e1989c2..a806529 100644
--- a/tools/perf/tests/configs/NO_GTK2_config
+++ b/tools/perf/tests/configs/NO_GTK2_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_LIBAUDIT_config b/tools/perf/tests/configs/NO_LIBAUDIT_config
index b8fa6a2..57f2b8b 100644
--- a/tools/perf/tests/configs/NO_LIBAUDIT_config
+++ b/tools/perf/tests/configs/NO_LIBAUDIT_config
@@ -52,7 +52,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_LIBDWARF_config b/tools/perf/tests/configs/NO_LIBDWARF_config
index a5e33a1..fed5c65 100644
--- a/tools/perf/tests/configs/NO_LIBDWARF_config
+++ b/tools/perf/tests/configs/NO_LIBDWARF_config
@@ -52,6 +52,7 @@ CONFIG_LIBELF=y
 CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 # CONFIG_LIBDWARF is not set
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
diff --git a/tools/perf/tests/configs/NO_LIBELF_MMAP_config b/tools/perf/tests/configs/NO_LIBELF_MMAP_config
index d8755ea..b774b34 100644
--- a/tools/perf/tests/configs/NO_LIBELF_MMAP_config
+++ b/tools/perf/tests/configs/NO_LIBELF_MMAP_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_LIBGTK2_INFOBAR_config b/tools/perf/tests/configs/NO_LIBGTK2_INFOBAR_config
index 81cd6a2..272087c 100644
--- a/tools/perf/tests/configs/NO_LIBGTK2_INFOBAR_config
+++ b/tools/perf/tests/configs/NO_LIBGTK2_INFOBAR_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_LIBGTK2_config b/tools/perf/tests/configs/NO_LIBGTK2_config
index a52e89d..d4324ac 100644
--- a/tools/perf/tests/configs/NO_LIBGTK2_config
+++ b/tools/perf/tests/configs/NO_LIBGTK2_config
@@ -31,7 +31,6 @@ CONFIG_BUILTIN_TEST=y
 #
 CONFIG_STDIO=y
 CONFIG_TUI=y
-CONFIG_GTK2=y
 
 #
 # Libraries / Dependencies
@@ -52,7 +51,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_LIBNUMA_config b/tools/perf/tests/configs/NO_LIBNUMA_config
index 9b3c1f8..a3492dc 100644
--- a/tools/perf/tests/configs/NO_LIBNUMA_config
+++ b/tools/perf/tests/configs/NO_LIBNUMA_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 # CONFIG_LIBNUMA is not set
diff --git a/tools/perf/tests/configs/NO_LIBPERL_config b/tools/perf/tests/configs/NO_LIBPERL_config
index 4c6d6be..e430e7e 100644
--- a/tools/perf/tests/configs/NO_LIBPERL_config
+++ b/tools/perf/tests/configs/NO_LIBPERL_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_LIBPYTHON_config b/tools/perf/tests/configs/NO_LIBPYTHON_config
index 6624bbf..9bddfcf 100644
--- a/tools/perf/tests/configs/NO_LIBPYTHON_config
+++ b/tools/perf/tests/configs/NO_LIBPYTHON_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_LIBSLANG_config b/tools/perf/tests/configs/NO_LIBSLANG_config
index 5bc0f98..deebd36 100644
--- a/tools/perf/tests/configs/NO_LIBSLANG_config
+++ b/tools/perf/tests/configs/NO_LIBSLANG_config
@@ -52,7 +52,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_LIBUNWIND_DEBUG_FRAME_config b/tools/perf/tests/configs/NO_LIBUNWIND_DEBUG_FRAME_config
index ca571d3..03bc63b 100644
--- a/tools/perf/tests/configs/NO_LIBUNWIND_DEBUG_FRAME_config
+++ b/tools/perf/tests/configs/NO_LIBUNWIND_DEBUG_FRAME_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 # CONFIG_LIBUNWIND_DEBUG_FRAME is not set
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_STDIO_config b/tools/perf/tests/configs/NO_STDIO_config
index 2f92b2d..48889d9 100644
--- a/tools/perf/tests/configs/NO_STDIO_config
+++ b/tools/perf/tests/configs/NO_STDIO_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_TIMERFD_config b/tools/perf/tests/configs/NO_TIMERFD_config
index 4b54af8..dace6d9 100644
--- a/tools/perf/tests/configs/NO_TIMERFD_config
+++ b/tools/perf/tests/configs/NO_TIMERFD_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_TUI_config b/tools/perf/tests/configs/NO_TUI_config
index b95b982..55cd95b 100644
--- a/tools/perf/tests/configs/NO_TUI_config
+++ b/tools/perf/tests/configs/NO_TUI_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/NO_LIBUNWIND_config b/tools/perf/tests/configs/NO_UNWIND_config
similarity index 97%
rename from tools/perf/tests/configs/NO_LIBUNWIND_config
rename to tools/perf/tests/configs/NO_UNWIND_config
index 6cc2c7c..6a3fbc5 100644
--- a/tools/perf/tests/configs/NO_LIBUNWIND_config
+++ b/tools/perf/tests/configs/NO_UNWIND_config
@@ -53,7 +53,7 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
-# CONFIG_LIBUNWIND is not set
+# CONFIG_UNWIND is not set
 CONFIG_LIBNUMA=y
 # CONFIG_BIONIC is not set
 
diff --git a/tools/perf/tests/configs/REF_config b/tools/perf/tests/configs/REF_config
index bbaab9f..30d1c3d 100644
--- a/tools/perf/tests/configs/REF_config
+++ b/tools/perf/tests/configs/REF_config
@@ -53,7 +53,9 @@ CONFIG_LIBELF_MMAP=y
 CONFIG_LIBELF_GETPHDRNUM=y
 CONFIG_LIBDWARF=y
 CONFIG_LIBDWARF_DIR=""
+CONFIG_UNWIND=y
 CONFIG_LIBUNWIND=y
+# CONFIG_LIBDWARF_UNWIND is not set
 CONFIG_LIBUNWIND_DEBUG_FRAME=y
 CONFIG_LIBUNWIND_DIR=""
 CONFIG_LIBNUMA=y
diff --git a/tools/perf/tests/configs/generate.py b/tools/perf/tests/configs/generate.py
new file mode 100644
index 0000000..c55a1c9
--- /dev/null
+++ b/tools/perf/tests/configs/generate.py
@@ -0,0 +1,33 @@
+import sys
+import itertools
+import kconfiglib
+
+# Load Kconfig pattern
+ref_config = kconfiglib.Config(sys.argv[1])
+
+# Generate defconfig (by default, all options are set to y)
+ref_config.write_config('REF_config')
+
+# Get all the symbols
+symbols = dict([(s.get_name(), s) for s in ref_config.get_symbols()])
+
+# Remove odd symbols
+symbols.pop('y', None)
+symbols.pop('m', None)
+symbols.pop('n', None)
+
+# Remove choice-related symbols
+choices = ref_config.get_choices()
+items = [c.get_items() for c in choices]
+names = [i.get_name() for i in itertools.chain.from_iterable(items)]
+for name in names:
+    symbols.pop(name, None)
+
+for name in symbols:
+    symbol = symbols[name]
+    if symbol.get_value() != 'y':
+        continue
+    symbol.set_user_value('n')
+    filename = 'NO_' + name + '_config'
+    ref_config.write_config(filename)
+    symbol.set_user_value('y')
diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 3db09e7..06533f0 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -44,7 +44,7 @@ run += make_install_bin
 # run += make_install_html
 # run += make_install_info
 # run += make_install_pdf
-run += make_static
+# run += make_static
 
 ifneq ($(call has,ctags),)
 run += make_tags
@@ -197,7 +197,10 @@ tarpkg:
 	echo "- $@: $$cmd" && echo $$cmd > $@ && \
 	( eval $$cmd ) >> $@ 2>&1
 
-all: $(run) $(run_O) $(run_CONFIGS) tarpkg
+#all: $(run) $(run_O) $(run_CONFIGS) tarpkg
+#	@echo OK
+
+all: $(run_CONFIGS) tarpkg
 	@echo OK
 
 out: $(run_O)
-- 
1.9.3

