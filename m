Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaGHW0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:26:24 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:60477 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaGHW0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:26:21 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 7/9] rcu: use false for return in __call_rcu_nocb()
Date: Tue,  8 Jul 2014 18:26:16 -0400
Message-Id: <1404858378-23806-8-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
References: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return false instead of 0 in __call_rcu_nocb() as this has bool as return type

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 86a3565..5c21f4b 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2382,7 +2382,7 @@ static void rcu_init_one_nocb(struct rcu_node *rnp)
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy, unsigned long flags)
 {
-	return 0;
+	return false;
 }
 
 static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
-- 
1.9.1

