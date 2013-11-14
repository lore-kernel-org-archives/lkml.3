Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab3KNUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:25:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36261 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab3KNUZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:25:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/10] perf trace: Tweak summary output
Date: Thu, 14 Nov 2013 17:25:06 -0300
Message-Id: <1384460715-23198-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384460715-23198-1-git-send-email-acme@infradead.org>
References: <1384460715-23198-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@kernel.org>

Tweak the summary output as suggested by Ingo Molnar:

  [penberg@localhost ~]$ perf trace -a --duration 10000 --summary -- sleep 1
  ^C
   Summary of events:

   Xorg (817), 148 events, 0.0%, 0.000 msec

     syscall            calls      min       avg       max      stddev
                                 (msec)    (msec)    (msec)        (%)
     --------------- -------- --------- --------- ---------     ------
     read                   7     0.002     0.004     0.011     32.00%
     rt_sigprocmask        40     0.001     0.001     0.002      1.31%
     ioctl                  6     0.002     0.003     0.005     19.45%
     writev                 7     0.004     0.018     0.059     43.76%
     select                 9     0.000    74.513   507.869     74.61%
     setitimer              4     0.001     0.002     0.002     10.08%

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Link: http://lkml.kernel.org/r/1384345308-24404-1-git-send-email-penberg@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6b230af940e2..8be17fc462ba 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2112,9 +2112,9 @@ static size_t thread__dump_stats(struct thread_trace *ttrace,
 
 	printed += fprintf(fp, "\n");
 
-	printed += fprintf(fp, "                                                    msec/call\n");
-	printed += fprintf(fp, "   syscall            calls      min      avg      max stddev\n");
-	printed += fprintf(fp, "   --------------- -------- -------- -------- -------- ------\n");
+	printed += fprintf(fp, "   syscall            calls      min       avg       max      stddev\n");
+	printed += fprintf(fp, "                               (msec)    (msec)    (msec)        (%%)\n");
+	printed += fprintf(fp, "   --------------- -------- --------- --------- ---------     ------\n");
 
 	/* each int_node is a syscall */
 	while (inode) {
@@ -2131,9 +2131,9 @@ static size_t thread__dump_stats(struct thread_trace *ttrace,
 
 			sc = &trace->syscalls.table[inode->i];
 			printed += fprintf(fp, "   %-15s", sc->name);
-			printed += fprintf(fp, " %8" PRIu64 " %8.3f %8.3f",
+			printed += fprintf(fp, " %8" PRIu64 " %9.3f %9.3f",
 					   n, min, avg);
-			printed += fprintf(fp, " %8.3f %6.2f\n", max, pct);
+			printed += fprintf(fp, " %9.3f %9.2f%%\n", max, pct);
 		}
 
 		inode = intlist__next(inode);
-- 
1.8.1.4

