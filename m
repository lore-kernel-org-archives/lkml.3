Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaGGWkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:40:15 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56176 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbaGGWib (ORCPT
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
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/17] rcu: Handle obsolete references to TINY_PREEMPT_RCU
Date: Mon,  7 Jul 2014 15:38:06 -0700
Message-Id: <1404772701-8804-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-0928-0000-0000-000003305D7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 17 ++++++++---------
 init/Kconfig             |  2 +-
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index c56ad15204ec..d231aa17b1d7 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -826,15 +826,14 @@ static inline void rcu_preempt_sleep_check(void)
  * read-side critical section that would block in a !PREEMPT kernel.
  * But if you want the full story, read on!
  *
- * In non-preemptible RCU implementations (TREE_RCU and TINY_RCU), it
- * is illegal to block while in an RCU read-side critical section.  In
- * preemptible RCU implementations (TREE_PREEMPT_RCU and TINY_PREEMPT_RCU)
- * in CONFIG_PREEMPT kernel builds, RCU read-side critical sections may
- * be preempted, but explicit blocking is illegal.  Finally, in preemptible
- * RCU implementations in real-time (with -rt patchset) kernel builds,
- * RCU read-side critical sections may be preempted and they may also
- * block, but only when acquiring spinlocks that are subject to priority
- * inheritance.
+ * In non-preemptible RCU implementations (TREE_RCU and TINY_RCU),
+ * it is illegal to block while in an RCU read-side critical section.
+ * In preemptible RCU implementations (TREE_PREEMPT_RCU) in CONFIG_PREEMPT
+ * kernel builds, RCU read-side critical sections may be preempted,
+ * but explicit blocking is illegal.  Finally, in preemptible RCU
+ * implementations in real-time (with -rt patchset) kernel builds, RCU
+ * read-side critical sections may be preempted and they may also block, but
+ * only when acquiring spinlocks that are subject to priority inheritance.
  */
 static inline void rcu_read_lock(void)
 {
diff --git a/init/Kconfig b/init/Kconfig
index 9d76b99af1b9..977b37806e95 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -505,7 +505,7 @@ config PREEMPT_RCU
 	def_bool TREE_PREEMPT_RCU
 	help
 	  This option enables preemptible-RCU code that is common between
-	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
+	  TREE_PREEMPT_RCU and, in the old days, TINY_PREEMPT_RCU.
 
 config RCU_STALL_COMMON
 	def_bool ( TREE_RCU || TREE_PREEMPT_RCU || RCU_TRACE )
-- 
1.8.1.5

