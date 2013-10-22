Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3JVO3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:29:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53870 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab3JVO2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:28:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/26] perf tools: Fix bench/numa.c for 32-bit build
Date: Tue, 22 Oct 2013 11:28:23 -0300
Message-Id: <1382452114-1243-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382452114-1243-1-git-send-email-acme@infradead.org>
References: <1382452114-1243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

bench/numa.c: In function 'worker_thread':
bench/numa.c:1123:20: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
bench/numa.c:1171:6: error: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'u64' [-Werror=format]
cc1: all warnings being treated as errors

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1382099356-4918-13-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/numa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index 64fa01cfc34d..d4c83c60b9b2 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -1120,7 +1120,7 @@ static void *worker_thread(void *__tdata)
 		/* Check whether our max runtime timed out: */
 		if (g->p.nr_secs) {
 			timersub(&stop, &start0, &diff);
-			if (diff.tv_sec >= g->p.nr_secs) {
+			if ((u32)diff.tv_sec >= g->p.nr_secs) {
 				g->stop_work = true;
 				break;
 			}
@@ -1167,7 +1167,7 @@ static void *worker_thread(void *__tdata)
 			runtime_ns_max += diff.tv_usec * 1000;
 
 			if (details >= 0) {
-				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016lx]\n",
+				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016"PRIx64"]\n",
 					process_nr, thread_nr, runtime_ns_max / bytes_done, val);
 			}
 			fflush(stdout);
-- 
1.8.1.4

