Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaGHW0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:26:12 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:35984 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbaGHW0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:26:09 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 1/9] rcu: fix sparse warning about rcu_batches_completed_preempt() being non-static
Date: Tue,  8 Jul 2014 18:26:10 -0400
Message-Id: <1404858378-23806-2-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
References: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix sparse warning about rcu_batches_completed_preempt() being non-static by
marking it as static

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 637a8a9..1a4ab26 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -134,7 +134,7 @@ static void __init rcu_bootup_announce(void)
  * Return the number of RCU-preempt batches processed thus far
  * for debug and statistics.
  */
-long rcu_batches_completed_preempt(void)
+static long rcu_batches_completed_preempt(void)
 {
 	return rcu_preempt_state.completed;
 }
-- 
1.9.1

