Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196Ab3KMMV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 07:21:58 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:35913 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759029Ab3KMMVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 07:21:55 -0500
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf trace: Tweak summary output
Date: Wed, 13 Nov 2013 14:21:48 +0200
Message-Id: <1384345308-24404-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 tools/perf/builtin-trace.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2a6149e..943087f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2104,9 +2104,9 @@ static size_t thread__dump_stats(struct thread_trace *ttrace,
 
 	printed += fprintf(fp, "\n");
 
-	printed += fprintf(fp, "                                                    msec/call\n");
-	printed += fprintf(fp, "   syscall            calls      min      avg      max stddev\n");
-	printed += fprintf(fp, "   --------------- -------- -------- -------- -------- ------\n");
+	printed += fprintf(fp, "   syscall            calls      min       avg       max      stddev\n");
+	printed += fprintf(fp, "                               (msec)    (msec)    (msec)        (%%)\n");
+	printed += fprintf(fp, "   --------------- -------- --------- --------- ---------     ------\n");
 
 	/* each int_node is a syscall */
 	while (inode) {
@@ -2123,9 +2123,9 @@ static size_t thread__dump_stats(struct thread_trace *ttrace,
 
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
1.8.3.1

