Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab3ETPBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:01:11 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59447 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab3ETO6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:58:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/13] rcu: Remove check_cpu_stall_preempt()
Date: Mon, 20 May 2013 07:58:14 -0700
Message-Id: <1369061900-546-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520145751.GA32218@linux.vnet.ibm.com>
 <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-7182-0000-0000-000006CA6AF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

With the removal of CONFIG_TINY_PREEMPT_RCU, check_cpu_stall_preempt()
is now an empty function.  This commit therefore eliminates it by
inlining it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutiny_plugin.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 36fd83c..bac3a6e 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -82,8 +82,6 @@ static void check_cpu_stall(struct rcu_ctrlblk *rcp)
 		rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
 }
 
-static void check_cpu_stall_preempt(void);
-
 #endif /* #ifdef CONFIG_RCU_TRACE */
 
 static void reset_cpu_stall_ticks(struct rcu_ctrlblk *rcp)
@@ -99,7 +97,6 @@ static void check_cpu_stalls(void)
 {
 	RCU_TRACE(check_cpu_stall(&rcu_bh_ctrlblk));
 	RCU_TRACE(check_cpu_stall(&rcu_sched_ctrlblk));
-	RCU_TRACE(check_cpu_stall_preempt());
 }
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -182,8 +179,4 @@ MODULE_AUTHOR("Paul E. McKenney");
 MODULE_DESCRIPTION("Read-Copy Update tracing for tiny implementation");
 MODULE_LICENSE("GPL");
 
-static void check_cpu_stall_preempt(void)
-{
-}
-
 #endif /* #ifdef CONFIG_RCU_TRACE */
-- 
1.8.1.5

