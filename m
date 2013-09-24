Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab3IXVKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:10:48 -0400
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:48897 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754815Ab3IXVKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:10:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:69:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1535:1544:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:4321:4384:4605:5007:6261:7903:10004:10026:10848:11026:11473:11657:11658:11914:12043:12294:12296:12438:12517:12519:12555:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wine83_60e154500135
X-Filterd-Recvd-Size: 5146
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Geoff Levand <geoff@infradead.org>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        Jens Osterkamp <jens@de.ibm.com>, cbe-oss-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] toshiba: Remove extern from function prototypes
Date: Tue, 24 Sep 2013 14:10:02 -0700
Message-Id: <3e0dd1f4722f8e0c10a47b9bbb26e891e79fef60.1380056108.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1380056108.git.joe@perches.com>
References: <cover.1380056108.git.joe@perches.com>
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
 drivers/net/ethernet/toshiba/ps3_gelic_net.h      | 29 +++++++++++------------
 drivers/net/ethernet/toshiba/ps3_gelic_wireless.h |  6 ++---
 drivers/net/ethernet/toshiba/spider_net.h         |  4 ++--
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.h b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
index 309abb4..8505196 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.h
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
@@ -359,27 +359,26 @@ static inline void *port_priv(struct gelic_port *port)
 }
 
 #ifdef CONFIG_PPC_EARLY_DEBUG_PS3GELIC
-extern void udbg_shutdown_ps3gelic(void);
+void udbg_shutdown_ps3gelic(void);
 #else
 static inline void udbg_shutdown_ps3gelic(void) {}
 #endif
 
-extern int gelic_card_set_irq_mask(struct gelic_card *card, u64 mask);
+int gelic_card_set_irq_mask(struct gelic_card *card, u64 mask);
 /* shared netdev ops */
-extern void gelic_card_up(struct gelic_card *card);
-extern void gelic_card_down(struct gelic_card *card);
-extern int gelic_net_open(struct net_device *netdev);
-extern int gelic_net_stop(struct net_device *netdev);
-extern int gelic_net_xmit(struct sk_buff *skb, struct net_device *netdev);
-extern void gelic_net_set_multi(struct net_device *netdev);
-extern void gelic_net_tx_timeout(struct net_device *netdev);
-extern int gelic_net_change_mtu(struct net_device *netdev, int new_mtu);
-extern int gelic_net_setup_netdev(struct net_device *netdev,
-				  struct gelic_card *card);
+void gelic_card_up(struct gelic_card *card);
+void gelic_card_down(struct gelic_card *card);
+int gelic_net_open(struct net_device *netdev);
+int gelic_net_stop(struct net_device *netdev);
+int gelic_net_xmit(struct sk_buff *skb, struct net_device *netdev);
+void gelic_net_set_multi(struct net_device *netdev);
+void gelic_net_tx_timeout(struct net_device *netdev);
+int gelic_net_change_mtu(struct net_device *netdev, int new_mtu);
+int gelic_net_setup_netdev(struct net_device *netdev, struct gelic_card *card);
 
 /* shared ethtool ops */
-extern void gelic_net_get_drvinfo(struct net_device *netdev,
-				  struct ethtool_drvinfo *info);
-extern void gelic_net_poll_controller(struct net_device *netdev);
+void gelic_net_get_drvinfo(struct net_device *netdev,
+			   struct ethtool_drvinfo *info);
+void gelic_net_poll_controller(struct net_device *netdev);
 
 #endif /* _GELIC_NET_H */
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_wireless.h b/drivers/net/ethernet/toshiba/ps3_gelic_wireless.h
index f7e51b7..11f443d 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_wireless.h
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_wireless.h
@@ -320,7 +320,7 @@ struct gelic_eurus_cmd {
 #define GELIC_WL_PRIV_SET_PSK		(SIOCIWFIRSTPRIV + 0)
 #define GELIC_WL_PRIV_GET_PSK		(SIOCIWFIRSTPRIV + 1)
 
-extern int gelic_wl_driver_probe(struct gelic_card *card);
-extern int gelic_wl_driver_remove(struct gelic_card *card);
-extern void gelic_wl_interrupt(struct net_device *netdev, u64 status);
+int gelic_wl_driver_probe(struct gelic_card *card);
+int gelic_wl_driver_remove(struct gelic_card *card);
+void gelic_wl_interrupt(struct net_device *netdev, u64 status);
 #endif /* _GELIC_WIRELESS_H */
diff --git a/drivers/net/ethernet/toshiba/spider_net.h b/drivers/net/ethernet/toshiba/spider_net.h
index 4ba2135..9b6af08 100644
--- a/drivers/net/ethernet/toshiba/spider_net.h
+++ b/drivers/net/ethernet/toshiba/spider_net.h
@@ -29,8 +29,8 @@
 
 #include <linux/sungem_phy.h>
 
-extern int spider_net_stop(struct net_device *netdev);
-extern int spider_net_open(struct net_device *netdev);
+int spider_net_stop(struct net_device *netdev);
+int spider_net_open(struct net_device *netdev);
 
 extern const struct ethtool_ops spider_net_ethtool_ops;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

