Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab3E1VZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:25:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59735 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758477Ab3E1VZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:25:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 66/78] net: vlan,ethtool: netdev_features_t is more than 32 bit
Date: Tue, 28 May 2013 14:20:15 -0700
Message-Id: <1369776027-17859-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

[ Upstream commit b29d3145183da4e07d4b570fa8acdd3ac4a5c572 ]

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/8021q/vlan_dev.c | 2 +-
 net/core/ethtool.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 4a6d31a..9cbcfcd 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -617,7 +617,7 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
-	u32 old_features = features;
+	netdev_features_t old_features = features;
 
 	features &= real_dev->vlan_features;
 	features |= NETIF_F_RXCSUM;
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index a870543..2a53731 100644
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
1.8.1.2

