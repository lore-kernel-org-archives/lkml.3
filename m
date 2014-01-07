Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaAGDAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:00:50 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52535 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132AbaAGDAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:00:20 -0500
X-AuditID: 9c930179-b7c89ae000006438-cc-52cb6dc155fc
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/5] tools lib traceevent: Get rid of die() finally!!
Date: Tue,  7 Jan 2014 12:00:12 +0900
Message-Id: <1389063612-18173-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389063612-18173-1-git-send-email-namhyung@kernel.org>
References: <1389063612-18173-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now all of its users were gone. :)

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-utils.h |  4 ----
 tools/lib/traceevent/parse-utils.c | 44 --------------------------------------
 2 files changed, 48 deletions(-)

diff --git a/tools/lib/traceevent/event-utils.h b/tools/lib/traceevent/event-utils.h
index 5dc0aec5ab50..496dba9fe984 100644
--- a/tools/lib/traceevent/event-utils.h
+++ b/tools/lib/traceevent/event-utils.h
@@ -23,18 +23,14 @@
 #include <ctype.h>
 
 /* Can be overridden */
-void die(const char *fmt, ...);
-void *malloc_or_die(unsigned int size);
 void warning(const char *fmt, ...);
 void pr_stat(const char *fmt, ...);
 void vpr_stat(const char *fmt, va_list ap);
 
 /* Always available */
-void __die(const char *fmt, ...);
 void __warning(const char *fmt, ...);
 void __pr_stat(const char *fmt, ...);
 
-void __vdie(const char *fmt, ...);
 void __vwarning(const char *fmt, ...);
 void __vpr_stat(const char *fmt, ...);
 
diff --git a/tools/lib/traceevent/parse-utils.c b/tools/lib/traceevent/parse-utils.c
index bba701cf10e6..eda07fa31dca 100644
--- a/tools/lib/traceevent/parse-utils.c
+++ b/tools/lib/traceevent/parse-utils.c
@@ -25,40 +25,6 @@
 
 #define __weak __attribute__((weak))
 
-void __vdie(const char *fmt, va_list ap)
-{
-	int ret = errno;
-
-	if (errno)
-		perror("trace-cmd");
-	else
-		ret = -1;
-
-	fprintf(stderr, "  ");
-	vfprintf(stderr, fmt, ap);
-
-	fprintf(stderr, "\n");
-	exit(ret);
-}
-
-void __die(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	__vdie(fmt, ap);
-	va_end(ap);
-}
-
-void __weak die(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	__vdie(fmt, ap);
-	va_end(ap);
-}
-
 void __vwarning(const char *fmt, va_list ap)
 {
 	if (errno)
@@ -117,13 +83,3 @@ void __weak pr_stat(const char *fmt, ...)
 	__vpr_stat(fmt, ap);
 	va_end(ap);
 }
-
-void __weak *malloc_or_die(unsigned int size)
-{
-	void *data;
-
-	data = malloc(size);
-	if (!data)
-		die("malloc");
-	return data;
-}
-- 
1.7.11.7

