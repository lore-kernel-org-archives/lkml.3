Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab3DLXtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:49:09 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35350 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab3DLXso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:48:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/12] rcu: Remove the CONFIG_TINY_RCU ifdefs in rcutiny.h
Date: Fri, 12 Apr 2013 16:48:27 -0700
Message-Id: <1365810511-24811-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1365810511-24811-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130412234810.GA23678@linux.vnet.ibm.com>
 <1365810511-24811-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041223-5518-0000-0000-00000D7F2D15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Now that CONFIG_TINY_PREEMPT_RCU is no more, this commit removes
the CONFIG_TINY_RCU ifdefs from include/linux/rcutiny.h in favor of
unconditionally compiling the CONFIG_TINY_RCU legs of those ifdefs.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutiny.h | 28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 592fad8..07b5aff 100644
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
@@ -49,17 +47,6 @@ static inline void rcu_barrier(void)
 	rcu_barrier_sched();  /* Only one CPU, so only one list of callbacks! */
 }
 
-#else /* #ifdef CONFIG_TINY_RCU */
-
-void synchronize_rcu_expedited(void);
-
-static inline void rcu_barrier(void)
-{
-	wait_rcu_gp(call_rcu);
-}
-
-#endif /* #else #ifdef CONFIG_TINY_RCU */
-
 static inline void synchronize_rcu_bh(void)
 {
 	synchronize_sched();
@@ -81,8 +68,6 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 	call_rcu(head, func);
 }
 
-#ifdef CONFIG_TINY_RCU
-
 static inline void rcu_preempt_note_context_switch(void)
 {
 }
@@ -93,19 +78,6 @@ static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 	return 0;
 }
 
-#else /* #ifdef CONFIG_TINY_RCU */
-
-void rcu_preempt_note_context_switch(void);
-int rcu_preempt_needs_cpu(void);
-
-static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
-{
-	*delta_jiffies = ULONG_MAX;
-	return rcu_preempt_needs_cpu();
-}
-
-#endif /* #else #ifdef CONFIG_TINY_RCU */
-
 static inline void rcu_note_context_switch(int cpu)
 {
 	rcu_sched_qs(cpu);
-- 
1.8.1.5

