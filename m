Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbbA0BjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:39:17 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34010 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757665AbbA0BhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:37:06 -0500
From: David Decotigny <ddecotig@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>, Amir Vadai <amirv@mellanox.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
        Eugenia Emantayev <eugenia@mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>, Ido Shamay <idos@mellanox.com>,
        Joe Perches <joe@perches.com>, Saeed Mahameed <saeedm@mellanox.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Venkata Duvvuru <VenkatKumar.Duvvuru@Emulex.Com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Eyal Perry <eyalpe@mellanox.com>, Pravin B Shelar <pshelar@nicira.com>,
        Ed Swierk <eswierk@skyportsystems.com>,
        David Decotigny <decot@googlers.com>
Subject: [PATCH net-next v1 13/18] net: 8021q: use __ethtool_get_ksettings
Date: Mon, 26 Jan 2015 17:36:09 -0800
Message-Id: <1422322574-6188-14-git-send-email-ddecotig@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1422322574-6188-1-git-send-email-ddecotig@gmail.com>
References: <1422322574-6188-1-git-send-email-ddecotig@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@googlers.com>

Signed-off-by: David Decotigny <decot@googlers.com>
---
 net/8021q/vlan_dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 1189564..b301bf6 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -655,12 +655,12 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	return features;
 }
 
-static int vlan_ethtool_get_settings(struct net_device *dev,
-				     struct ethtool_cmd *cmd)
+static int vlan_ethtool_get_ksettings(struct net_device *dev,
+				      struct ethtool_ksettings *cmd)
 {
 	const struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
 
-	return __ethtool_get_settings(vlan->real_dev, cmd);
+	return __ethtool_get_ksettings(vlan->real_dev, cmd);
 }
 
 static void vlan_ethtool_get_drvinfo(struct net_device *dev,
@@ -768,7 +768,7 @@ static void vlan_dev_netpoll_cleanup(struct net_device *dev)
 #endif /* CONFIG_NET_POLL_CONTROLLER */
 
 static const struct ethtool_ops vlan_ethtool_ops = {
-	.get_settings	        = vlan_ethtool_get_settings,
+	.get_ksettings	        = vlan_ethtool_get_ksettings,
 	.get_drvinfo	        = vlan_ethtool_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
 	.get_ts_info		= vlan_ethtool_get_ts_info,
-- 
2.2.0.rc0.207.ga3a616c

