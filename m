Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaJ1V5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:57:36 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49997 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaJ1V5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:57:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/10] rcu: Use DEFINE_PER_CPU_SHARED_ALIGNED for rcu_data
Date: Tue, 28 Oct 2014 14:53:29 -0700
Message-Id: <1414533217-24910-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028215140.GA23970@linux.vnet.ibm.com>
 <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102821-0033-0000-0000-000002803DA3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcu_data per-CPU variable has a number of fields that are atomically
manipulated, potentially by any CPU.  This situation can result in false
sharing with per-CPU variables that have the misfortune of being allocated
adjacent to rcu_data in memory.  This commit therefore changes the
DEFINE_PER_CPU() to DEFINE_PER_CPU_SHARED_ALIGNED() in order to avoid
this false sharing.

Reported-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index c0673c56fb1a..ab6fcfb4fe11 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -105,7 +105,7 @@ struct rcu_state sname##_state = { \
 	.name = RCU_STATE_NAME(sname), \
 	.abbr = sabbr, \
 }; \
-DEFINE_PER_CPU(struct rcu_data, sname##_data)
+DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_data, sname##_data)
 
 RCU_STATE_INITIALIZER(rcu_sched, 's', call_rcu_sched);
 RCU_STATE_INITIALIZER(rcu_bh, 'b', call_rcu_bh);
-- 
1.8.1.5

