Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaAPNib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:38:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38283 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaAPNi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:38:27 -0500
Date: Thu, 16 Jan 2014 05:38:03 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-e825e756f84eab0e68d7d6644c018c3412748406@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1389750340-15965-5-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of die() finally!!
Git-Commit-ID: e825e756f84eab0e68d7d6644c018c3412748406
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:38:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e825e756f84eab0e68d7d6644c018c3412748406
Gitweb:     http://git.kernel.org/tip/e825e756f84eab0e68d7d6644c018c3412748406
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 15 Jan 2014 10:45:27 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Jan 2014 15:10:36 -0300

tools lib traceevent: Get rid of die() finally!!

Now all of its users were gone. :)

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1389750340-15965-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-utils.h |  4 ----
 tools/lib/traceevent/parse-utils.c | 44 --------------------------------------
 2 files changed, 48 deletions(-)

diff --git a/tools/lib/traceevent/event-utils.h b/tools/lib/traceevent/event-utils.h
index e76c9ac..d1dc217 100644
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
index bba701c..eda07fa 100644
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
