Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab3ETO6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:58:38 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35911 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425Ab3ETO6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:58:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/13] rcu: Remove the CONFIG_TINY_RCU ifdefs in rcutiny.h
Date: Mon, 20 May 2013 07:58:15 -0700
Message-Id: <1369061900-546-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520145751.GA32218@linux.vnet.ibm.com>
 <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-5806-0000-0000-00002139A1E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Now that CONFIG_TINY_PREEMPT_RCU is no more, this commit removes
the CONFIG_TINY_RCU ifdefs from include/linux/rcutiny.h in favor of
unconditionally compiling the CONFIG_TINY_RCU legs of those ifdefs.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
[ paulmck: Moved removal of #else to "Remove TINY_PREEMPT_RCU" as
  suggested by Josh Triplett. ]
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/rcutiny.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index e756251..07b5aff 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -37,8 +37,6 @@ static inline void rcu_barrier_sched(void)
 	wait_rcu_gp(call_rcu_sched);
 }
 
-#ifdef CONFIG_TINY_RCU
-
 static inline void synchronize_rcu_expedited(void)
 {
 	synchronize_sched();	/* Only one CPU, so pretty fast anyway!!! */
@@ -49,8 +47,6 @@ static inline void rcu_barrier(void)
 	rcu_barrier_sched();  /* Only one CPU, so only one list of callbacks! */
 }
 
-#endif /* #ifdef CONFIG_TINY_RCU */
-
 static inline void synchronize_rcu_bh(void)
 {
 	synchronize_sched();
@@ -72,8 +68,6 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 	call_rcu(head, func);
 }
 
-#ifdef CONFIG_TINY_RCU
-
 static inline void rcu_preempt_note_context_switch(void)
 {
 }
@@ -84,8 +78,6 @@ static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 	return 0;
 }
 
-#endif /* #ifdef CONFIG_TINY_RCU */
-
 static inline void rcu_note_context_switch(int cpu)
 {
 	rcu_sched_qs(cpu);
-- 
1.8.1.5

