Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3FOKPa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 06:15:30 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:49156 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab3FOKP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 06:15:29 -0400
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: acme@ghostprotocols.net
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
        Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH] perf: fix bench numa compilation
Date: Sat, 15 Jun 2013 12:15:14 +0200
Message-Id: <1371291314-20322-1-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bench/numa.c: In function ‘worker_thread’:
bench/numa.c:1113:20: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
    if (diff.tv_sec >= g->p.nr_secs) {
                    ^
bench/numa.c:1161:6: error: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 5 has type ‘u64’ [-Werror=format=]
      process_nr, thread_nr, runtime_ns_max / bytes_done, val);
      ^

Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
---
 tools/perf/bench/numa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Diffed against 3.9.6 but should apply cleanly to latest git

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index 30d1c32..90ef4cc 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -1110,7 +1110,7 @@ static void *worker_thread(void *__tdata)
 		/* Check whether our max runtime timed out: */
 		if (g->p.nr_secs) {
 			timersub(&stop, &start0, &diff);
-			if (diff.tv_sec >= g->p.nr_secs) {
+			if (diff.tv_sec >= (long int)g->p.nr_secs) {
 				g->stop_work = true;
 				break;
 			}
@@ -1157,7 +1157,7 @@ static void *worker_thread(void *__tdata)
 			runtime_ns_max += diff.tv_usec * 1000;
 
 			if (details >= 0) {
-				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016lx]\n",
+				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016llx]\n",
 					process_nr, thread_nr, runtime_ns_max / bytes_done, val);
 			}
 			fflush(stdout);
-- 
1.8.3.1

