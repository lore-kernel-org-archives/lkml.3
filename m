Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaGHW2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:28:16 -0400
Received: from mail-yk0-f180.google.com ([209.85.160.180]:36126 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbaGHW0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:26:15 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 4/9] rcu: return bool type for rcu_try_advance_all_cbs()
Date: Tue,  8 Jul 2014 18:26:13 -0400
Message-Id: <1404858378-23806-5-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
References: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return a bool type instead of 0 in rcu_try_advance_all_cbs()

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 1a4ab26..6c1feee 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1625,7 +1625,7 @@ static bool __maybe_unused rcu_try_advance_all_cbs(void)
 
 	/* Exit early if we advanced recently. */
 	if (jiffies == rdtp->last_advance_all)
-		return 0;
+		return false;
 	rdtp->last_advance_all = jiffies;
 
 	for_each_rcu_flavor(rsp) {
-- 
1.9.1

