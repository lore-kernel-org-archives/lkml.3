Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab3EQWEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:04:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab3EQVrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:47:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 30/50] net: vlan,ethtool: netdev_features_t is more than 32 bit
Date: Fri, 17 May 2013 14:47:05 -0700
Message-Id: <20130517213845.864163043@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213842.447809965@linuxfoundation.org>
References: <20130517213842.447809965@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit b29d3145183da4e07d4b570fa8acdd3ac4a5c572 ]

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan_dev.c |    2 +-
 net/core/ethtool.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -598,7 +598,7 @@ static netdev_features_t vlan_dev_fix_fe
 	netdev_features_t features)
 {
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
-	u32 old_features = features;
+	netdev_features_t old_features = features;
 
 	features &= real_dev->vlan_features;
 	features |= NETIF_F_RXCSUM;
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1286,7 +1286,7 @@ int dev_ethtool(struct net *net, struct
 	void __user *useraddr = ifr->ifr_data;
 	u32 ethcmd;
 	int rc;
-	u32 old_features;
+	netdev_features_t old_features;
 
 	if (!dev || !netif_device_present(dev))
 		return -ENODEV;


