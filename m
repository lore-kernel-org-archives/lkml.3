Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbaCWTXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:23:46 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:42781 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaCWTXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:23:43 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: jesse@nicira.com, davem@davemloft.net, dev@openvswitch.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/openvswitch: Use with RCU_INIT_POINTER(x, NULL) in vport-gre.c
Date: Mon, 24 Mar 2014 00:52:43 +0530
Message-Id: <1395602563-15221-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 net/openvswitch/vport-gre.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/vport-gre.c b/net/openvswitch/vport-gre.c
index a3d6951..a0da2dd 100644
--- a/net/openvswitch/vport-gre.c
+++ b/net/openvswitch/vport-gre.c
@@ -256,7 +256,7 @@ static void gre_tnl_destroy(struct vport *vport)
 
 	ovs_net = net_generic(net, ovs_net_id);
 
-	rcu_assign_pointer(ovs_net->vport_net.gre_vport, NULL);
+	RCU_INIT_POINTER(ovs_net->vport_net.gre_vport, NULL);
 	ovs_vport_deferred_free(vport);
 	gre_exit();
 }
-- 
1.7.9.5

