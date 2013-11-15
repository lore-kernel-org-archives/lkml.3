Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3KOHZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:25:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50296 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3KOHYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:24:51 -0500
Date: Thu, 14 Nov 2013 23:24:32 -0800
From: tip-bot for Pekka Enberg <tipbot@zytor.com>
Message-ID: <tip-27a778b512e002d856952b4f01842ba4d34bc3d1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, mingo@kernel.org, penberg@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, penberg@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1384345308-24404-1-git-send-email-penberg@kernel.org>
References: <1384345308-24404-1-git-send-email-penberg@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace: Tweak summary output
Git-Commit-ID: 27a778b512e002d856952b4f01842ba4d34bc3d1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 14 Nov 2013 23:24:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27a778b512e002d856952b4f01842ba4d34bc3d1
Gitweb:     http://git.kernel.org/tip/27a778b512e002d856952b4f01842ba4d34bc3d1
Author:     Pekka Enberg <penberg@kernel.org>
AuthorDate: Wed, 13 Nov 2013 14:21:48 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Nov 2013 15:59:20 -0300

perf trace: Tweak summary output

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
index 6b230af..8be17fc 100644
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
