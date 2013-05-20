Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab3ETPAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:00:43 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57848 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab3ETPAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:00:39 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/13] rcu: Remove rcu_preempt_check_callbacks()
Date: Mon, 20 May 2013 07:58:10 -0700
Message-Id: <1369061900-546-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520145751.GA32218@linux.vnet.ibm.com>
 <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-4834-0000-0000-000007285F61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

With the removal of CONFIG_TINY_PREEMPT_RCU, rcu_preempt_check_callbacks()
is now an empty function.  This commit therefore eliminates it by
inlining it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutiny.c        | 1 -
 kernel/rcutiny_plugin.h | 8 --------
 2 files changed, 9 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index a0714a5..9178282 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -257,7 +257,6 @@ void rcu_check_callbacks(int cpu, int user)
 		rcu_sched_qs(cpu);
 	else if (!in_softirq())
 		rcu_bh_qs(cpu);
-	rcu_preempt_check_callbacks();
 }
 
 /*
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index cf0bc22..404b3a3 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -104,14 +104,6 @@ static void check_cpu_stalls(void)
 
 /*
  * Because preemptible RCU does not exist, it never has any callbacks
- * to check.
- */
-static void rcu_preempt_check_callbacks(void)
-{
-}
-
-/*
- * Because preemptible RCU does not exist, it never has any callbacks
  * to remove.
  */
 static void rcu_preempt_remove_callbacks(struct rcu_ctrlblk *rcp)
-- 
1.8.1.5

