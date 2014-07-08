Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaGHW1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:27:37 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:45013 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbaGHW0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:26:19 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 6/9] rcu: use true/false for return in rcu_nocb_adopt_orphan_cbs()
Date: Tue,  8 Jul 2014 18:26:15 -0400
Message-Id: <1404858378-23806-7-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
References: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return true/false in rcu_nocb_adopt_orphan_cbs() instead of 0/1 as this function
has return type of bool

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 9f119f4..86a3565 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2159,7 +2159,7 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 
 	/* If this is not a no-CBs CPU, tell the caller to do it the old way. */
 	if (!rcu_is_nocb_cpu(smp_processor_id()))
-		return 0;
+		return false;
 	rsp->qlen = 0;
 	rsp->qlen_lazy = 0;
 
@@ -2178,7 +2178,7 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 		rsp->orphan_nxtlist = NULL;
 		rsp->orphan_nxttail = &rsp->orphan_nxtlist;
 	}
-	return 1;
+	return true;
 }
 
 /*
-- 
1.9.1

