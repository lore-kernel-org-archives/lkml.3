Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbaGWFKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:10:46 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:35335 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992AbaGWFKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:10:42 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 02/16] rcu: Check return value for cpumask allocation
Date: Wed, 23 Jul 2014 01:09:39 -0400
Message-Id: <1406092194-13004-3-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit add a check for return value of zalloc_cpumask_var() used while
allocating cpumask for rcu_nocb_mask.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index f07b643..bac9797 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -88,7 +88,10 @@ static void __init rcu_bootup_announce_oddness(void)
 #ifdef CONFIG_RCU_NOCB_CPU
 #ifndef CONFIG_RCU_NOCB_CPU_NONE
 	if (!have_rcu_nocb_mask) {
-		zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
+		if (!zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL)) {
+			pr_info("rcu_nocb_mask allocation failed\n");
+			return;
+		}
 		have_rcu_nocb_mask = true;
 	}
 #ifdef CONFIG_RCU_NOCB_CPU_ZERO
-- 
2.0.0.rc2

