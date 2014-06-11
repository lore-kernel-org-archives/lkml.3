Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaFKDUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 23:20:19 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:43372 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaFKDUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 23:20:17 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [RFC PATCH 1/1] kernel/rcu/tree.c: correct a check for grace period in progress
Date: Tue, 10 Jun 2014 23:20:19 -0400
Message-Id: <1402456819-30515-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment above the code says that we are checking both the current node and
the parent node to see if a grace period is in progress. Change the code
accordingly.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f1ba773..b632189 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1227,7 +1227,7 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
 	 * need to explicitly start one.
 	 */
 	if (rnp->gpnum != rnp->completed ||
-	    ACCESS_ONCE(rnp->gpnum) != ACCESS_ONCE(rnp->completed)) {
+	    ACCESS_ONCE(rnp_root->gpnum) != ACCESS_ONCE(rnp_root->completed)) {
 		rnp->need_future_gp[c & 0x1]++;
 		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedleaf"));
 		goto out;
-- 
1.9.1

