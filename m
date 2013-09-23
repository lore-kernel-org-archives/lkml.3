Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab3IWWLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:11:45 -0400
Received: from smtprelay0014.hostedemail.com ([216.40.44.14]:55030 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752406Ab3IWWLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:11:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1437:1534:1543:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:4321:4384:4605:5007:6261:7903:8603:10004:10026:10848:11026:11657:11658:11914:12043:12294:12296:12438:12517:12519:12555:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: range32_2ba65a05a1c3d
X-Filterd-Recvd-Size: 3926
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Subject: [PATCH 01/10] can: Remove extern from function prototypes
Date: Mon, 23 Sep 2013 15:11:28 -0700
Message-Id: <5570169a078375fa8662adeb2a7f24c1ae718bfb.1379974101.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
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
 drivers/net/can/mscan/mscan.h     |  6 +++---
 drivers/net/can/softing/softing.h | 24 ++++++++++++------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/mscan/mscan.h b/drivers/net/can/mscan/mscan.h
index 9c24d60..e98abb9 100644
--- a/drivers/net/can/mscan/mscan.h
+++ b/drivers/net/can/mscan/mscan.h
@@ -297,8 +297,8 @@ struct mscan_priv {
 	struct napi_struct napi;
 };
 
-extern struct net_device *alloc_mscandev(void);
-extern int register_mscandev(struct net_device *dev, int mscan_clksrc);
-extern void unregister_mscandev(struct net_device *dev);
+struct net_device *alloc_mscandev(void);
+int register_mscandev(struct net_device *dev, int mscan_clksrc);
+void unregister_mscandev(struct net_device *dev);
 
 #endif /* __MSCAN_H__ */
diff --git a/drivers/net/can/softing/softing.h b/drivers/net/can/softing/softing.h
index afd7d85..35f0622 100644
--- a/drivers/net/can/softing/softing.h
+++ b/drivers/net/can/softing/softing.h
@@ -71,34 +71,34 @@ struct softing {
 	} id;
 };
 
-extern int softing_default_output(struct net_device *netdev);
+int softing_default_output(struct net_device *netdev);
 
-extern ktime_t softing_raw2ktime(struct softing *card, u32 raw);
+ktime_t softing_raw2ktime(struct softing *card, u32 raw);
 
-extern int softing_chip_poweron(struct softing *card);
+int softing_chip_poweron(struct softing *card);
 
-extern int softing_bootloader_command(struct softing *card, int16_t cmd,
-		const char *msg);
+int softing_bootloader_command(struct softing *card, int16_t cmd,
+			       const char *msg);
 
 /* Load firmware after reset */
-extern int softing_load_fw(const char *file, struct softing *card,
-			__iomem uint8_t *virt, unsigned int size, int offset);
+int softing_load_fw(const char *file, struct softing *card,
+		    __iomem uint8_t *virt, unsigned int size, int offset);
 
 /* Load final application firmware after bootloader */
-extern int softing_load_app_fw(const char *file, struct softing *card);
+int softing_load_app_fw(const char *file, struct softing *card);
 
 /*
  * enable or disable irq
  * only called with fw.lock locked
  */
-extern int softing_enable_irq(struct softing *card, int enable);
+int softing_enable_irq(struct softing *card, int enable);
 
 /* start/stop 1 bus on card */
-extern int softing_startstop(struct net_device *netdev, int up);
+int softing_startstop(struct net_device *netdev, int up);
 
 /* netif_rx() */
-extern int softing_netdev_rx(struct net_device *netdev,
-		const struct can_frame *msg, ktime_t ktime);
+int softing_netdev_rx(struct net_device *netdev, const struct can_frame *msg,
+		      ktime_t ktime);
 
 /* SOFTING DPRAM mappings */
 #define DPRAM_RX		0x0000
-- 
1.8.1.2.459.gbcd45b4.dirty

