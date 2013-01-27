Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab3A0AQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:16:49 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:52100 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab3A0APj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:15:39 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/10] rcu: Remove unused code originally used for context tracking
Date: Sat, 26 Jan 2013 16:15:10 -0800
Message-Id: <1359245712-3843-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1359245712-3843-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130127001454.GA2682@linux.vnet.ibm.com>
 <1359245712-3843-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012700-5518-0000-0000-00000B0B3833
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zhong <zhong@linux.vnet.ibm.com>

As context tracking subsystem evolved, it stopped using ignore_user_qs
and in_user defined in the rcu_dynticks structure.  This commit therefore
removes them.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/rcutree.c |    3 ---
 kernel/rcutree.h |    4 ----
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d78ba60..8a13c8e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2719,9 +2719,6 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
 	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE);
 	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
-#ifdef CONFIG_RCU_USER_QS
-	WARN_ON_ONCE(rdp->dynticks->in_user);
-#endif
 	rdp->cpu = cpu;
 	rdp->rsp = rsp;
 	rcu_boot_init_nocb_percpu_data(rdp);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 4b69291..6f21f2e 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -102,10 +102,6 @@ struct rcu_dynticks {
 				    /* idle-period nonlazy_posted snapshot. */
 	int tick_nohz_enabled_snap; /* Previously seen value from sysfs. */
 #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
-#ifdef CONFIG_RCU_USER_QS
-	bool ignore_user_qs;	    /* Treat userspace as extended QS or not */
-	bool in_user;		    /* Is the CPU in userland from RCU POV? */
-#endif
 };
 
 /* RCU's kthread states for tracing. */
-- 
1.7.8

