Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbbAGRYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:24:16 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40871 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbbAGRVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:21:10 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/10] rcu: Remove "select IRQ_WORK" from config TREE_RCU
Date: Wed,  7 Jan 2015 09:20:57 -0800
Message-Id: <1420651257-553-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420651257-553-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107172030.GA31571@linux.vnet.ibm.com>
 <1420651257-553-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0021-0000-0000-000007937791
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The 48a7639ce80c ("rcu: Make callers awaken grace-period kthread")
removed the irq_work_queue(), so the TREE_RCU doesn't need
irq work any more.  This commit therefore updates RCU's Kconfig and

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig      | 2 --
 kernel/rcu/tree.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 9afb971497f4..39b4313c6ca6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -470,7 +470,6 @@ choice
 config TREE_RCU
 	bool "Tree-based hierarchical RCU"
 	depends on !PREEMPT && SMP
-	select IRQ_WORK
 	help
 	  This option selects the RCU implementation that is
 	  designed for very large SMP system with hundreds or
@@ -480,7 +479,6 @@ config TREE_RCU
 config PREEMPT_RCU
 	bool "Preemptible tree-based hierarchical RCU"
 	depends on PREEMPT
-	select IRQ_WORK
 	help
 	  This option selects the RCU implementation that is
 	  designed for very large SMP systems with hundreds or
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index cb5908672f11..41860b9a04a2 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -27,7 +27,6 @@
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
-#include <linux/irq_work.h>
 
 /*
  * Define shape of hierarchy based on NR_CPUS, CONFIG_RCU_FANOUT, and
-- 
1.8.1.5

