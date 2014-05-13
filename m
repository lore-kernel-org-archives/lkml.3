Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaEMWHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:07:38 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:56597 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaEMWFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:50 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 27/34] perf kbuild: add generated Kconfig build-test cases
Date: Wed, 14 May 2014 00:03:22 +0200
Message-Id: <1400018609-20486-28-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to the python module kconfiglib, we were able to generate build
configurations. The set is, of course, not exhaustive but for each
option, all the possible states are tested.

This commit contains also a few changes so that all tests pass...
---
 tools/perf/Kconfig                                 | 115 +++++++++++----------
 tools/perf/Makefile                                |   2 +-
 tools/perf/Makefile.kbuild                         |   2 +-
 tools/perf/builtin-annotate.c                      |   8 +-
 tools/perf/builtin-kvm.c                           |  19 ++--
 tools/perf/builtin-mem.c                           |   3 +-
 tools/perf/builtin-report.c                        |   3 +
 tools/perf/builtin-top.c                           |  15 ++-
 tools/perf/tests/configs/MINIMAL_config            |  56 ++++++++++
 tools/perf/tests/configs/NO_BACKTRACE_config       |  67 ++++++++++++
 .../perf/tests/configs/NO_BUILTIN_ANNOTATE_config  |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_BENCH_config   |  67 ++++++++++++
 .../tests/configs/NO_BUILTIN_BUILDID_CACHE_config  |  67 ++++++++++++
 .../tests/configs/NO_BUILTIN_BUILDID_LIST_config   |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_DIFF_config    |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_EVLIST_config  |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_HELP_config    |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_INJECT_config  |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_KMEM_config    |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_KVM_config     |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_LIST_config    |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_LOCK_config    |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_MEM_config     |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_PROBE_config   |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_RECORD_config  |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_REPORT_config  |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_SCHED_config   |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_SCRIPT_config  |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_STAT_config    |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_TEST_config    |  67 ++++++++++++
 .../perf/tests/configs/NO_BUILTIN_TIMECHART_config |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_TOP_config     |  67 ++++++++++++
 tools/perf/tests/configs/NO_BUILTIN_TRACE_config   |  67 ++++++++++++
 tools/perf/tests/configs/NO_DEMANGLE_config        |  65 ++++++++++++
 tools/perf/tests/configs/NO_GTK2_config            |  67 ++++++++++++
 tools/perf/tests/configs/NO_LIBAUDIT_config        |  66 ++++++++++++
 tools/perf/tests/configs/NO_LIBDWARF_config        |  66 ++++++++++++
 tools/perf/tests/configs/NO_LIBELF_MMAP_config     |  67 ++++++++++++
 tools/perf/tests/configs/NO_LIBGTK2_INFOBAR_config |  67 ++++++++++++
 tools/perf/tests/configs/NO_LIBGTK2_config         |  66 ++++++++++++
 tools/perf/tests/configs/NO_LIBNUMA_config         |  67 ++++++++++++
 tools/perf/tests/configs/NO_LIBPERL_config         |  67 ++++++++++++
 tools/perf/tests/configs/NO_LIBPYTHON_config       |  67 ++++++++++++
 tools/perf/tests/configs/NO_LIBSLANG_config        |  66 ++++++++++++
 .../tests/configs/NO_LIBUNWIND_DEBUG_FRAME_config  |  67 ++++++++++++
 tools/perf/tests/configs/NO_LIBUNWIND_config       |  65 ++++++++++++
 tools/perf/tests/configs/NO_STDIO_config           |  67 ++++++++++++
 tools/perf/tests/configs/NO_TIMERFD_config         |  67 ++++++++++++
 tools/perf/tests/configs/NO_TUI_config             |  67 ++++++++++++
 tools/perf/tests/configs/REF_config                |  67 ++++++++++++
 tools/perf/tests/make                              |  65 +++---------
 tools/perf/ui/setup.c                              |   6 +-
 tools/perf/util/Kbuild                             |   9 +-
 53 files changed, 2924 insertions(+), 118 deletions(-)
 create mode 100644 tools/perf/tests/configs/MINIMAL_config
 create mode 100644 tools/perf/tests/configs/NO_BACKTRACE_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_ANNOTATE_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_BENCH_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_BUILDID_CACHE_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_BUILDID_LIST_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_DIFF_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_EVLIST_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_HELP_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_INJECT_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_KMEM_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_KVM_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_LIST_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_LOCK_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_MEM_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_PROBE_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_RECORD_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_REPORT_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_SCHED_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_SCRIPT_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_STAT_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_TEST_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_TIMECHART_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_TOP_config
 create mode 100644 tools/perf/tests/configs/NO_BUILTIN_TRACE_config
 create mode 100644 tools/perf/tests/configs/NO_DEMANGLE_config
 create mode 100644 tools/perf/tests/configs/NO_GTK2_config
 create mode 100644 tools/perf/tests/configs/NO_LIBAUDIT_config
 create mode 100644 tools/perf/tests/configs/NO_LIBDWARF_config
 create mode 100644 tools/perf/tests/configs/NO_LIBELF_MMAP_config
 create mode 100644 tools/perf/tests/configs/NO_LIBGTK2_INFOBAR_config
 create mode 100644 tools/perf/tests/configs/NO_LIBGTK2_config
 create mode 100644 tools/perf/tests/configs/NO_LIBNUMA_config
 create mode 100644 tools/perf/tests/configs/NO_LIBPERL_config
 create mode 100644 tools/perf/tests/configs/NO_LIBPYTHON_config
 create mode 100644 tools/perf/tests/configs/NO_LIBSLANG_config
 create mode 100644 tools/perf/tests/configs/NO_LIBUNWIND_DEBUG_FRAME_config
 create mode 100644 tools/perf/tests/configs/NO_LIBUNWIND_config
 create mode 100644 tools/perf/tests/configs/NO_STDIO_config
 create mode 100644 tools/perf/tests/configs/NO_TIMERFD_config
 create mode 100644 tools/perf/tests/configs/NO_TUI_config
 create mode 100644 tools/perf/tests/configs/REF_config

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index 15cebe9..aff6208 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -23,38 +23,39 @@ config BUILTIN_STAT
 
 config BUILTIN_TOP
 	bool "top"
