Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbaGHW0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:26:19 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:42598 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbaGHW0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:26:17 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 5/9] rcu: use true/false for return in __call_rcu_nocb()
Date: Tue,  8 Jul 2014 18:26:14 -0400
Message-Id: <1404858378-23806-6-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
References: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return true/false instead of 0/1 in __call_rcu_nocb() as this returns a bool type

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 6c1feee..9f119f4 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2132,7 +2132,7 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 {
 
 	if (!rcu_is_nocb_cpu(rdp->cpu))
-		return 0;
+		return false;
 	__call_rcu_nocb_enqueue(rdp, rhp, &rhp->next, 1, lazy, flags);
 	if (__is_kfree_rcu_offset((unsigned long)rhp->func))
 		trace_rcu_kfree_callback(rdp->rsp->name, rhp,
@@ -2143,7 +2143,7 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 		trace_rcu_callback(rdp->rsp->name, rhp,
 				   -atomic_long_read(&rdp->nocb_q_count_lazy),
 				   -atomic_long_read(&rdp->nocb_q_count));
-	return 1;
+	return true;
 }
 
 /*
-- 
1.9.1

