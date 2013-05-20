Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab3ETO6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:58:54 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50374 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab3ETO6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:58:51 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/13] rcu: Remove rcu_preempt_note_context_switch()
Date: Mon, 20 May 2013 07:58:16 -0700
Message-Id: <1369061900-546-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520145751.GA32218@linux.vnet.ibm.com>
 <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-5406-0000-0000-000008A744AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

With the removal of CONFIG_TINY_PREEMPT_RCU, rcu_preempt_note_context_switch()
is now an empty function.  This commit therefore eliminates it by inlining it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/rcutiny.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 07b5aff..51230b6 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -68,10 +68,6 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 	call_rcu(head, func);
 }
 
-static inline void rcu_preempt_note_context_switch(void)
-{
-}
-
 static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
 	*delta_jiffies = ULONG_MAX;
@@ -81,7 +77,6 @@ static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 static inline void rcu_note_context_switch(int cpu)
 {
 	rcu_sched_qs(cpu);
-	rcu_preempt_note_context_switch();
 }
 
 /*
-- 
1.8.1.5

