Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaFKUj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:39:57 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:54815 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbaFKUjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:39:54 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: [RFC PATCH 4/5] kernel/rcu/tree.c:3435 fix a sparse warning
Date: Wed, 11 Jun 2014 16:39:42 -0400
Message-Id: <1402519183-12752-5-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
References: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/rcu/tree.c:3435:21: warning: incorrect type in argument 1 (different modifiers)
kernel/rcu/tree.c:3435:21:    expected int ( *threadfn )( ... )
kernel/rcu/tree.c:3435:21:    got int ( static [toplevel] [noreturn] *<noident> )( ... )

by removing __noreturn attribute and adding unreachable() as suggested on the
mailing list: http://www.kernelhub.org/?p=2&msg=436683

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 9ab84d3..6029a2e 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1689,7 +1689,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 /*
  * Body of kthread that handles grace periods.
  */
-static int __noreturn rcu_gp_kthread(void *arg)
+static int rcu_gp_kthread(void *arg)
 {
 	int fqs_state;
 	int gf;
@@ -1777,6 +1777,9 @@ static int __noreturn rcu_gp_kthread(void *arg)
 		/* Handle grace-period end. */
 		rcu_gp_cleanup(rsp);
 	}
+
+	unreachable();
+	return 0;
 }
 
 /*
-- 
1.9.1

