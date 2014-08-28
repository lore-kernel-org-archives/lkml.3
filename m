Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbaH1TWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:22:01 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:50328 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaH1TUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:20:19 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v7 tip/core/rcu 05/17] rcu: Export RCU-tasks APIs to GPL modules
Date: Thu, 28 Aug 2014 12:19:56 -0700
Message-Id: <1409253608-32538-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409253608-32538-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828191929.GA31795@linux.vnet.ibm.com>
 <1409253608-32538-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082819-0928-0000-0000-000004685EBD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

This commit exports the RCU-tasks synchronous APIs,
synchronize_rcu_tasks() and rcu_barrier_tasks(), to
GPL-licensed kernel modules.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcu/update.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 403fc4ae539e..aef8109152ce 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -430,6 +430,7 @@ void synchronize_rcu_tasks(void)
 	/* Wait for the grace period. */
 	wait_rcu_gp(call_rcu_tasks);
 }
+EXPORT_SYMBOL_GPL(synchronize_rcu_tasks);
 
 /**
  * rcu_barrier_tasks - Wait for in-flight call_rcu_tasks() callbacks.
@@ -442,6 +443,7 @@ void rcu_barrier_tasks(void)
 	/* There is only one callback queue, so this is easy.  ;-) */
 	synchronize_rcu_tasks();
 }
+EXPORT_SYMBOL_GPL(rcu_barrier_tasks);
 
 /* See if the current task has stopped holding out, remove from list if so. */
 static void check_holdout_task(struct task_struct *t)
-- 
1.8.1.5

