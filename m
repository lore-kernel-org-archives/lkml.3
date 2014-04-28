Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaD1Xbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:31:39 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34559 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089AbaD1Xar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:30:47 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] documentation: Update API documentation
Date: Mon, 28 Apr 2014 16:30:40 -0700
Message-Id: <1398727840-11521-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398727840-11521-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428233013.GA10816@linux.vnet.ibm.com>
 <1398727840-11521-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-6688-0000-0000-0000016C68B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit updates the list of RCU API members in whatisRCU.txt.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/whatisRCU.txt | 55 ++++++++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 11 deletions(-)

diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 0f0fb7c432c2..49b8551a3b68 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -326,11 +326,11 @@ used as follows:
 a.	synchronize_rcu()	rcu_read_lock() / rcu_read_unlock()
 	call_rcu()		rcu_dereference()
 
-b.	call_rcu_bh()		rcu_read_lock_bh() / rcu_read_unlock_bh()
-				rcu_dereference_bh()
+b.	synchronize_rcu_bh()	rcu_read_lock_bh() / rcu_read_unlock_bh()
+	call_rcu_bh()		rcu_dereference_bh()
 
 c.	synchronize_sched()	rcu_read_lock_sched() / rcu_read_unlock_sched()
-				preempt_disable() / preempt_enable()
+	call_rcu_sched()	preempt_disable() / preempt_enable()
 				local_irq_save() / local_irq_restore()
 				hardirq enter / hardirq exit
 				NMI enter / NMI exit
@@ -794,10 +794,22 @@ in docbook.  Here is the list, by category.
 
 RCU list traversal:
 
+	list_entry_rcu
+	list_first_entry_rcu
+	list_next_rcu
 	list_for_each_entry_rcu
+	list_for_each_entry_continue_rcu
+	hlist_first_rcu
+	hlist_next_rcu
+	hlist_pprev_rcu
 	hlist_for_each_entry_rcu
+	hlist_for_each_entry_rcu_bh
+	hlist_for_each_entry_continue_rcu
+	hlist_for_each_entry_continue_rcu_bh
+	hlist_nulls_first_rcu
 	hlist_nulls_for_each_entry_rcu
-	list_for_each_entry_continue_rcu
+	hlist_bl_first_rcu
+	hlist_bl_for_each_entry_rcu
 
 RCU pointer/list update:
 
@@ -806,28 +818,38 @@ RCU pointer/list update:
 	list_add_tail_rcu
 	list_del_rcu
 	list_replace_rcu
-	hlist_del_rcu
 	hlist_add_after_rcu
 	hlist_add_before_rcu
 	hlist_add_head_rcu
+	hlist_del_rcu
+	hlist_del_init_rcu
 	hlist_replace_rcu
 	list_splice_init_rcu()
+	hlist_nulls_del_init_rcu
+	hlist_nulls_del_rcu
+	hlist_nulls_add_head_rcu
+	hlist_bl_add_head_rcu
+	hlist_bl_del_init_rcu
+	hlist_bl_del_rcu
+	hlist_bl_set_first_rcu
 
 RCU:	Critical sections	Grace period		Barrier
 
 	rcu_read_lock		synchronize_net		rcu_barrier
 	rcu_read_unlock		synchronize_rcu
 	rcu_dereference		synchronize_rcu_expedited
-				call_rcu
-				kfree_rcu
-
+	rcu_read_lock_held	call_rcu
+	rcu_dereference_check	kfree_rcu
+	rcu_dereference_protected
 
 bh:	Critical sections	Grace period		Barrier
 
 	rcu_read_lock_bh	call_rcu_bh		rcu_barrier_bh
 	rcu_read_unlock_bh	synchronize_rcu_bh
 	rcu_dereference_bh	synchronize_rcu_bh_expedited
-
+	rcu_dereference_bh_check
+	rcu_dereference_bh_protected
+	rcu_read_lock_bh_held
 
 sched:	Critical sections	Grace period		Barrier
 
@@ -835,7 +857,12 @@ sched:	Critical sections	Grace period		Barrier
 	rcu_read_unlock_sched	call_rcu_sched
 	[preempt_disable]	synchronize_sched_expedited
 	[and friends]
+	rcu_read_lock_sched_notrace
+	rcu_read_unlock_sched_notrace
 	rcu_dereference_sched
+	rcu_dereference_sched_check
+	rcu_dereference_sched_protected
+	rcu_read_lock_sched_held
 
 
 SRCU:	Critical sections	Grace period		Barrier
@@ -843,6 +870,8 @@ SRCU:	Critical sections	Grace period		Barrier
 	srcu_read_lock		synchronize_srcu	srcu_barrier
 	srcu_read_unlock	call_srcu
 	srcu_dereference	synchronize_srcu_expedited
+	srcu_dereference_check
+	srcu_read_lock_held
 
 SRCU:	Initialization/cleanup
 	init_srcu_struct
@@ -850,9 +879,13 @@ SRCU:	Initialization/cleanup
 
 All:  lockdep-checked RCU-protected pointer access
 
-	rcu_dereference_check
-	rcu_dereference_protected
+	rcu_access_index
 	rcu_access_pointer
+	rcu_dereference_index_check
+	rcu_dereference_raw
+	rcu_lockdep_assert
+	rcu_sleep_check
+	RCU_NONIDLE
 
 See the comment headers in the source code (or the docbook generated
 from them) for more information.
-- 
1.8.1.5

