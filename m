Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab3CRVRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:17:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55997 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932794Ab3CRVRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:17:15 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/7] rcu: Delete unused rcu_node "wakemask" field
Date: Mon, 18 Mar 2013 14:16:53 -0700
Message-Id: <1363641416-18642-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363641416-18642-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130318211615.GA15814@linux.vnet.ibm.com>
 <1363641416-18642-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-7182-0000-0000-000005D7BF19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index c896b50..8e75609 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -134,9 +134,6 @@ struct rcu_node {
 				/*  elements that need to drain to allow the */
 				/*  current expedited grace period to */
 				/*  complete (only for TREE_PREEMPT_RCU). */
-	atomic_t wakemask;	/* CPUs whose kthread needs to be awakened. */
-				/*  Since this has meaning only for leaf */
-				/*  rcu_node structures, 32 bits suffices. */
 	unsigned long qsmaskinit;
 				/* Per-GP initial value for qsmask & expmask. */
 	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
-- 
1.8.1.5

