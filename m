Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaBQVgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:36:18 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:37897 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbaBQVgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:36:09 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/12] rcu: Indentation and spacing fixes.
Date: Mon, 17 Feb 2014 13:35:52 -0800
Message-Id: <1392672959-6386-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217213533.GA5387@linux.vnet.ibm.com>
 <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-9332-0000-0000-00000322EEE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

This commit outdents expression-statement macros, thus repairing a few
line-length complaints.  Also fix some spacing errors called out by
checkpatch.pl.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rculist.h  | 17 +++++++-------
 include/linux/rcupdate.h | 58 ++++++++++++++++++++++++------------------------
 2 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index dbaf99084112..8183b46fbaa2 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -247,9 +247,10 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
  */
 #define list_entry_rcu(ptr, type, member) \
-	({typeof (*ptr) __rcu *__ptr = (typeof (*ptr) __rcu __force *)ptr; \
-	 container_of((typeof(ptr))rcu_dereference_raw(__ptr), type, member); \
-	})
+({ \
+	typeof(*ptr) __rcu *__ptr = (typeof(*ptr) __rcu __force *)ptr; \
+	container_of((typeof(ptr))rcu_dereference_raw(__ptr), type, member); \
+})
 
 /**
  * Where are list_empty_rcu() and list_first_entry_rcu()?
@@ -285,11 +286,11 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
  */
 #define list_first_or_null_rcu(ptr, type, member) \
-	({struct list_head *__ptr = (ptr); \
-	  struct list_head *__next = ACCESS_ONCE(__ptr->next); \
-	  likely(__ptr != __next) ? \
-		list_entry_rcu(__next, type, member) : NULL; \
-	})
+({ \
+	struct list_head *__ptr = (ptr); \
+	struct list_head *__next = ACCESS_ONCE(__ptr->next); \
+	likely(__ptr != __next) ? list_entry_rcu(__next, type, member) : NULL; \
+})
 
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index d946d3660633..278a9da69ec4 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -508,40 +508,40 @@ static inline void rcu_preempt_sleep_check(void)
 #endif /* #else #ifdef __CHECKER__ */
 
 #define __rcu_access_pointer(p, space) \
-	({ \
-		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
-		rcu_dereference_sparse(p, space); \
-		((typeof(*p) __force __kernel *)(_________p1)); \
-	})
+({ \
+	typeof(*p) *_________p1 = (typeof(*p) *__force)ACCESS_ONCE(p); \
+	rcu_dereference_sparse(p, space); \
+	((typeof(*p) __force __kernel *)(_________p1)); \
+})
 #define __rcu_dereference_check(p, c, space) \
-	({ \
-		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
-		rcu_lockdep_assert(c, "suspicious rcu_dereference_check() usage"); \
-		rcu_dereference_sparse(p, space); \
-		smp_read_barrier_depends(); \
-		((typeof(*p) __force __kernel *)(_________p1)); \
-	})
+({ \
+	typeof(*p) *_________p1 = (typeof(*p) *__force)ACCESS_ONCE(p); \
+	rcu_lockdep_assert(c, "suspicious rcu_dereference_check() usage"); \
+	rcu_dereference_sparse(p, space); \
+	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
+	((typeof(*p) __force __kernel *)(_________p1)); \
+})
 #define __rcu_dereference_protected(p, c, space) \
-	({ \
-		rcu_lockdep_assert(c, "suspicious rcu_dereference_protected() usage"); \
-		rcu_dereference_sparse(p, space); \
-		((typeof(*p) __force __kernel *)(p)); \
-	})
+({ \
+	rcu_lockdep_assert(c, "suspicious rcu_dereference_protected() usage"); \
+	rcu_dereference_sparse(p, space); \
+	((typeof(*p) __force __kernel *)(p)); \
+})
 
 #define __rcu_access_index(p, space) \
-	({ \
-		typeof(p) _________p1 = ACCESS_ONCE(p); \
-		rcu_dereference_sparse(p, space); \
-		(_________p1); \
-	})
+({ \
+	typeof(p) _________p1 = ACCESS_ONCE(p); \
+	rcu_dereference_sparse(p, space); \
+	(_________p1); \
+})
 #define __rcu_dereference_index_check(p, c) \
-	({ \
-		typeof(p) _________p1 = ACCESS_ONCE(p); \
-		rcu_lockdep_assert(c, \
-				   "suspicious rcu_dereference_index_check() usage"); \
-		smp_read_barrier_depends(); \
-		(_________p1); \
-	})
+({ \
+	typeof(p) _________p1 = ACCESS_ONCE(p); \
+	rcu_lockdep_assert(c, \
+			   "suspicious rcu_dereference_index_check() usage"); \
+	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
+	(_________p1); \
+})
 
 /**
  * RCU_INITIALIZER() - statically initialize an RCU-protected global variable
-- 
1.8.1.5

