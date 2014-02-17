Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaBQVgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:36:15 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52858 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaBQVgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:36:07 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/12] rcu: Glue ASCII strings together
Date: Mon, 17 Feb 2014 13:35:51 -0800
Message-Id: <1392672959-6386-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217213533.GA5387@linux.vnet.ibm.com>
 <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-6688-0000-0000-000006AE6EFD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Split strings make it difficult to find the code that resulted in a
given console message, so this commit glues split strings back together
despite the resulting long lines.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index b200756ea4c0..d946d3660633 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -479,11 +479,9 @@ static inline void rcu_preempt_sleep_check(void)
 	do {								\
 		rcu_preempt_sleep_check();				\
 		rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),	\
-				   "Illegal context switch in RCU-bh"	\
-				   " read-side critical section");	\
+				   "Illegal context switch in RCU-bh read-side critical section"); \
 		rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),	\
-				   "Illegal context switch in RCU-sched"\
-				   " read-side critical section");	\
+				   "Illegal context switch in RCU-sched read-side critical section"); \
 	} while (0)
 
 #else /* #ifdef CONFIG_PROVE_RCU */
@@ -518,16 +516,14 @@ static inline void rcu_preempt_sleep_check(void)
 #define __rcu_dereference_check(p, c, space) \
 	({ \
 		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
-		rcu_lockdep_assert(c, "suspicious rcu_dereference_check()" \
-				      " usage"); \
+		rcu_lockdep_assert(c, "suspicious rcu_dereference_check() usage"); \
 		rcu_dereference_sparse(p, space); \
 		smp_read_barrier_depends(); \
 		((typeof(*p) __force __kernel *)(_________p1)); \
 	})
 #define __rcu_dereference_protected(p, c, space) \
 	({ \
-		rcu_lockdep_assert(c, "suspicious rcu_dereference_protected()" \
-				      " usage"); \
+		rcu_lockdep_assert(c, "suspicious rcu_dereference_protected() usage"); \
 		rcu_dereference_sparse(p, space); \
 		((typeof(*p) __force __kernel *)(p)); \
 	})
@@ -542,8 +538,7 @@ static inline void rcu_preempt_sleep_check(void)
 	({ \
 		typeof(p) _________p1 = ACCESS_ONCE(p); \
 		rcu_lockdep_assert(c, \
-				   "suspicious rcu_dereference_index_check()" \
-				   " usage"); \
+				   "suspicious rcu_dereference_index_check() usage"); \
 		smp_read_barrier_depends(); \
 		(_________p1); \
 	})
-- 
1.8.1.5