-	default n
+	default y
+	depends on BUILTIN_RECORD && BUILTIN_REPORT
         ---help---
 	  top
 
 config BUILTIN_TRACE
 	bool "trace"
-	default n
-	depends on LIBAUDIT
+	default y
+	depends on BUILTIN_RECORD && LIBAUDIT
         ---help---
 	  trace
 
 config BUILTIN_ANNOTATE
 	bool "annotate"
-	default n
+	default y
         ---help---
 	  annotate
 
 config BUILTIN_BENCH
 	bool "bench"
-	default n
+	default y
         ---help---
 	  bench
 
 config BUILTIN_BUILDID_CACHE
 	bool "buildid-cache"
-	default n
+	default y
         ---help---
 	  buildid-cache
 
 config BUILTIN_BUILDID_LIST
 	bool "buildid-list"
-	default n
+	default y
         ---help---
 	  buildid-list
 
@@ -66,7 +67,7 @@ config BUILTIN_DIFF
 
 config BUILTIN_EVLIST
 	bool "evlist"
-	default n
+	default y
         ---help---
 	  evlist
 
@@ -78,62 +79,71 @@ config BUILTIN_HELP
 
 config BUILTIN_INJECT
 	bool "inject"
-	default n
+	default y
         ---help---
 	  inject
 
 config BUILTIN_KMEM
 	bool "kmem"
-	default n
+	default y
+	depends on BUILTIN_RECORD
         ---help---
 	  kmem
 
 config BUILTIN_KVM
 	bool "kvm"
-	default n
+	default y
+	depends on BUILTIN_RECORD && BUILTIN_REPORT && \
+		BUILTIN_RECORD && BUILTIN_BUILDID_LIST && \
+		BUILTIN_TOP && BUILTIN_DIFF && BUILTIN_STAT
         ---help---
 	  kvm
 
 config BUILTIN_LIST
 	bool "list"
-	default n
+	default y
         ---help---
 	  list
 
 config BUILTIN_LOCK
 	bool "lock"
-	default n
+	default y
+	depends on BUILTIN_RECORD && BUILTIN_REPORT
         ---help---
 	  lock
 
 config BUILTIN_PROBE
 	bool "probe"
-	default n
+	default y
 	depends on LIBELF
         ---help---
 	  probe
 
 config BUILTIN_SCHED
 	bool "sched"
-	default n
+	default y
+	depends on BUILTIN_RECORD
         ---help---
 	  sched
 
 config BUILTIN_SCRIPT
 	bool "script"
 	default y
+	depends on BUILTIN_RECORD
         ---help---
 	  script
 
 config BUILTIN_TIMECHART
 	bool "timechart"
-	default n
+	default y
+	depends on BUILTIN_RECORD
         ---help---
 	  timechart
 
 config BUILTIN_MEM
 	bool "mem"
 	default y
+	depends on BUILTIN_RECORD && BUILTIN_REPORT
         ---help---
 	  mem
 
@@ -145,61 +155,85 @@ config BUILTIN_TEST
 
 endmenu
 
+menu "GUI"
+
+config STDIO
+	bool "Terminal"
+	default y
+        ---help---
+	  stdio
+
+config TUI
+	bool "Tui (slang based)"
+	depends on LIBSLANG
+	default y
+        ---help---
+	  stdio
+
+config GTK2
+	bool "Gtk2"
+	default y
+	depends on LIBGTK2
+        ---help---
+	  stdio
+
+endmenu
+
 menu "Libraries / Dependencies"
 
 config LIBSLANG
 	bool "Slang (libslang)"
-	default n
+	default y
         ---help---
 	  libslang
 
 config LIBAUDIT
 	bool "Audit (libaudit)"
-	default n
+	default y
         ---help---
 	  libaudit
 
 config LIBGTK2
 	bool "Gtk2 (libgtk2)"
-	default n
+	default y
         ---help---
 	  libgtk2
 
 config LIBGTK2_INFOBAR
 	bool "Gtk2 infobar (libgtk2)"
 	depends on LIBGTK2
-	default n
+	default y
         ---help---
 	  libgtk2-infobar
 
 config LIBPERL
 	bool "Perl"
