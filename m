Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbaFPSPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:15:33 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:38603 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770AbaFPSP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:15:28 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: acme@kernel.org, jolsa@kernel.org
Cc: mitake@dcl.info.waseda.ac.jp, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] perf bench: futex: Use global --repeat option
Date: Mon, 16 Jun 2014 11:14:23 -0700
Message-Id: <1402942467-10671-6-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option is available through perf-bench, use it instead
and free the local option.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/bench/futex-requeue.c | 10 +---------
 tools/perf/bench/futex-wake.c    | 12 ++----------
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/tools/perf/bench/futex-requeue.c b/tools/perf/bench/futex-requeue.c
index a1625587..732403b 100644
--- a/tools/perf/bench/futex-requeue.c
+++ b/tools/perf/bench/futex-requeue.c
@@ -29,13 +29,6 @@ static u_int32_t futex1 = 0, futex2 = 0;
  */
 static unsigned int nrequeue = 1;
 
-/*
- * There can be significant variance from run to run,
- * the more repeats, the more exact the overall avg and
- * the better idea of the futex latency.
- */
-static unsigned int repeat = 10;
-
 static pthread_t *worker;
 static bool done = 0, silent = 0;
 static pthread_mutex_t thread_lock;
@@ -46,7 +39,6 @@ static unsigned int ncpus, threads_starting, nthreads = 0;
 static const struct option options[] = {
 	OPT_UINTEGER('t', "threads",  &nthreads, "Specify amount of threads"),
 	OPT_UINTEGER('q', "nrequeue", &nrequeue, "Specify amount of threads to requeue at once"),
-	OPT_UINTEGER('r', "repeat",   &repeat,   "Specify amount of times to repeat the run"),
 	OPT_BOOLEAN( 's', "silent",   &silent,   "Silent mode: do not display data/details"),
 	OPT_END()
 };
@@ -146,7 +138,7 @@ int bench_futex_requeue(int argc, const char **argv,
 	pthread_cond_init(&thread_parent, NULL);
 	pthread_cond_init(&thread_worker, NULL);
 
-	for (j = 0; j < repeat && !done; j++) {
+	for (j = 0; j < bench_repeat && !done; j++) {
 		unsigned int nrequeued = 0;
 		struct timeval start, end, runtime;
 
diff --git a/tools/perf/bench/futex-wake.c b/tools/perf/bench/futex-wake.c
index d096169..50022cb 100644
--- a/tools/perf/bench/futex-wake.c
+++ b/tools/perf/bench/futex-wake.c
@@ -30,15 +30,8 @@ static u_int32_t futex1 = 0;
  */
 static unsigned int nwakes = 1;
 
-/*
- * There can be significant variance from run to run,
- * the more repeats, the more exact the overall avg and
- * the better idea of the futex latency.
- */
-static unsigned int repeat = 10;
-
 pthread_t *worker;
-static bool done = 0, silent = 0;
+static bool done = false, silent = false;
 static pthread_mutex_t thread_lock;
 static pthread_cond_t thread_parent, thread_worker;
 static struct stats waketime_stats, wakeup_stats;
@@ -47,7 +40,6 @@ static unsigned int ncpus, threads_starting, nthreads = 0;
 static const struct option options[] = {
 	OPT_UINTEGER('t', "threads", &nthreads, "Specify amount of threads"),
 	OPT_UINTEGER('w', "nwakes",  &nwakes,   "Specify amount of threads to wake at once"),
-	OPT_UINTEGER('r', "repeat",  &repeat,   "Specify amount of times to repeat the run"),
 	OPT_BOOLEAN( 's', "silent",  &silent,   "Silent mode: do not display data/details"),
 	OPT_END()
 };
@@ -149,7 +141,7 @@ int bench_futex_wake(int argc, const char **argv,
 	pthread_cond_init(&thread_parent, NULL);
 	pthread_cond_init(&thread_worker, NULL);
 
-	for (j = 0; j < repeat && !done; j++) {
+	for (j = 0; j < bench_repeat && !done; j++) {
 		unsigned int nwoken = 0;
 		struct timeval start, end, runtime;
 
-- 
1.8.1.4

