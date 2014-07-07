Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaGGWie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:38:34 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56171 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbaGGWib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:38:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH tip/core/rcu 14/17] rcu: remove CONFIG_PROVE_RCU_DELAY
Date: Mon,  7 Jul 2014 15:38:18 -0700
Message-Id: <1404772701-8804-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-0928-0000-0000-000003305D8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The CONFIG_PROVE_RCU_DELAY Kconfig parameter doesn't appear to be very
effective at finding race conditions, so this commit removes it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
---
 kernel/rcu/tree.c                                       | 5 -----
 kernel/rcu/update.c                                     | 3 ---
 tools/testing/selftests/rcutorture/configs/rcu/TREE01   | 1 -
 tools/testing/selftests/rcutorture/configs/rcu/TREE02   | 1 -
 tools/testing/selftests/rcutorture/configs/rcu/TREE02-T | 1 -
 tools/testing/selftests/rcutorture/configs/rcu/TREE03   | 1 -
 tools/testing/selftests/rcutorture/configs/rcu/TREE04   | 1 -
 tools/testing/selftests/rcutorture/configs/rcu/TREE05   | 1 -
 tools/testing/selftests/rcutorture/configs/rcu/TREE06   | 1 -
 tools/testing/selftests/rcutorture/configs/rcu/TREE07   | 1 -
 tools/testing/selftests/rcutorture/configs/rcu/TREE08   | 1 -
 tools/testing/selftests/rcutorture/configs/rcu/TREE08-T | 1 -
 tools/testing/selftests/rcutorture/configs/rcu/TREE09   | 1 -
 13 files changed, 19 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index a6c5424ffa38..1b70cb6fbe3c 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1647,11 +1647,6 @@ static int rcu_gp_init(struct rcu_state *rsp)
 					    rnp->level, rnp->grplo,
 					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irq(&rnp->lock);
-#ifdef CONFIG_PROVE_RCU_DELAY
-		if ((prandom_u32() % (rcu_num_nodes + 1)) == 0 &&
-		    system_state == SYSTEM_RUNNING)
-			udelay(200);
-#endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
 		cond_resched();
 	}
 
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index bc7883570530..4056d7992a6c 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -90,9 +90,6 @@ void __rcu_read_unlock(void)
 	} else {
 		barrier();  /* critical section before exit code. */
 		t->rcu_read_lock_nesting = INT_MIN;
-#ifdef CONFIG_PROVE_RCU_DELAY
-		udelay(10); /* Make preemption more probable. */
-#endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
 		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
 			rcu_read_unlock_special(t);
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE01 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
index 9c827ec59a97..063b7079c621 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE01
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
@@ -15,7 +15,6 @@ CONFIG_RCU_FANOUT_EXACT=n
 CONFIG_RCU_NOCB_CPU=y
 CONFIG_RCU_NOCB_CPU_ZERO=y
 CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE02 b/tools/testing/selftests/rcutorture/configs/rcu/TREE02
index 1a777b5f68b5..ea119ba2f7d4 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE02
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE02
@@ -18,7 +18,6 @@ CONFIG_RCU_FANOUT_EXACT=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_PROVE_LOCKING=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=y
 CONFIG_RCU_BOOST=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T b/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
index 61c8d9ce5bb2..19cf9485f48a 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
@@ -18,7 +18,6 @@ CONFIG_RCU_FANOUT_EXACT=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_PROVE_LOCKING=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=y
 CONFIG_RCU_BOOST=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE03 b/tools/testing/selftests/rcutorture/configs/rcu/TREE03
index c1f111c1561b..f4567fb3e332 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE03
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE03
@@ -14,7 +14,6 @@ CONFIG_RCU_FANOUT_LEAF=4
 CONFIG_RCU_FANOUT_EXACT=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE04 b/tools/testing/selftests/rcutorture/configs/rcu/TREE04
index 7dbd27ce17a4..0a262fbb0c12 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE04
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE04
@@ -18,7 +18,6 @@ CONFIG_RCU_FANOUT_LEAF=2
 CONFIG_RCU_FANOUT_EXACT=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=y
 CONFIG_RCU_CPU_STALL_VERBOSE=y
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE05 b/tools/testing/selftests/rcutorture/configs/rcu/TREE05
index d0f32e574743..3a06b97e9a73 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE05
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE05
@@ -18,7 +18,6 @@ CONFIG_RCU_NOCB_CPU_NONE=y
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_PROVE_LOCKING=y
 CONFIG_PROVE_RCU=y
-CONFIG_PROVE_RCU_DELAY=y
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE06 b/tools/testing/selftests/rcutorture/configs/rcu/TREE06
index 2e477dfb9c57..8f084cca91bf 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE06
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE06
@@ -19,7 +19,6 @@ CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_PROVE_LOCKING=y
 CONFIG_PROVE_RCU=y
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE07 b/tools/testing/selftests/rcutorture/configs/rcu/TREE07
index 042f86ef362a..ab6225506909 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE07
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE07
@@ -17,7 +17,6 @@ CONFIG_RCU_FANOUT_LEAF=2
 CONFIG_RCU_FANOUT_EXACT=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=y
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
index 3438cee1e3c5..69a2e255bf98 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE08
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
@@ -18,7 +18,6 @@ CONFIG_RCU_FANOUT_LEAF=2
 CONFIG_RCU_NOCB_CPU=y
 CONFIG_RCU_NOCB_CPU_ALL=y
 CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
index bf4523d3e44c..a0f32fb8f17e 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
@@ -18,7 +18,6 @@ CONFIG_RCU_FANOUT_LEAF=2
 CONFIG_RCU_NOCB_CPU=y
 CONFIG_RCU_NOCB_CPU_ALL=y
 CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE09 b/tools/testing/selftests/rcutorture/configs/rcu/TREE09
index 81e4f7c0bf0b..b7a62a540ad1 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE09
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE09
@@ -13,7 +13,6 @@ CONFIG_SUSPEND=n
 CONFIG_HIBERNATION=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
-- 
1.8.1.5

