Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab3ETO7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:59:22 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47869 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab3ETO7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:59:19 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/13] rcu: Remove rcu_preempt_remove_callbacks()
Date: Mon, 20 May 2013 07:58:11 -0700
Message-Id: <1369061900-546-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520145751.GA32218@linux.vnet.ibm.com>
 <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-7408-0000-0000-000010623C8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

With the removal of CONFIG_TINY_PREEMPT_RCU, rcu_preempt_remove_callbacks()
is now an empty function.  This commit therefore eliminates it by
inlining it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutiny.c        | 1 -
 kernel/rcutiny_plugin.h | 8 --------
 2 files changed, 9 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 9178282..6f5a2a6 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -289,7 +289,6 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	*rcp->donetail = NULL;
 	if (rcp->curtail == rcp->donetail)
 		rcp->curtail = &rcp->rcucblist;
-	rcu_preempt_remove_callbacks(rcp);
 	rcp->donetail = &rcp->rcucblist;
 	local_irq_restore(flags);
 
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 404b3a3..8b835b9 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -104,14 +104,6 @@ static void check_cpu_stalls(void)
 
 /*
  * Because preemptible RCU does not exist, it never has any callbacks
- * to remove.
- */
-static void rcu_preempt_remove_callbacks(struct rcu_ctrlblk *rcp)
-{
-}
-
-/*
- * Because preemptible RCU does not exist, it never has any callbacks
  * to process.
  */
 static void rcu_preempt_process_callbacks(void)
-- 
1.8.1.5

