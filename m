Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab3AXSg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:36:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60846 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab3AXSgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:36:55 -0500
Date: Thu, 24 Jan 2013 10:36:23 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-752914208ada0d9ae0a6b3bf2906d43f3605832f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, penberg@kernel.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        rostedt@goodmis.org, ak@linux.intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, penberg@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        rostedt@goodmis.org, dsahern@gmail.com, ak@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <1352911664-24620-2-git-send-email-namhyung@kernel.org>
References: <1352911664-24620-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Always compile error printing code
Git-Commit-ID: 752914208ada0d9ae0a6b3bf2906d43f3605832f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:36:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  752914208ada0d9ae0a6b3bf2906d43f3605832f
Gitweb:     http://git.kernel.org/tip/752914208ada0d9ae0a6b3bf2906d43f3605832f
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 15 Nov 2012 01:47:40 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:04 -0300

perf ui: Always compile error printing code

It is used everywhere so always build it regardless of ui engine.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1352911664-24620-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile     | 14 +++++---------
 tools/perf/ui/util.c    | 10 ++++++++++
 tools/perf/util/debug.c | 22 ----------------------
 tools/perf/util/debug.h | 33 ++-------------------------------
 4 files changed, 17 insertions(+), 62 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 891bc77..8fca560 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -378,8 +378,11 @@ LIB_H += util/rblist.h
 LIB_H += util/intlist.h
 LIB_H += util/perf_regs.h
 LIB_H += util/unwind.h
-LIB_H += ui/helpline.h
 LIB_H += util/vdso.h
+LIB_H += ui/helpline.h
+LIB_H += ui/progress.h
+LIB_H += ui/util.h
+LIB_H += ui/ui.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -453,6 +456,7 @@ LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
 LIB_OBJS += $(OUTPUT)ui/progress.o
+LIB_OBJS += $(OUTPUT)ui/util.o
 LIB_OBJS += $(OUTPUT)ui/hist.o
 LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
 
@@ -646,7 +650,6 @@ ifndef NO_NEWT
 		LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/map.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
-		LIB_OBJS += $(OUTPUT)ui/util.o
 		LIB_OBJS += $(OUTPUT)ui/tui/setup.o
 		LIB_OBJS += $(OUTPUT)ui/tui/util.o
 		LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
@@ -655,9 +658,6 @@ ifndef NO_NEWT
 		LIB_H += ui/browsers/map.h
 		LIB_H += ui/keysyms.h
 		LIB_H += ui/libslang.h
-		LIB_H += ui/progress.h
-		LIB_H += ui/util.h
-		LIB_H += ui/ui.h
 	endif
 endif
 
@@ -677,10 +677,6 @@ ifndef NO_GTK2
 		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
-		# Make sure that it'd be included only once.
-		ifeq ($(findstring -DNEWT_SUPPORT,$(BASIC_CFLAGS)),)
-			LIB_OBJS += $(OUTPUT)ui/util.o
-		endif
 	endif
 endif
 
diff --git a/tools/perf/ui/util.c b/tools/perf/ui/util.c
index 4f98977..3014a7c 100644
--- a/tools/perf/ui/util.c
+++ b/tools/perf/ui/util.c
@@ -52,6 +52,16 @@ int ui__warning(const char *format, ...)
 	return ret;
 }
 
+int ui__error_paranoid(void)
+{
+	return ui__error("Permission error - are you root?\n"
+		    "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
+		    " -1 - Not paranoid at all\n"
+		    "  0 - Disallow raw tracepoint access for unpriv\n"
+		    "  1 - Disallow cpu events for unpriv\n"
+		    "  2 - Disallow kernel profiling for unpriv\n");
+}
+
 
 /**
  * perf_error__register - Register error logging functions
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 03f830b..39861a2a 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -49,28 +49,6 @@ int dump_printf(const char *fmt, ...)
 	return ret;
 }
 
-#if !defined(NEWT_SUPPORT) && !defined(GTK2_SUPPORT)
-int ui__warning(const char *format, ...)
-{
-	va_list args;
-
-	va_start(args, format);
-	vfprintf(stderr, format, args);
-	va_end(args);
-	return 0;
-}
-#endif
-
-int ui__error_paranoid(void)
-{
-	return ui__error("Permission error - are you root?\n"
-		    "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
-		    " -1 - Not paranoid at all\n"
-		    "  0 - Disallow raw tracepoint access for unpriv\n"
-		    "  1 - Disallow cpu events for unpriv\n"
-		    "  2 - Disallow kernel profiling for unpriv\n");
-}
-
 void trace_event(union perf_event *event)
 {
 	unsigned char *raw_event = (void *)event;
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 83e8d23..6e2667f 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -5,6 +5,8 @@
 #include <stdbool.h>
 #include "event.h"
 #include "../ui/helpline.h"
+#include "../ui/progress.h"
+#include "../ui/util.h"
 
 extern int verbose;
 extern bool quiet, dump_trace;
@@ -12,38 +14,7 @@ extern bool quiet, dump_trace;
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void trace_event(union perf_event *event);
 
-struct ui_progress;
-struct perf_error_ops;
-
-#if defined(NEWT_SUPPORT) || defined(GTK2_SUPPORT)
-
-#include "../ui/progress.h"
 int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
-#include "../ui/util.h"
-
-#else
-
-static inline void ui_progress__update(u64 curr __maybe_unused,
-				       u64 total __maybe_unused,
-				       const char *title __maybe_unused) {}
-static inline void ui_progress__finish(void) {}
-
-#define ui__error(format, arg...) ui__warning(format, ##arg)
-
-static inline int
-perf_error__register(struct perf_error_ops *eops __maybe_unused)
-{
-	return 0;
-}
-
-static inline int
-perf_error__unregister(struct perf_error_ops *eops __maybe_unused)
-{
-	return 0;
-}
-
-#endif /* NEWT_SUPPORT || GTK2_SUPPORT */
-
 int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 int ui__error_paranoid(void);
 
