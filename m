Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaBXHyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:54:51 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:57101 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaBXHyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:54:49 -0500
From: Liu Ping Fan <kernelfans@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] rcu: fix incorrect notes for code
Date: Mon, 24 Feb 2014 15:56:43 +0800
Message-Id: <1393228603-30785-1-git-send-email-pingfank@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-/* Is the specified CPU a no-CPUs CPU? */
+/* Is the specified CPU a no-CBs CPU? */
 bool rcu_is_nocb_cpu(int cpu)

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 6e2ef4b..ec6cb76 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2101,7 +2101,7 @@ static void rcu_init_one_nocb(struct rcu_node *rnp)
 	init_waitqueue_head(&rnp->nocb_gp_wq[1]);
 }
 
-/* Is the specified CPU a no-CPUs CPU? */
+/* Is the specified CPU a no-CBs CPU? */
 bool rcu_is_nocb_cpu(int cpu)
 {
 	if (have_rcu_nocb_mask)
-- 
1.8.1.4

