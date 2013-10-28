Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab3J1Otp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:49:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51248 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab3J1Otl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrick McHardy <kaber@trash.net>, Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 48/64] net: vlan: fix nlmsg size calculation in vlan_get_size()
Date: Mon, 28 Oct 2013 14:48:07 +0000
Message-Id: <1382971703-17393-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit c33a39c575068c2ea9bffb22fd6de2df19c74b89 upstream.

This patch fixes the calculation of the nlmsg size, by adding the missing
nla_total_size().

Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/8021q/vlan_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index 708c80e..ebde030 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -152,7 +152,7 @@ static size_t vlan_get_size(const struct net_device *dev)
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
 
 	return nla_total_size(2) +	/* IFLA_VLAN_ID */
-	       sizeof(struct ifla_vlan_flags) + /* IFLA_VLAN_FLAGS */
+	       nla_total_size(sizeof(struct ifla_vlan_flags)) + /* IFLA_VLAN_FLAGS */
 	       vlan_qos_map_size(vlan->nr_ingress_mappings) +
 	       vlan_qos_map_size(vlan->nr_egress_mappings);
 }
-- 
1.8.3.2

