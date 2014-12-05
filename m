Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaLETg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:36:26 -0500
Received: from na6sys009bog026.obsmtp.com ([74.125.150.92]:33069 "HELO
	na6sys009bog026.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750862AbaLETgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:36:25 -0500
From: Joe Stringer <joestringer@nicira.com>
To: netdev@vger.kernel.org
Cc: ariel.elior@qlogic.com, jesse@nicira.com, therbert@google.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] bnx2x: Implement ndo_gso_check()
Date: Fri,  5 Dec 2014 11:35:46 -0800
Message-Id: <1417808146-3436-1-git-send-email-joestringer@nicira.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use vxlan_gso_check() to advertise offload support for this NIC.

Signed-off-by: Joe Stringer <joestringer@nicira.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 74fbf9e..893cdb6 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -45,6 +45,7 @@
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/tcp.h>
+#include <net/vxlan.h>
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
 #include <linux/workqueue.h>
@@ -12550,6 +12551,11 @@ static int bnx2x_get_phys_port_id(struct net_device *netdev,
 	return 0;
 }
 
+static bool bnx2x_gso_check(struct sk_buff *skb, struct net_device *dev)
+{
+	return vxlan_gso_check(skb);
+}
+
 static const struct net_device_ops bnx2x_netdev_ops = {
 	.ndo_open		= bnx2x_open,
 	.ndo_stop		= bnx2x_close,
@@ -12581,6 +12587,7 @@ static const struct net_device_ops bnx2x_netdev_ops = {
 #endif
 	.ndo_get_phys_port_id	= bnx2x_get_phys_port_id,
 	.ndo_set_vf_link_state	= bnx2x_set_vf_link_state,
+	.ndo_gso_check		= bnx2x_gso_check,
 };
 
 static int bnx2x_set_coherency_mask(struct bnx2x *bp)
-- 
1.7.10.4

