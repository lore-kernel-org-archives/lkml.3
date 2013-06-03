Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591Ab3FCWT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:19:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9887 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877Ab3FCWML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:11 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=zyjggLdaQYMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=7yqKIxGHasUA:10 a=J1Y8HTJGAAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221158.375966242@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [35/65] net: vlan,ethtool: netdev_features_t is more than 32 bit
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0035-net-vlan-ethtool-netdev_features_t-is-more-than-32-b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

[ Upstream commit b29d3145183da4e07d4b570fa8acdd3ac4a5c572 ]

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/8021q/vlan_dev.c |    2 +-
 net/core/ethtool.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 4024424..a841735 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -611,7 +611,7 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
-	u32 old_features = features;
+	netdev_features_t old_features = features;
 
 	features &= real_dev->vlan_features;
 	features |= NETIF_F_RXCSUM;
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index cbf033d..fa1370c 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1418,7 +1418,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	void __user *useraddr = ifr->ifr_data;
 	u32 ethcmd;
 	int rc;
-	u32 old_features;
+	netdev_features_t old_features;
 
 	if (!dev || !netif_device_present(dev))
 		return -ENODEV;
-- 
1.7.10.4


