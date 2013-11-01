Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab3KAO44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:56:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53241 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab3KAO4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:56:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Wei Yang <weiyang@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf bench: Fix two warnings
Date: Fri,  1 Nov 2013 11:56:46 -0300
Message-Id: <1383317807-25062-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383317807-25062-1-git-send-email-acme@infradead.org>
References: <1383317807-25062-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yang <weiyang@linux.vnet.ibm.com>

There are two warnings in bench/numa, when building this on 32-bit
machine.

The warning output is attached:

bench/numa.c:1113:20: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
bench/numa.c:1161:6: error: format ‘%lx’ expects argument of t'long unsigned int’, but argument 5 has type ‘u64’ [-Werror=format]

This patch fixes these two warnings.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Link: http://lkml.kernel.org/r/1379839764-9245-1-git-send-email-weiyang@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/numa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index 30d1c3225b46..a73c4ed8af17 100644
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
1.8.1.4

