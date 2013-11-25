Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab3KYOcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:32:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58856 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857Ab3KYNxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:31 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Patrick McHardy" <kaber@trash.net>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.60671069@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 09/87] net: vlan: fix nlmsg size calculation in 
 vlan_get_size()
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit c33a39c575068c2ea9bffb22fd6de2df19c74b89 ]

This patch fixes the calculation of the nlmsg size, by adding the missing
nla_total_size().

Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/8021q/vlan_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index 235c219..c705612 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -152,7 +152,7 @@ static size_t vlan_get_size(const struct net_device *dev)
 	struct vlan_dev_info *vlan = vlan_dev_info(dev);
 
 	return nla_total_size(2) +	/* IFLA_VLAN_ID */
-	       sizeof(struct ifla_vlan_flags) + /* IFLA_VLAN_FLAGS */
+	       nla_total_size(sizeof(struct ifla_vlan_flags)) + /* IFLA_VLAN_FLAGS */
 	       vlan_qos_map_size(vlan->nr_ingress_mappings) +
 	       vlan_qos_map_size(vlan->nr_egress_mappings);
 }

