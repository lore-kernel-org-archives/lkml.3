Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbaGaAlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:41:50 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:53268 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbaGaAjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:39:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v2 tip/core/rcu 04/10] rcu: Export RCU-tasks APIs to GPL modules
Date: Wed, 30 Jul 2014 17:39:36 -0700
Message-Id: <1406767182-4356-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073100-7164-0000-0000-0000037DA4AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

This commit exports the RCU-tasks APIs, call_rcu_tasks(),
synchronize_rcu_tasks(), and rcu_barrier_tasks(), to GPL-licensed
kernel modules.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/update.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index c8d304dc6d8a..1bfc07ed854e 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -429,6 +429,7 @@ void synchronize_rcu_tasks(void)
 	/* Wait for the grace period. */
 	wait_rcu_gp(call_rcu_tasks);
 }
+EXPORT_SYMBOL_GPL(synchronize_rcu_tasks);
 
 /**
  * rcu_barrier_tasks - Wait for in-flight call_rcu_tasks() callbacks.
@@ -441,6 +442,7 @@ void rcu_barrier_tasks(void)
 	/* There is only one callback queue, so this is easy.  ;-) */
 	synchronize_rcu_tasks();
 }
+EXPORT_SYMBOL_GPL(rcu_barrier_tasks);
 
 /* RCU-tasks kthread that detects grace periods and invokes callbacks. */
 static int __noreturn rcu_tasks_kthread(void *arg)
-- 
1.8.1.5