-	default n
+	default y
         ---help---
 	  Perl
 
 config LIBPYTHON
 	bool "Python"
-	default n
+	default y
         ---help---
 	  Python
 
 config TIMERFD
 	bool "Timer via file descriptor"
-	default n
+	default y
         ---help---
 	  Timer via file descriptor
 
 config ON_EXIT
 	bool "Support of on_exit() function"
-	default n
+	default y
         ---help---
 	  On exit support
 
 config DEMANGLE
        depends on LIBELF
 	bool "Demangle symbols"
-	default n
+	default y
         ---help---
 	  demangle
 
@@ -250,7 +284,7 @@ config LIBELF_GETPHDRNUM
 
 config LIBDWARF
         depends on LIBELF
-	default n
+	default y
 	bool "Dwarf (libdwarf)"
         ---help---
 	  libdwarf
@@ -264,7 +298,7 @@ config LIBDWARF_DIR
 config UNWIND
         depends on LIBELF
 	bool "User space unwind callchains"
-	default n
+	default y
         ---help---
 	  unwind
 
@@ -302,7 +336,7 @@ config LIBUNWIND_DIR
 
 config LIBNUMA
 	bool "Libnuma support"
-	default n
+	default y
         ---help---
 	  Libnuma
 
@@ -314,29 +348,6 @@ config BIONIC
 
 endmenu
 
-menu "GUI"
-
-config STDIO
-	bool "Terminal"
-	default y
-        ---help---
-	  stdio
-
-config TUI
-	bool "Tui (slang based)"
-	depends on LIBSLANG
-	default n
-        ---help---
-	  stdio
-
-config GTK2
-	bool "Gtk2"
-	default n
-        ---help---
-	  stdio
-
-endmenu
-
 menu "Build"
 config DEBUG
 	bool "Compile with debug info"
@@ -352,7 +363,7 @@ config DEBUG_PARSER
 
 config BACKTRACE
 	bool "Compile with dump_stack support"
-	default n
+	default y
         ---help---
 	  dump_stack support
 
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index cb2e586..4512f16 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -55,7 +55,7 @@ define print_msg
 endef
 
 define make
-  @$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) O=$(FULL_O) $(SET_DEBUG) $@
+  @$(MAKE) -f Makefile.kbuild --no-print-directory -j$(JOBS) O=$(FULL_O) $(SET_DEBUG) $@
 endef
 
 #
diff --git a/tools/perf/Makefile.kbuild b/tools/perf/Makefile.kbuild
index 7d625ae..2f980f7 100644
--- a/tools/perf/Makefile.kbuild
+++ b/tools/perf/Makefile.kbuild
@@ -43,7 +43,7 @@ export QUIET_BISON QUIET_FLEX
 
 ifeq ($(KBUILD_SRC),)
 
-ifeq ("$(origin O)", "command line")
+ifneq ($(O),)
 KBUILD_OUTPUT := $(O)
 else
 KBUILD_OUTPUT := $(objtree)
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 0da603b..96a6cad 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -5,6 +5,7 @@
  * look up and read DSOs and symbol information and display
  * a histogram of results, along various sorting keys.
  */
+#include "generated/autoconf.h"
 #include "builtin.h"
 
 #include "util/util.h"
