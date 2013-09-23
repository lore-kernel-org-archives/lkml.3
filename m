Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab3IWWMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:12:08 -0400
Received: from smtprelay0019.hostedemail.com ([216.40.44.19]:48455 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754456Ab3IWWME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:12:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:4385:5007:6119:6261:7903:10004:10026:10848:11026:11657:11658:11914:12043:12294:12296:12438:12517:12519:12555:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sort53_2ee0c0e0da92d
X-Filterd-Recvd-Size: 3327
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] gianfar: Remove extern from function prototypes
Date: Mon, 23 Sep 2013 15:11:37 -0700
Message-Id: <0fb9cd29764ddacf21ab582b7c2020f34a0bf4e6.1379974101.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <5570169a078375fa8662adeb2a7f24c1ae718bfb.1379974101.git.joe@perches.com>
References: <5570169a078375fa8662adeb2a7f24c1ae718bfb.1379974101.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a mix of function prototypes with and without extern
in the kernel sources.  Standardize on not using extern for
function prototypes.

Function prototypes don't need to be written with extern.
extern is assumed by the compiler.  Its use is as unnecessary as
using auto to declare automatic/local variables in a block.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/freescale/gianfar.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
index 04112b9..114c58f 100644
--- a/drivers/net/ethernet/freescale/gianfar.h
+++ b/drivers/net/ethernet/freescale/gianfar.h
@@ -1177,21 +1177,21 @@ static inline void gfar_read_filer(struct gfar_private *priv,
 	*fpr = gfar_read(&regs->rqfpr);
 }
 
-extern void lock_rx_qs(struct gfar_private *priv);
-extern void lock_tx_qs(struct gfar_private *priv);
-extern void unlock_rx_qs(struct gfar_private *priv);
-extern void unlock_tx_qs(struct gfar_private *priv);
-extern irqreturn_t gfar_receive(int irq, void *dev_id);
-extern int startup_gfar(struct net_device *dev);
-extern void stop_gfar(struct net_device *dev);
-extern void gfar_halt(struct net_device *dev);
-extern void gfar_phy_test(struct mii_bus *bus, struct phy_device *phydev,
-		int enable, u32 regnum, u32 read);
-extern void gfar_configure_coalescing_all(struct gfar_private *priv);
+void lock_rx_qs(struct gfar_private *priv);
+void lock_tx_qs(struct gfar_private *priv);
+void unlock_rx_qs(struct gfar_private *priv);
+void unlock_tx_qs(struct gfar_private *priv);
+irqreturn_t gfar_receive(int irq, void *dev_id);
+int startup_gfar(struct net_device *dev);
+void stop_gfar(struct net_device *dev);
+void gfar_halt(struct net_device *dev);
+void gfar_phy_test(struct mii_bus *bus, struct phy_device *phydev, int enable,
+		   u32 regnum, u32 read);
+void gfar_configure_coalescing_all(struct gfar_private *priv);
 void gfar_init_sysfs(struct net_device *dev);
 int gfar_set_features(struct net_device *dev, netdev_features_t features);
-extern void gfar_check_rx_parser_mode(struct gfar_private *priv);
-extern void gfar_vlan_mode(struct net_device *dev, netdev_features_t features);
+void gfar_check_rx_parser_mode(struct gfar_private *priv);
+void gfar_vlan_mode(struct net_device *dev, netdev_features_t features);
 
 extern const struct ethtool_ops gfar_ethtool_ops;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

