Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab3JRMa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:30:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:2346 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab3JRMay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:30:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,522,1378882800"; 
   d="scan'208";a="394936501"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 12/19] perf tools: Fix bench/numa.c for 32-bit build
Date: Fri, 18 Oct 2013 15:29:09 +0300
Message-Id: <1382099356-4918-13-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bench/numa.c: In function 'worker_thread':
bench/numa.c:1123:20: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
bench/numa.c:1171:6: error: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'u64' [-Werror=format]
cc1: all warnings being treated as errors

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/bench/numa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index 64fa01c..d4c83c6 100644
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
1.7.11.7

