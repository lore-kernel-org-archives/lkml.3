Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3GYOew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:34:52 -0400
Received: from multi.imgtec.com ([194.200.65.239]:41287 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966Ab3GYOev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:34:51 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: [PATCH 1/1] rcu: select IRQ_WORK from TREE_PREEMPT_RCU
Date: Thu, 25 Jul 2013 15:34:25 +0100
Message-ID: <1374762865-13635-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_07_25_15_34_32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.8.1.2


