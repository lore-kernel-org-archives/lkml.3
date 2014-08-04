Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaHDTWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:22:25 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47343 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaHDTVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:21:05 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v4 tip/core/rcu 05/11] rcu: Export RCU-tasks APIs to GPL modules
Date: Mon,  4 Aug 2014 12:20:48 -0700
Message-Id: <1407180054-19805-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1407180054-19805-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140804192017.GA18337@linux.vnet.ibm.com>
 <1407180054-19805-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080419-7164-0000-0000-000003950FD4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

This commit exports the RCU-tasks APIs, call_rcu_tasks(),
synchronize_rcu_tasks(), and rcu_barrier_tasks(), to GPL-licensed
kernel modules.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcu/update.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index bf5c15a0d72d..0aa7852bff02 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -433,6 +433,7 @@ void synchronize_rcu_tasks(void)
 	/* Wait for the grace period. */
 	wait_rcu_gp(call_rcu_tasks);
 }
+EXPORT_SYMBOL_GPL(synchronize_rcu_tasks);
 
 /**
  * rcu_barrier_tasks - Wait for in-flight call_rcu_tasks() callbacks.
@@ -445,6 +446,7 @@ void rcu_barrier_tasks(void)
 	/* There is only one callback queue, so this is easy.  ;-) */
 	synchronize_rcu_tasks();
 }
+EXPORT_SYMBOL_GPL(rcu_barrier_tasks);
 
 /* See if tasks are still holding out, complain if so. */
 static void check_holdout_task(struct task_struct *t)
-- 
1.8.1.5

