Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaGHW1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:27:19 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:52100 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbaGHW0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:26:22 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 8/9] rcu: return false instead of 0 in rcu_nocb_adopt_orphan_cbs()
Date: Tue,  8 Jul 2014 18:26:17 -0400
Message-Id: <1404858378-23806-9-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
References: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return false instead of 0 in rcu_nocb_adopt_orphan_cbs() as this has bool as return type

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 5c21f4b..9a4dc07 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2389,7 +2389,7 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 						     struct rcu_data *rdp,
 						     unsigned long flags)
 {
-	return 0;
+	return false;
 }
 
 static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
-- 
1.9.1