@@ -114,7 +115,7 @@ static void hists__find_annotations(struct hists *hists,
 				    struct perf_evsel *evsel,
 				    struct perf_annotate *ann)
 {
-	struct rb_node *nd = rb_first(&hists->entries), *next;
+	struct rb_node *nd = rb_first(&hists->entries);
 	int key = K_RIGHT;
 
 	while (nd) {
@@ -153,7 +154,9 @@ find_next:
 
 			/* skip missing symbols */
 			nd = rb_next(nd);
+#ifdef CONFIG_TUI
 		} else if (use_browser == 1) {
+                        struct rb_node *next = NULL;
 			key = hist_entry__tui_annotate(he, evsel, NULL);
 			switch (key) {
 			case -1:
@@ -172,6 +175,7 @@ find_next:
 
 			if (next != NULL)
 				nd = next;
+#endif /* CONFIG_TUI */
 		} else {
 			hist_entry__tty_annotate(he, evsel, ann);
 			nd = rb_next(nd);
@@ -314,7 +318,9 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN(0, "gtk", &annotate.use_gtk, "Use the GTK interface"),
+#ifdef CONFIG_TUI
 	OPT_BOOLEAN(0, "tui", &annotate.use_tui, "Use the TUI interface"),
+#endif /* CONFIG_TUI */
 	OPT_BOOLEAN(0, "stdio", &annotate.use_stdio, "Use the stdio interface"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index d035253..17eb07e 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1719,20 +1719,25 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	if (!strncmp(argv[0], "rec", 3))
 		return __cmd_record(file_name, argc, argv);
-	else if (!strncmp(argv[0], "rep", 3))
+
+	if (!strncmp(argv[0], "rep", 3))
 		return __cmd_report(file_name, argc, argv);
-	else if (!strncmp(argv[0], "diff", 4))
+
+	if (!strncmp(argv[0], "diff", 4))
 		return cmd_diff(argc, argv, NULL);
-	else if (!strncmp(argv[0], "top", 3))
+
+	if (!strncmp(argv[0], "top", 3))
 		return cmd_top(argc, argv, NULL);
-	else if (!strncmp(argv[0], "buildid-list", 12))
+
+	if (!strncmp(argv[0], "buildid-list", 12))
 		return __cmd_buildid_list(file_name, argc, argv);
+
 #if defined(__i386__) || defined(__x86_64__)
-	else if (!strncmp(argv[0], "stat", 4))
+	if (!strncmp(argv[0], "stat", 4))
 		return kvm_cmd_stat(file_name, argc, argv);
 #endif
-	else
-		usage_with_options(kvm_usage, kvm_options);
+
+        usage_with_options(kvm_usage, kvm_options);
 
 	return 0;
 }
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 2e3ade69..693f0cb 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -1,3 +1,4 @@
+#include "generated/autoconf.h"
 #include "builtin.h"
 #include "perf.h"
 
@@ -238,7 +239,7 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 		return __cmd_record(argc, argv);
 	else if (!strncmp(argv[0], "rep", 3))
 		return report_events(argc, argv, &mem);
-	else
+        else
 		usage_with_options(mem_usage, mem_options);
 
 	return 0;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c8f2113..e2c433f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -5,6 +5,7 @@
  * look up and read DSOs and symbol information and display
  * a histogram of results, along various sorting keys.
  */
+#include "generated/autoconf.h"
 #include "builtin.h"
 
 #include "util/util.h"
@@ -448,6 +449,7 @@ static int report__browse_hists(struct report *rep)
 	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
 
 	switch (use_browser) {
+#ifdef CONFIG_TUI
 	case 1:
 		ret = perf_evlist__tui_browse_hists(evlist, help, NULL,
 						    rep->min_percent,
@@ -459,6 +461,7 @@ static int report__browse_hists(struct report *rep)
 		if (ret != K_SWITCH_INPUT_DATA)
 			ret = 0;
 		break;
+#endif /* CONFIG_TUI */
 	case 2:
 		ret = report__gtk_browse_hists(rep, help);
 		break;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 65aaa5b..0dd0278 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -17,6 +17,7 @@
  *
  * Released under the GPL v2. (and only v2, not any later version)
  */
+#include "generated/autoconf.h"
 #include "builtin.h"
 
 #include "perf.h"
@@ -544,6 +545,7 @@ static bool perf_top__handle_keypress(struct perf_top *top, int c)
 	return ret;
 }
 
+#ifdef CONFIG_TUI
 static void perf_top__sort_new_samples(void *arg)
 {
 	struct perf_top *t = arg;
@@ -586,6 +588,7 @@ static void *display_thread_tui(void *arg)
 	done = 1;
 	return NULL;
 }
+#endif /* CONFIG_TUI */
 
 static void *display_thread(void *arg)
 {
@@ -898,9 +901,12 @@ static int perf_top__setup_sample_type(struct perf_top *top __maybe_unused)
 	return 0;
 }
 
+typedef void* (*display_fn_t)(void*);
+
 static int __cmd_top(struct perf_top *top)
 {
 	struct record_opts *opts = &top->record_opts;
+        display_fn_t display_fn = display_thread;
 	pthread_t thread;
 	int ret;
 
@@ -946,8 +952,13 @@ static int __cmd_top(struct perf_top *top)
 	perf_top__mmap_read(top);
 
 	ret = -1;
-	if (pthread_create(&thread, NULL, (use_browser > 0 ? display_thread_tui :
-							    display_thread), top)) {
+
+#ifdef CONFIG_TUI
+        if (use_browser > 0)
+            display_fn = display_thread_tui;
+#endif
+
+	if (pthread_create(&thread, NULL, display_fn, top)) {
 		ui__error("Could not create display thread.\n");
 		goto out_delete;
 	}
diff --git a/tools/perf/tests/configs/MINIMAL_config b/tools/perf/tests/configs/MINIMAL_config
new file mode 100644
index 0000000..722282a
--- /dev/null
+++ b/tools/perf/tests/configs/MINIMAL_config
@@ -0,0 +1,56 @@
+#
+# Automatically generated file; DO NOT EDIT.
+# The perf configuration
+#
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+
+#
+# Libraries / Dependencies
+#
+# CONFIG_LIBSLANG is not set
+# CONFIG_LIBAUDIT is not set
+# CONFIG_LIBGTK2 is not set
+# CONFIG_LIBPERL is not set
+# CONFIG_LIBPYTHON is not set
+# CONFIG_TIMERFD is not set
+CONFIG_ON_EXIT=y
+# CONFIG_LIBELF is not set
+CONFIG_LIBELF_MINIMAL=y
+# CONFIG_LIBNUMA is not set
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BACKTRACE_config b/tools/perf/tests/configs/NO_BACKTRACE_config
new file mode 100644
index 0000000..f44b4f9
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BACKTRACE_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+# CONFIG_BACKTRACE is not set
diff --git a/tools/perf/tests/configs/NO_BUILTIN_ANNOTATE_config b/tools/perf/tests/configs/NO_BUILTIN_ANNOTATE_config
new file mode 100644
index 0000000..5fdce32
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_ANNOTATE_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+# CONFIG_BUILTIN_ANNOTATE is not set
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_BENCH_config b/tools/perf/tests/configs/NO_BUILTIN_BENCH_config
new file mode 100644
index 0000000..99d601e
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_BENCH_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+# CONFIG_BUILTIN_BENCH is not set
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_BUILDID_CACHE_config b/tools/perf/tests/configs/NO_BUILTIN_BUILDID_CACHE_config
new file mode 100644
index 0000000..edcee97
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_BUILDID_CACHE_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+# CONFIG_BUILTIN_BUILDID_CACHE is not set
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_BUILDID_LIST_config b/tools/perf/tests/configs/NO_BUILTIN_BUILDID_LIST_config
new file mode 100644
index 0000000..3043178
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_BUILDID_LIST_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+# CONFIG_BUILTIN_BUILDID_LIST is not set
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_DIFF_config b/tools/perf/tests/configs/NO_BUILTIN_DIFF_config
new file mode 100644
index 0000000..f553f96
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_DIFF_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+# CONFIG_BUILTIN_DIFF is not set
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_EVLIST_config b/tools/perf/tests/configs/NO_BUILTIN_EVLIST_config
new file mode 100644
index 0000000..8198a9d
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_EVLIST_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+# CONFIG_BUILTIN_EVLIST is not set
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_HELP_config b/tools/perf/tests/configs/NO_BUILTIN_HELP_config
new file mode 100644
index 0000000..d897913
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_HELP_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+# CONFIG_BUILTIN_HELP is not set
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_INJECT_config b/tools/perf/tests/configs/NO_BUILTIN_INJECT_config
new file mode 100644
index 0000000..3322780
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_INJECT_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+# CONFIG_BUILTIN_INJECT is not set
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_KMEM_config b/tools/perf/tests/configs/NO_BUILTIN_KMEM_config
new file mode 100644
index 0000000..0cb7cba
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_KMEM_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+# CONFIG_BUILTIN_KMEM is not set
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_KVM_config b/tools/perf/tests/configs/NO_BUILTIN_KVM_config
new file mode 100644
index 0000000..d7849bc
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_KVM_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+# CONFIG_BUILTIN_KVM is not set
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_LIST_config b/tools/perf/tests/configs/NO_BUILTIN_LIST_config
new file mode 100644
index 0000000..3eed298d
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_LIST_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+# CONFIG_BUILTIN_LIST is not set
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_LOCK_config b/tools/perf/tests/configs/NO_BUILTIN_LOCK_config
new file mode 100644
index 0000000..6347efd
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_LOCK_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+# CONFIG_BUILTIN_LOCK is not set
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_MEM_config b/tools/perf/tests/configs/NO_BUILTIN_MEM_config
new file mode 100644
index 0000000..d432c6a
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_MEM_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+# CONFIG_BUILTIN_MEM is not set
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_PROBE_config b/tools/perf/tests/configs/NO_BUILTIN_PROBE_config
new file mode 100644
index 0000000..6dd2f14
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_PROBE_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+# CONFIG_BUILTIN_PROBE is not set
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_RECORD_config b/tools/perf/tests/configs/NO_BUILTIN_RECORD_config
new file mode 100644
index 0000000..e5bca7c
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_RECORD_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+# CONFIG_BUILTIN_RECORD is not set
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_REPORT_config b/tools/perf/tests/configs/NO_BUILTIN_REPORT_config
new file mode 100644
index 0000000..1d27667
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_REPORT_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+# CONFIG_BUILTIN_REPORT is not set
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_SCHED_config b/tools/perf/tests/configs/NO_BUILTIN_SCHED_config
new file mode 100644
index 0000000..7944d9b
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_SCHED_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+# CONFIG_BUILTIN_SCHED is not set
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_SCRIPT_config b/tools/perf/tests/configs/NO_BUILTIN_SCRIPT_config
new file mode 100644
index 0000000..52d4121
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_SCRIPT_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+# CONFIG_BUILTIN_SCRIPT is not set
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_STAT_config b/tools/perf/tests/configs/NO_BUILTIN_STAT_config
new file mode 100644
index 0000000..2486420
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_STAT_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+# CONFIG_BUILTIN_STAT is not set
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_TEST_config b/tools/perf/tests/configs/NO_BUILTIN_TEST_config
new file mode 100644
index 0000000..1c52914
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_TEST_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+# CONFIG_BUILTIN_TEST is not set
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_TIMECHART_config b/tools/perf/tests/configs/NO_BUILTIN_TIMECHART_config
new file mode 100644
index 0000000..143a60d
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_TIMECHART_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+# CONFIG_BUILTIN_TIMECHART is not set
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_TOP_config b/tools/perf/tests/configs/NO_BUILTIN_TOP_config
new file mode 100644
index 0000000..188bcf2
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_TOP_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+# CONFIG_BUILTIN_TOP is not set
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_BUILTIN_TRACE_config b/tools/perf/tests/configs/NO_BUILTIN_TRACE_config
new file mode 100644
index 0000000..114d210
--- /dev/null
+++ b/tools/perf/tests/configs/NO_BUILTIN_TRACE_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+# CONFIG_BUILTIN_TRACE is not set
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_DEMANGLE_config b/tools/perf/tests/configs/NO_DEMANGLE_config
new file mode 100644
index 0000000..2aaaf20
--- /dev/null
+++ b/tools/perf/tests/configs/NO_DEMANGLE_config
@@ -0,0 +1,65 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+# CONFIG_DEMANGLE is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_GTK2_config b/tools/perf/tests/configs/NO_GTK2_config
new file mode 100644
index 0000000..e1989c2
--- /dev/null
+++ b/tools/perf/tests/configs/NO_GTK2_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+# CONFIG_GTK2 is not set
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_LIBAUDIT_config b/tools/perf/tests/configs/NO_LIBAUDIT_config
new file mode 100644
index 0000000..b8fa6a2
--- /dev/null
+++ b/tools/perf/tests/configs/NO_LIBAUDIT_config
@@ -0,0 +1,66 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+# CONFIG_LIBAUDIT is not set
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_LIBDWARF_config b/tools/perf/tests/configs/NO_LIBDWARF_config
new file mode 100644
index 0000000..a5e33a1
--- /dev/null
+++ b/tools/perf/tests/configs/NO_LIBDWARF_config
@@ -0,0 +1,66 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+# CONFIG_LIBDWARF is not set
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_LIBELF_MMAP_config b/tools/perf/tests/configs/NO_LIBELF_MMAP_config
new file mode 100644
index 0000000..d8755ea
--- /dev/null
+++ b/tools/perf/tests/configs/NO_LIBELF_MMAP_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+# CONFIG_LIBELF_MMAP is not set
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_LIBGTK2_INFOBAR_config b/tools/perf/tests/configs/NO_LIBGTK2_INFOBAR_config
new file mode 100644
index 0000000..81cd6a2
--- /dev/null
+++ b/tools/perf/tests/configs/NO_LIBGTK2_INFOBAR_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+# CONFIG_LIBGTK2_INFOBAR is not set
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_LIBGTK2_config b/tools/perf/tests/configs/NO_LIBGTK2_config
new file mode 100644
index 0000000..a52e89d
--- /dev/null
+++ b/tools/perf/tests/configs/NO_LIBGTK2_config
@@ -0,0 +1,66 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+# CONFIG_LIBGTK2 is not set
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_LIBNUMA_config b/tools/perf/tests/configs/NO_LIBNUMA_config
new file mode 100644
index 0000000..9b3c1f8
--- /dev/null
+++ b/tools/perf/tests/configs/NO_LIBNUMA_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+# CONFIG_LIBNUMA is not set
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_LIBPERL_config b/tools/perf/tests/configs/NO_LIBPERL_config
new file mode 100644
index 0000000..4c6d6be
--- /dev/null
+++ b/tools/perf/tests/configs/NO_LIBPERL_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+# CONFIG_LIBPERL is not set
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_LIBPYTHON_config b/tools/perf/tests/configs/NO_LIBPYTHON_config
new file mode 100644
index 0000000..6624bbf
--- /dev/null
+++ b/tools/perf/tests/configs/NO_LIBPYTHON_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+# CONFIG_LIBPYTHON is not set
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_LIBSLANG_config b/tools/perf/tests/configs/NO_LIBSLANG_config
new file mode 100644
index 0000000..5bc0f98
--- /dev/null
+++ b/tools/perf/tests/configs/NO_LIBSLANG_config
@@ -0,0 +1,66 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+# CONFIG_LIBSLANG is not set
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_LIBUNWIND_DEBUG_FRAME_config b/tools/perf/tests/configs/NO_LIBUNWIND_DEBUG_FRAME_config
new file mode 100644
index 0000000..ca571d3
--- /dev/null
+++ b/tools/perf/tests/configs/NO_LIBUNWIND_DEBUG_FRAME_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+# CONFIG_LIBUNWIND_DEBUG_FRAME is not set
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_LIBUNWIND_config b/tools/perf/tests/configs/NO_LIBUNWIND_config
new file mode 100644
index 0000000..6cc2c7c
--- /dev/null
+++ b/tools/perf/tests/configs/NO_LIBUNWIND_config
@@ -0,0 +1,65 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+# CONFIG_LIBUNWIND is not set
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_STDIO_config b/tools/perf/tests/configs/NO_STDIO_config
new file mode 100644
index 0000000..2f92b2d
--- /dev/null
+++ b/tools/perf/tests/configs/NO_STDIO_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+# CONFIG_STDIO is not set
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_TIMERFD_config b/tools/perf/tests/configs/NO_TIMERFD_config
new file mode 100644
index 0000000..4b54af8
--- /dev/null
+++ b/tools/perf/tests/configs/NO_TIMERFD_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+# CONFIG_TIMERFD is not set
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/NO_TUI_config b/tools/perf/tests/configs/NO_TUI_config
new file mode 100644
index 0000000..b95b982
--- /dev/null
+++ b/tools/perf/tests/configs/NO_TUI_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+# CONFIG_TUI is not set
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/configs/REF_config b/tools/perf/tests/configs/REF_config
new file mode 100644
index 0000000..bbaab9f
--- /dev/null
+++ b/tools/perf/tests/configs/REF_config
@@ -0,0 +1,67 @@
+
+#
+# Built-in commands
+#
+CONFIG_BUILTIN_RECORD=y
+CONFIG_BUILTIN_REPORT=y
+CONFIG_BUILTIN_STAT=y
+CONFIG_BUILTIN_TOP=y
+CONFIG_BUILTIN_TRACE=y
+CONFIG_BUILTIN_ANNOTATE=y
+CONFIG_BUILTIN_BENCH=y
+CONFIG_BUILTIN_BUILDID_CACHE=y
+CONFIG_BUILTIN_BUILDID_LIST=y
+CONFIG_BUILTIN_DIFF=y
+CONFIG_BUILTIN_EVLIST=y
+CONFIG_BUILTIN_HELP=y
+CONFIG_BUILTIN_INJECT=y
+CONFIG_BUILTIN_KMEM=y
+CONFIG_BUILTIN_KVM=y
+CONFIG_BUILTIN_LIST=y
+CONFIG_BUILTIN_LOCK=y
+CONFIG_BUILTIN_PROBE=y
+CONFIG_BUILTIN_SCHED=y
+CONFIG_BUILTIN_SCRIPT=y
+CONFIG_BUILTIN_TIMECHART=y
+CONFIG_BUILTIN_MEM=y
+CONFIG_BUILTIN_TEST=y
+
+#
+# GUI
+#
+CONFIG_STDIO=y
+CONFIG_TUI=y
+CONFIG_GTK2=y
+
+#
+# Libraries / Dependencies
+#
+CONFIG_LIBSLANG=y
+CONFIG_LIBAUDIT=y
+CONFIG_LIBGTK2=y
+CONFIG_LIBGTK2_INFOBAR=y
+CONFIG_LIBPERL=y
+CONFIG_LIBPYTHON=y
+CONFIG_TIMERFD=y
+CONFIG_ON_EXIT=y
+CONFIG_DEMANGLE=y
+CONFIG_LIBBFD=y
+# CONFIG_LIBIBERTY_ONLY is not set
+CONFIG_LIBELF=y
+# CONFIG_LIBELF_MINIMAL is not set
+CONFIG_LIBELF_MMAP=y
+CONFIG_LIBELF_GETPHDRNUM=y
+CONFIG_LIBDWARF=y
+CONFIG_LIBDWARF_DIR=""
+CONFIG_LIBUNWIND=y
+CONFIG_LIBUNWIND_DEBUG_FRAME=y
+CONFIG_LIBUNWIND_DIR=""
+CONFIG_LIBNUMA=y
+# CONFIG_BIONIC is not set
+
+#
+# Build
+#
+# CONFIG_DEBUG is not set
+# CONFIG_DEBUG_PARSER is not set
+CONFIG_BACKTRACE=y
diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 2f92d6e..2aa2ed7 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -11,34 +11,16 @@ else
 lib = lib
 endif
 
+list = $(shell ls $1 2>/dev/null)
 has = $(shell which $1 2>/dev/null)
 
 # standard single make variable specified
 make_clean_all      := clean all
 make_python_perf_so := python/perf.so
-make_debug          := DEBUG=1
-make_no_libperl     := NO_LIBPERL=1
-make_no_libpython   := NO_LIBPYTHON=1
-make_no_scripts     := NO_LIBPYTHON=1 NO_LIBPERL=1
-make_no_newt        := NO_NEWT=1
-make_no_slang       := NO_SLANG=1
-make_no_gtk2        := NO_GTK2=1
-make_no_ui          := NO_NEWT=1 NO_SLANG=1 NO_GTK2=1
-make_no_demangle    := NO_DEMANGLE=1
-make_no_libelf      := NO_LIBELF=1
-make_no_libunwind   := NO_LIBUNWIND=1
-make_no_libdw_dwarf_unwind := NO_LIBDW_DWARF_UNWIND=1
-make_no_backtrace   := NO_BACKTRACE=1
-make_no_libnuma     := NO_LIBNUMA=1
-make_no_libaudit    := NO_LIBAUDIT=1
-make_no_libbionic   := NO_LIBBIONIC=1
 make_tags           := tags
 make_cscope         := cscope
 make_help           := help
 make_doc            := doc
-make_perf_o           := perf.o
-make_util_map_o       := util/map.o
-make_util_pmu_bison_o := util/pmu-bison.o
 make_install        := install
 make_install_bin    := install-bin
 make_install_doc    := install-doc
@@ -48,37 +30,11 @@ make_install_info   := install-info
 make_install_pdf    := install-pdf
 make_static         := LDFLAGS=-static
 
-# all the NO_* variable combined
-make_minimal        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1
-make_minimal        += NO_DEMANGLE=1 NO_LIBELF=1 NO_LIBUNWIND=1 NO_BACKTRACE=1
-make_minimal        += NO_LIBNUMA=1 NO_LIBAUDIT=1 NO_LIBBIONIC=1
-make_minimal        += NO_LIBDW_DWARF_UNWIND=1
-
 # $(run) contains all available tests
 run := make_pure
 run += make_clean_all
-run += make_python_perf_so
-run += make_debug
-run += make_no_libperl
-run += make_no_libpython
-run += make_no_scripts
-run += make_no_newt
-run += make_no_slang
-run += make_no_gtk2
-run += make_no_ui
-run += make_no_demangle
-run += make_no_libelf
-run += make_no_libunwind
-run += make_no_libdw_dwarf_unwind
-run += make_no_backtrace
-run += make_no_libnuma
-run += make_no_libaudit
-run += make_no_libbionic
 run += make_help
 run += make_doc
-run += make_perf_o
-run += make_util_map_o
-run += make_util_pmu_bison_o
 run += make_install
 run += make_install_bin
 # FIXME 'install-*' commented out till they're fixed
@@ -87,7 +43,6 @@ run += make_install_bin
 # run += make_install_html
 # run += make_install_info
 # run += make_install_pdf
-run += make_minimal
 run += make_static
 
 ifneq ($(call has,ctags),)
@@ -104,6 +59,10 @@ run_O := $(addsuffix _O,$(run))
 # disable some tests for O=...
 run_O := $(filter-out make_python_perf_so_O,$(run_O))
 
+# $(run_CONFIGS) is a set of automatically-generated Kconfig
+# configurations
+run_CONFIGS := $(call list,$(PERF)/tests/configs/)
+
 # define test for each compile as 'test_NAME' variable
 # with the test itself as a value
 test_make_tags   = test -f tags
@@ -221,13 +180,23 @@ $(run_O):
 	rm -rf $$TMP_O \
 	rm -rf $$TMP_DEST
 
+$(run_CONFIGS):
+	$(call clean)
+	@TMP_DEST=$$(mktemp -d); \
+	cmd="cd $(PERF) && cp tests/configs/$@ .config && make -f $(MK) JOBS=1 DESTDIR=$$TMP_DEST $($@)"; \
+	echo "- $@: $$cmd" && echo $$cmd > $@ && \
+	( eval $$cmd ) >> $@ 2>&1; \
+	echo "  test: $(call test,$@)" >> $@ 2>&1; \
+	$(call test,$@) && \
+	rm -f $@ \
+	rm -rf $$TMP_DEST
+
 tarpkg:
 	@cmd="$(PERF)/tests/perf-targz-src-pkg $(PERF)"; \
 	echo "- $@: $$cmd" && echo $$cmd > $@ && \
 	( eval $$cmd ) >> $@ 2>&1
-	
 
-all: $(run) $(run_O) tarpkg
+all: $(run) $(run_O) $(run_CONFIGS) tarpkg
 	@echo OK
 
 out: $(run_O)
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index b21e02a..7079459 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -79,11 +79,13 @@ void setup_browser(bool fallback_to_pager)
 		       PERF_GTK_DSO);
 		sleep(1);
 		/* fall through */
+#ifdef CONFIG_TUI
 	case 1:
 		use_browser = 1;
 		if (ui__init() == 0)
 			break;
 		/* fall through */
+#endif
 	default:
 		use_browser = 0;
 		if (fallback_to_pager)
@@ -100,11 +102,11 @@ void exit_browser(bool wait_for_ok __maybe_unused)
 	case 2:
 		exit_gtk_browser(wait_for_ok);
 		break;
-
+#ifdef CONFIG_TUI
 	case 1:
 		ui__exit(wait_for_ok);
 		break;
-
+#endif
 	default:
 		break;
 	}
diff --git a/tools/perf/util/Kbuild b/tools/perf/util/Kbuild
index 8fac37e..234937f 100644
--- a/tools/perf/util/Kbuild
+++ b/tools/perf/util/Kbuild
@@ -53,9 +53,10 @@ obj-$(CONFIG_LIBUNWIND) += unwind-libunwind.o
 obj-$(CONFIG_LIBDWARF_UNWIND) += unwind-libdw.o
 
 obj-$(CONFIG_LIBELF) += symbol-elf.o
-obj-$(CONFIG_LIBELF) += dwarf-aux.o
 obj-$(CONFIG_LIBELF) += probe-event.o
-obj-$(CONFIG_LIBELF) += probe-finder.o
+
+obj-$(CONFIG_LIBDWARF) += dwarf-aux.o
+obj-$(CONFIG_LIBDWARF) += probe-finder.o
 
 obj-$(CONFIG_LIBELF_MINIMAL) += symbol-minimal.o
 
@@ -76,7 +77,7 @@ obj-y += trace-event-parse.o
 obj-$(CONFIG_BUILTIN_SCRIPT) += trace-event-scripting.o
 obj-y += trace-event-read.o
 
-obj-y += scripting-engines/
+obj-$(CONFIG_BUILTIN_SCRIPT) += scripting-engines/
 
 define bison
 $(Q)echo '  BI      $@'
@@ -101,6 +102,8 @@ $(obj)/parse-events-flex.c: $(src)/parse-events.l $(obj)/parse-events-bison.c
 $(src)/parse-events-flex.o: $(src)/parse-events-flex.c
 $(src)/parse-events-bison.o: $(src)/parse-events-bison.c
 
+$(src)/parse-events.o: $(src)/parse-events-flex.o
+
 $(src)/pmu-bison.c: $(src)/pmu.y
 	$(call bison,perf_pmu_)
 
-- 
1.9.2

