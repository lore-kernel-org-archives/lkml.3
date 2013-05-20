Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3ETO6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:58:35 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42808 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549Ab3ETO6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:58:34 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/13] rcu: Remove rcu_preempt_process_callbacks()
Date: Mon, 20 May 2013 07:58:12 -0700
Message-Id: <1369061900-546-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520145751.GA32218@linux.vnet.ibm.com>
 <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-9360-0000-0000-000012433E09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

With the removal of CONFIG_TINY_PREEMPT_RCU, rcu_preempt_process_callbacks()
is now an empty function.  This commit therefore eliminates it by
inlining it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutiny.c        | 1 -
 kernel/rcutiny_plugin.h | 8 --------
 2 files changed, 9 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 6f5a2a6..7fc2339 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -314,7 +314,6 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	__rcu_process_callbacks(&rcu_sched_ctrlblk);
 	__rcu_process_callbacks(&rcu_bh_ctrlblk);
-	rcu_preempt_process_callbacks();
 }
 
 /*
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 8b835b9..bfe9924 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -102,14 +102,6 @@ static void check_cpu_stalls(void)
 	RCU_TRACE(check_cpu_stall_preempt());
 }
 
-/*
- * Because preemptible RCU does not exist, it never has any callbacks
- * to process.
- */
-static void rcu_preempt_process_callbacks(void)
-{
-}
-
 /* Hold off callback invocation until early_initcall() time. */
 static int rcu_scheduler_fully_active __read_mostly;
 
-- 
1.8.1.5

