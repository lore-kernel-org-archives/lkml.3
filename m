Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934924AbaGRE3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:29:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33382 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933597AbaGRE2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:28:04 -0400
Date: Thu, 17 Jul 2014 21:27:44 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-84f5d36f486609277801e827241396334185d11c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1405374411-29012-3-git-send-email-jolsa@kernel.org>
References: <1405374411-29012-3-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Move pr_* debug macros into debug object
Git-Commit-ID: 84f5d36f486609277801e827241396334185d11c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84f5d36f486609277801e827241396334185d11c
Gitweb:     http://git.kernel.org/tip/84f5d36f486609277801e827241396334185d11c
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 14 Jul 2014 23:46:48 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Jul 2014 12:58:39 -0300

perf tools: Move pr_* debug macros into debug object

Moving pr_* debug macros to have it with in same object as debug
variables, becase we will change them to use verbose variable in next
patch.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1405374411-29012-3-git-send-email-jolsa@kernel.org
[ Add missing debug.h include in python scripting glue and in the libdw unwind lib ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/x86/tests/dwarf-unwind.c            |  1 +
 tools/perf/arch/x86/util/unwind-libunwind.c         |  1 +
 tools/perf/builtin-evlist.c                         |  1 +
 tools/perf/builtin-help.c                           |  1 +
 tools/perf/builtin-timechart.c                      |  1 +
 tools/perf/tests/dso-data.c                         |  1 +
 tools/perf/tests/evsel-roundtrip-name.c             |  1 +
 tools/perf/tests/evsel-tp-sched.c                   |  1 +
 tools/perf/tests/open-syscall-tp-fields.c           |  1 +
 tools/perf/tests/parse-events.c                     |  1 +
 tools/perf/tests/parse-no-sample-id-all.c           |  1 +
 tools/perf/tests/sample-parsing.c                   |  1 +
 tools/perf/tests/thread-mg-share.c                  |  1 +
 tools/perf/util/data.c                              |  1 +
 tools/perf/util/debug.h                             | 20 ++++++++++++++++++++
 tools/perf/util/include/linux/kernel.h              | 21 ---------------------
 tools/perf/util/pstack.c                            |  1 +
 .../perf/util/scripting-engines/trace-event-perl.c  |  1 +
 .../util/scripting-engines/trace-event-python.c     |  1 +
 tools/perf/util/trace-event-info.c                  |  1 +
 tools/perf/util/trace-event-read.c                  |  1 +
 tools/perf/util/unwind-libdw.c                      |  1 +
 tools/perf/util/unwind-libunwind.c                  |  1 +
 tools/perf/util/util.c                              |  1 +
 tools/perf/util/vdso.c                              |  1 +
 25 files changed, 43 insertions(+), 21 deletions(-)

diff --git a/tools/perf/arch/x86/tests/dwarf-unwind.c b/tools/perf/arch/x86/tests/dwarf-unwind.c
index 9f89f89..d8bbf7a 100644
--- a/tools/perf/arch/x86/tests/dwarf-unwind.c
+++ b/tools/perf/arch/x86/tests/dwarf-unwind.c
@@ -3,6 +3,7 @@
 #include "thread.h"
 #include "map.h"
 #include "event.h"
+#include "debug.h"
 #include "tests/tests.h"
 
 #define STACK_SIZE 8192
diff --git a/tools/perf/arch/x86/util/unwind-libunwind.c b/tools/perf/arch/x86/util/unwind-libunwind.c
index 3261f68..db25e93 100644
--- a/tools/perf/arch/x86/util/unwind-libunwind.c
+++ b/tools/perf/arch/x86/util/unwind-libunwind.c
@@ -3,6 +3,7 @@
 #include <libunwind.h>
 #include "perf_regs.h"
 #include "../../util/unwind.h"
+#include "../../util/debug.h"
 
 #ifdef HAVE_ARCH_X86_64_SUPPORT
 int libunwind__arch_reg_id(int regnum)
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index c99e0de..66e12f5 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -15,6 +15,7 @@
 #include "util/parse-options.h"
 #include "util/session.h"
 #include "util/data.h"
+#include "util/debug.h"
 
 static int __cmd_evlist(const char *file_name, struct perf_attr_details *details)
 {
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 178b88a..0384d93 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -11,6 +11,7 @@
 #include "util/parse-options.h"
 #include "util/run-command.h"
 #include "util/help.h"
+#include "util/debug.h"
 
 static struct man_viewer_list {
 	struct man_viewer_list *next;
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 04c9c53..2f1a522 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -37,6 +37,7 @@
 #include "util/svghelper.h"
 #include "util/tool.h"
 #include "util/data.h"
+#include "util/debug.h"
 
 #define SUPPORT_OLD_POWER_EVENTS 1
 #define PWR_EVENT_EXIT -1
diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index 630808c..caaf37f 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -10,6 +10,7 @@
 #include "machine.h"
 #include "symbol.h"
 #include "tests.h"
+#include "debug.h"
 
 static char *test_file(int size)
 {
diff --git a/tools/perf/tests/evsel-roundtrip-name.c b/tools/perf/tests/evsel-roundtrip-name.c
index 465cdbc..b8d8341 100644
--- a/tools/perf/tests/evsel-roundtrip-name.c
+++ b/tools/perf/tests/evsel-roundtrip-name.c
@@ -2,6 +2,7 @@
 #include "evsel.h"
 #include "parse-events.h"
 #include "tests.h"
+#include "debug.h"
 
 static int perf_evsel__roundtrip_cache_name_test(void)
 {
diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
index 35d7fdb..5216242 100644
--- a/tools/perf/tests/evsel-tp-sched.c
+++ b/tools/perf/tests/evsel-tp-sched.c
@@ -1,6 +1,7 @@
 #include <traceevent/event-parse.h>
 #include "evsel.h"
 #include "tests.h"
+#include "debug.h"
 
 static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
 				  int size, bool should_be_signed)
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index c505ef2..0785b64 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -3,6 +3,7 @@
 #include "evsel.h"
 #include "thread_map.h"
 #include "tests.h"
+#include "debug.h"
 
 int test__syscall_open_tp_fields(void)
 {
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index deba669..5941927 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -5,6 +5,7 @@
 #include <api/fs/fs.h>
 #include <api/fs/debugfs.h>
 #include "tests.h"
+#include "debug.h"
 #include <linux/hw_breakpoint.h>
 
 #define PERF_TP_SAMPLE_TYPE (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | \
diff --git a/tools/perf/tests/parse-no-sample-id-all.c b/tools/perf/tests/parse-no-sample-id-all.c
index 905019f..2c63ea6 100644
--- a/tools/perf/tests/parse-no-sample-id-all.c
+++ b/tools/perf/tests/parse-no-sample-id-all.c
@@ -7,6 +7,7 @@
 #include "evlist.h"
 #include "header.h"
 #include "util.h"
+#include "debug.h"
 
 static int process_event(struct perf_evlist **pevlist, union perf_event *event)
 {
diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 7ae8d17..ca292f9 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -4,6 +4,7 @@
 #include "util.h"
 #include "event.h"
 #include "evsel.h"
+#include "debug.h"
 
 #include "tests.h"
 
diff --git a/tools/perf/tests/thread-mg-share.c b/tools/perf/tests/thread-mg-share.c
index 2b2e0db..b028499 100644
--- a/tools/perf/tests/thread-mg-share.c
+++ b/tools/perf/tests/thread-mg-share.c
@@ -2,6 +2,7 @@
 #include "machine.h"
 #include "thread.h"
 #include "map.h"
+#include "debug.h"
 
 int test__thread_mg_share(void)
 {
diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index ee370a7f..29d720c 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -7,6 +7,7 @@
 
 #include "data.h"
 #include "util.h"
+#include "debug.h"
 
 static bool check_pipe(struct perf_data_file *file)
 {
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 443694c..8a8ceb3 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -11,6 +11,24 @@
 extern int verbose;
 extern bool quiet, dump_trace;
 
+#ifndef pr_fmt
+#define pr_fmt(fmt) fmt
+#endif
+
+#define pr_err(fmt, ...) \
+	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning(fmt, ...) \
+	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info(fmt, ...) \
+	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug(fmt, ...) \
+	eprintf(1, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debugN(n, fmt, ...) \
+	eprintf(n, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug2(fmt, ...) pr_debugN(2, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug3(fmt, ...) pr_debugN(3, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug4(fmt, ...) pr_debugN(4, pr_fmt(fmt), ##__VA_ARGS__)
+
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void trace_event(union perf_event *event);
 
@@ -19,4 +37,6 @@ int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 
 void pr_stat(const char *fmt, ...);
 
+int eprintf(int level, const char *fmt, ...) __attribute__((format(printf, 2, 3)));
+
 #endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index 9844c31..09e8e7a 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -94,27 +94,6 @@ static inline int scnprintf(char * buf, size_t size, const char * fmt, ...)
 	return (i >= ssize) ? (ssize - 1) : i;
 }
 
-int eprintf(int level,
-	    const char *fmt, ...) __attribute__((format(printf, 2, 3)));
-
-#ifndef pr_fmt
-#define pr_fmt(fmt) fmt
-#endif
-
-#define pr_err(fmt, ...) \
-	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning(fmt, ...) \
-	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info(fmt, ...) \
-	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_debug(fmt, ...) \
-	eprintf(1, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_debugN(n, fmt, ...) \
-	eprintf(n, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_debug2(fmt, ...) pr_debugN(2, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_debug3(fmt, ...) pr_debugN(3, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_debug4(fmt, ...) pr_debugN(4, pr_fmt(fmt), ##__VA_ARGS__)
-
 /*
  * This looks more complex than it should be. But we need to
  * get the type for the ~ right in round_down (it needs to be
diff --git a/tools/perf/util/pstack.c b/tools/perf/util/pstack.c
index daa17ae..a126e6c 100644
--- a/tools/perf/util/pstack.c
+++ b/tools/perf/util/pstack.c
@@ -6,6 +6,7 @@
 
 #include "util.h"
 #include "pstack.h"
+#include "debug.h"
 #include <linux/kernel.h>
 #include <stdlib.h>
 
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index af7da56..b2dba9c 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -34,6 +34,7 @@
 #include "../event.h"
 #include "../trace-event.h"
 #include "../evsel.h"
+#include "../debug.h"
 
 void boot_Perf__Trace__Context(pTHX_ CV *cv);
 void boot_DynaLoader(pTHX_ CV *cv);
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index b366b48..cbce254 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -27,6 +27,7 @@
 #include <errno.h>
 
 #include "../../perf.h"
+#include "../debug.h"
 #include "../evsel.h"
 #include "../util.h"
 #include "../event.h"
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index c3bba88..eb72716 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -40,6 +40,7 @@
 #include "trace-event.h"
 #include <api/fs/debugfs.h>
 #include "evsel.h"
+#include "debug.h"
 
 #define VERSION "0.5"
 
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index e113e18..ea3fd7f 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -36,6 +36,7 @@
 #include "../perf.h"
 #include "util.h"
 #include "trace-event.h"
+#include "debug.h"
 
 static int input_fd;
 
diff --git a/tools/perf/util/unwind-libdw.c b/tools/perf/util/unwind-libdw.c
index 5ec80a5..7419768 100644
--- a/tools/perf/util/unwind-libdw.c
+++ b/tools/perf/util/unwind-libdw.c
@@ -3,6 +3,7 @@
 #include <elfutils/libdwfl.h>
 #include <inttypes.h>
 #include <errno.h>
+#include "debug.h"
 #include "unwind.h"
 #include "unwind-libdw.h"
 #include "machine.h"
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 25578b9..92b56db 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -30,6 +30,7 @@
 #include "unwind.h"
 #include "symbol.h"
 #include "util.h"
+#include "debug.h"
 
 extern int
 UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index e4132ae..e52e746 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,5 +1,6 @@
 #include "../perf.h"
 #include "util.h"
+#include "debug.h"
 #include <api/fs/fs.h>
 #include <sys/mman.h>
 #ifdef HAVE_BACKTRACE_SUPPORT
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index 0ddb3b8..2905824 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -12,6 +12,7 @@
 #include "util.h"
 #include "symbol.h"
 #include "linux/string.h"
+#include "debug.h"
 
 static bool vdso_found;
 static char vdso_file[] = "/tmp/perf-vdso.so-XXXXXX";
