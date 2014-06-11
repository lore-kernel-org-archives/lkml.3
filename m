Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaFKUjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:39:52 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:62727 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbaFKUju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:39:50 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: [RFC PATCH 2/5] kernel/rcu/tree_plugin.h:1494 fix a sparse warning 
Date: Wed, 11 Jun 2014 16:39:40 -0400
Message-Id: <1402519183-12752-3-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
References: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/rcu/tree_plugin.h:1494:13: warning: context imbalance in 'rcu_initiate_boost' - unexpected unlock

by annotating the function with releases()

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index cbc2c45..0c955d9 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1256,6 +1256,7 @@ static int rcu_boost_kthread(void *arg)
  * about it going away.
  */
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
+	__releases(rnp->lock)
 {
 	struct task_struct *t;
 
@@ -1491,6 +1492,7 @@ static void rcu_prepare_kthreads(int cpu)
 #else /* #ifdef CONFIG_RCU_BOOST */
 
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
+	__releases(rnp->lock)
 {
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
-- 
1.9.1

