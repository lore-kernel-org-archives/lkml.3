Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab3ETO6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:58:51 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46094 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab3ETO6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:58:46 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/13] rcu: Remove show_tiny_preempt_stats()
Date: Mon, 20 May 2013 07:58:09 -0700
Message-Id: <1369061900-546-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520145751.GA32218@linux.vnet.ibm.com>
 <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-3620-0000-0000-0000029426F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

With the removal of CONFIG_TINY_PREEMPT_RCU, show_tiny_preempt_stats()
is now an empty function.  This commit therefore eliminates it by
inlining it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutiny_plugin.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 29a4dd7..cf0bc22 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -102,18 +102,6 @@ static void check_cpu_stalls(void)
 	RCU_TRACE(check_cpu_stall_preempt());
 }
 
-#ifdef CONFIG_RCU_TRACE
-
-/*
- * Because preemptible RCU does not exist, it is not necessary to
- * dump out its statistics.
- */
-static void show_tiny_preempt_stats(struct seq_file *m)
-{
-}
-
-#endif /* #ifdef CONFIG_RCU_TRACE */
-
 /*
  * Because preemptible RCU does not exist, it never has any callbacks
  * to check.
@@ -202,7 +190,6 @@ static void rcu_trace_sub_qlen(struct rcu_ctrlblk *rcp, int n)
  */
 static int show_tiny_stats(struct seq_file *m, void *unused)
 {
-	show_tiny_preempt_stats(m);
 	seq_printf(m, "rcu_sched: qlen: %ld\n", rcu_sched_ctrlblk.qlen);
 	seq_printf(m, "rcu_bh: qlen: %ld\n", rcu_bh_ctrlblk.qlen);
 	return 0;
-- 
1.8.1.5

