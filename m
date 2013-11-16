Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3KPAZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:25:44 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:57544 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab3KPAXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:23:48 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/16] rcu: Let the world know when RCU adjusts its geometry
Date: Fri, 15 Nov 2013 16:23:28 -0800
Message-Id: <1384561418-30575-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116002316.GA29049@linux.vnet.ibm.com>
 <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-7164-0000-0000-0000035AF08B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Some RCU bugs have been specific to the layout of the rcu_node tree,
but RCU will silently adjust the tree at boot time if appropriate.
This obscures valuable debugging information, so print a message when
this happens.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index acbfead2eb82..875f2a0f9d8d 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3378,6 +3378,8 @@ static void __init rcu_init_geometry(void)
 	if (rcu_fanout_leaf == CONFIG_RCU_FANOUT_LEAF &&
 	    nr_cpu_ids == NR_CPUS)
 		return;
+	pr_info("RCU: Adjusting geometry for rcu_fanout_leaf=%d, nr_cpu_ids=%d\n",
+		rcu_fanout_leaf, nr_cpu_ids);
 
 	/*
 	 * Compute number of nodes that can be handled an rcu_node tree
-- 
1.8.1.5

