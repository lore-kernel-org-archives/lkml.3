Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbbAUKI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:08:58 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:38711 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbbAUKId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:08:33 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 7/7] rcu: Move early boot callback tests earlier
Date: Wed, 21 Jan 2015 02:08:20 -0800
Message-Id: <1421834900-23987-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1421834900-23987-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150121100750.GA22883@linux.vnet.ibm.com>
 <1421834900-23987-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012110-0017-0000-0000-0000081BA330
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because callbacks can now be posted quite early in boot, move the
early boot callback tests to precede RCU initialization.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index c5241cdd4daf..21f3d5007d77 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3920,6 +3920,8 @@ void __init rcu_init(void)
 {
 	int cpu;
 
+	rcu_early_boot_tests();
+
 	rcu_bootup_announce();
 	rcu_init_geometry();
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
@@ -3936,8 +3938,6 @@ void __init rcu_init(void)
 	pm_notifier(rcu_pm_notify, 0);
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
-
-	rcu_early_boot_tests();
 }
 
 #include "tree_plugin.h"
-- 
1.8.1.5

