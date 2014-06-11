Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaFKUjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:39:54 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:45616 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaFKUjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:39:52 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: [RFC PATCH 3/5] kernel/rcu/tree_plugin.h:990 fix a sparse warning
Date: Wed, 11 Jun 2014 16:39:41 -0400
Message-Id: <1402519183-12752-4-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
References: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/rcu/tree_plugin.h:990:13: warning: context imbalance in 'rcu_report_unblock_qs_rnp' - unexpected unlock

by annotating the function with __releases()

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 0c955d9..9f85469 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -988,6 +988,7 @@ static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp)
 
 /* Because preemptible RCU does not exist, no quieting of tasks. */
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
+	__releases(rnp->lock)
 {
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
-- 
1.9.1

