Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab3IAKuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:50:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664Ab3IAKuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:50:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 24/24] perf tools: Overload pr_stat traceevent print function
Date: Sun,  1 Sep 2013 12:48:49 +0200
Message-Id: <1378032529-18498-25-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The traceevent lib uses pr_stat to display all standard
info. It's defined as __weak. Overloading it with perf
version plugged into perf output system logic.

Displaying the pr_stat stuff under '-v' option.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/debug.c | 16 ++++++++++++++++
 tools/perf/util/debug.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 399e74c..dc93bc3 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -33,6 +33,22 @@ int eprintf(int level, const char *fmt, ...)
 	return ret;
 }
 
+/*
+ * Overloading libtraceevent standard info print
+ * function, display with -v in perf.
+ */
+void pr_stat(const char *fmt, ...)
+{
+	va_list args;
+
+	if (verbose >= 1) {
+		va_start(args, fmt);
+		vfprintf(stderr, fmt, args);
+		fprintf(stderr, "\n");
+		va_end(args);
+	}
+}
+
 int dump_printf(const char *fmt, ...)
 {
 	va_list args;
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index efbd988..443694c 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -17,4 +17,6 @@ void trace_event(union perf_event *event);
 int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
 int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 
+void pr_stat(const char *fmt, ...);
+
 #endif	/* __PERF_DEBUG_H */
-- 
1.7.11.7

