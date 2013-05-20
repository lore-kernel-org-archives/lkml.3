Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab3ETLBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:01:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56357 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab3ETKxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 090/115] net: vlan,ethtool: netdev_features_t is more than 32 bit
Date: Mon, 20 May 2013 11:51:30 +0100
Message-Id: <1369047116-9378-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit b29d3145183da4e07d4b570fa8acdd3ac4a5c572 upstream.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/8021q/vlan_dev.c | 2 +-
 net/core/ethtool.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index da1bc9c..7005e08 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -598,7 +598,7 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
-	u32 old_features = features;
+	netdev_features_t old_features = features;
 
 	features &= real_dev->vlan_features;
 	features |= NETIF_F_RXCSUM;
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 9c2afb4..86253eb 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1384,7 +1384,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	void __user *useraddr = ifr->ifr_data;
 	u32 ethcmd;
 	int rc;
-	u32 old_features;
+	netdev_features_t old_features;
 
 	if (!dev || !netif_device_present(dev))
 		return -ENODEV;
-- 
1.8.1.2

