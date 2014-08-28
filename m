Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaH1S1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:27:50 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54566 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaH1S0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:26:45 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/15] rcu: Remove stale comment in tree.c
Date: Thu, 28 Aug 2014 11:26:29 -0700
Message-Id: <1409250394-25159-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828182614.GA23877@linux.vnet.ibm.com>
 <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-0928-0000-0000-00000467DC1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

This commit removes a stale comment in rcu/tree.c which was left
out when some code was moved around previously in commit 2036d94a7b61
("rcu:  Rework detection of use of RCU by offline CPUs") For reference,
the following updated comment exists a few lines below this which means
the same:

/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index dc52dc3b8c3e..dd6c8b519691 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2220,8 +2220,6 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	/* Adjust any no-longer-needed kthreads. */
 	rcu_boost_kthread_setaffinity(rnp, -1);
 
-	/* Remove the dead CPU from the bitmasks in the rcu_node hierarchy. */
-
 	/* Exclude any attempts to start a new grace period. */
 	mutex_lock(&rsp->onoff_mutex);
 	raw_spin_lock_irqsave(&rsp->orphan_lock, flags);
-- 
1.8.1.5

