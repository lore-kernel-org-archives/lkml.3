Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab3HTCnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:43:39 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39667 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3HTCm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:42:27 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, James Hogan <james.hogan@imgtec.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 7/9] rcu: Select IRQ_WORK from TREE_PREEMPT_RCU
Date: Mon, 19 Aug 2013 19:42:12 -0700
Message-Id: <1376966534-30775-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130820024148.GA30283@linux.vnet.ibm.com>
 <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-2398-0000-0000-000001A46F39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Hogan <james.hogan@imgtec.com>

TREE_RCU and TREE_PREEMPT_RCU both cause kernel/rcutree.c to be built,
but only TREE_RCU selects IRQ_WORK, which can result in an undefined
reference to irq_work_queue for some (random) configs:

kernel/built-in.o In function `rcu_start_gp_advanced':
kernel/rcutree.c:1564: undefined reference to `irq_work_queue'

Select IRQ_WORK from TREE_PREEMPT_RCU too to fix this.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 init/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index 247084b..c08a549 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -470,6 +470,7 @@ config TREE_RCU
 config TREE_PREEMPT_RCU
 	bool "Preemptible tree-based hierarchical RCU"
 	depends on PREEMPT
+	select IRQ_WORK
 	help
 	  This option selects the RCU implementation that is
 	  designed for very large SMP systems with hundreds or
-- 
1.8.1.5

