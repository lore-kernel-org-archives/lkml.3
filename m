Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbaELBo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:44:56 -0400
Received: from 1wt.eu ([62.212.114.60]:34813 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102AbaELBox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:44:53 -0400
Message-Id: <20140512003201.961632958@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Patrick McHardy <kaber@trash.net>, Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 032/143] net: vlan: fix nlmsg size calculation in vlan_get_size()
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit c33a39c575068c2ea9bffb22fd6de2df19c74b89 ]

This patch fixes the calculation of the nlmsg size, by adding the missing
nla_total_size().

Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/8021q/vlan_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index a915048..1f13bcf 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -169,7 +169,7 @@ static size_t vlan_get_size(const struct net_device *dev)
 	struct vlan_dev_info *vlan = vlan_dev_info(dev);
 
 	return nla_total_size(2) +	/* IFLA_VLAN_ID */
-	       sizeof(struct ifla_vlan_flags) + /* IFLA_VLAN_FLAGS */
+	       nla_total_size(sizeof(struct ifla_vlan_flags)) + /* IFLA_VLAN_FLAGS */
 	       vlan_qos_map_size(vlan->nr_ingress_mappings) +
 	       vlan_qos_map_size(vlan->nr_egress_mappings);
 }
-- 
1.7.12.2.21.g234cd45.dirty



