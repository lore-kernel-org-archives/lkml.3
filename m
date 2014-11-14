Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934823AbaKNAiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:38:46 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:44651 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934635AbaKNAim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:38:42 -0500
From: Joe Stringer <joestringer@nicira.com>
To: netdev@vger.kernel.org
Cc: sathya.perla@emulex.com, shahed.shaikh@qlogic.com, amirv@mellanox.com,
        Dept-GELinuxNICDev@qlogic.com, therbert@google.com,
        gerlitz.or@gmail.com, alexander.duyck@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 net 4/4] qlcnic: Implement ndo_gso_check()
Date: Thu, 13 Nov 2014 16:38:15 -0800
Message-Id: <1415925495-59312-5-git-send-email-joestringer@nicira.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415925495-59312-1-git-send-email-joestringer@nicira.com>
References: <1415925495-59312-1-git-send-email-joestringer@nicira.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use vxlan_gso_check() to advertise offload support for this NIC.

Signed-off-by: Joe Stringer <joestringer@nicira.com>
---
v2: Refactor out vxlan helper.
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index f5e29f7..a913b3a 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -503,6 +503,11 @@ static void qlcnic_del_vxlan_port(struct net_device *netdev,
 
 	adapter->flags |= QLCNIC_DEL_VXLAN_PORT;
 }
+
+static bool qlcnic_gso_check(struct sk_buff *skb, struct net_device *dev)
+{
+	return vxlan_gso_check(skb);
+}
 #endif
 
 static const struct net_device_ops qlcnic_netdev_ops = {
@@ -526,6 +531,7 @@ static const struct net_device_ops qlcnic_netdev_ops = {
 #ifdef CONFIG_QLCNIC_VXLAN
 	.ndo_add_vxlan_port	= qlcnic_add_vxlan_port,
 	.ndo_del_vxlan_port	= qlcnic_del_vxlan_port,
+	.ndo_gso_check		= qlcnic_gso_check,
 #endif
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = qlcnic_poll_controller,
-- 
1.7.10.4

