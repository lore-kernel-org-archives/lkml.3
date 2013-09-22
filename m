Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab3IVIth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 04:49:37 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:53806 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab3IVItf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 04:49:35 -0400
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@redhat.com
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: [PATCH] perf: fix two warning in bench/numa
Date: Sun, 22 Sep 2013 16:49:24 +0800
Message-Id: <1379839764-9245-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092208-3864-0000-0000-00000A2EDB0B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There two warnings in bench/numa, when buiding this on 32-bit machine. 

The warning output is attached:

bench/numa.c:1113:20: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
bench/numa.c:1161:6: error: format ‘%lx’ expects argument of t'long unsigned int’, but argument 5 has type ‘u64’ [-Werror=format]

This patch fixs these two warnings.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
---
 tools/perf/bench/numa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index 30d1c32..a73c4ed 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -1110,7 +1110,7 @@ static void *worker_thread(void *__tdata)
 		/* Check whether our max runtime timed out: */
 		if (g->p.nr_secs) {
 			timersub(&stop, &start0, &diff);
-			if (diff.tv_sec >= g->p.nr_secs) {
+			if (diff.tv_sec >= (time_t)g->p.nr_secs) {
 				g->stop_work = true;
 				break;
 			}
@@ -1157,7 +1157,7 @@ static void *worker_thread(void *__tdata)
 			runtime_ns_max += diff.tv_usec * 1000;
 
 			if (details >= 0) {
-				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016lx]\n",
+				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016"PRIu64"]\n",
 					process_nr, thread_nr, runtime_ns_max / bytes_done, val);
 			}
 			fflush(stdout);
-- 
1.7.5.4

