Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab3IYTkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:40:04 -0400
Received: from smtprelay0064.hostedemail.com ([216.40.44.64]:50340 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755400Ab3IYTig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:38:36 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:4321:5007:6261:7903:10004:10026:10848:11473:11657:11658:11914:12043:12438:12517:12519:12555:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fall77_7f32cc4a08d59
X-Filterd-Recvd-Size: 3748
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] wan: Remove extern from function prototypes
Date: Wed, 25 Sep 2013 12:37:20 -0700
Message-Id: <65c8f953621acc51fd45662191ca21126b75d142.1380137609.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1380137609.git.joe@perches.com>
References: <cover.1380137609.git.joe@perches.com>
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
 drivers/net/wan/x25_asy.h |  2 +-
 drivers/net/wan/z85230.h  | 27 +++++++++++++--------------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wan/x25_asy.h b/drivers/net/wan/x25_asy.h
index 8f0fc2e..f57ee67 100644
--- a/drivers/net/wan/x25_asy.h
+++ b/drivers/net/wan/x25_asy.h
@@ -41,6 +41,6 @@ struct x25_asy {
 
 #define X25_ASY_MAGIC 0x5303
 
-extern int x25_asy_init(struct net_device *dev);
+int x25_asy_init(struct net_device *dev);
 
 #endif	/* _LINUX_X25_ASY.H */
diff --git a/drivers/net/wan/z85230.h b/drivers/net/wan/z85230.h
index f29d554..2416a9d 100644
--- a/drivers/net/wan/z85230.h
+++ b/drivers/net/wan/z85230.h
@@ -395,20 +395,19 @@ struct z8530_dev
 extern u8 z8530_dead_port[];
 extern u8 z8530_hdlc_kilostream_85230[];
 extern u8 z8530_hdlc_kilostream[];
-extern irqreturn_t z8530_interrupt(int, void *);
-extern void z8530_describe(struct z8530_dev *, char *mapping, unsigned long io);
-extern int z8530_init(struct z8530_dev *);
-extern int z8530_shutdown(struct z8530_dev *);
-extern int z8530_sync_open(struct net_device *, struct z8530_channel *);
-extern int z8530_sync_close(struct net_device *, struct z8530_channel *);
-extern int z8530_sync_dma_open(struct net_device *, struct z8530_channel *);
-extern int z8530_sync_dma_close(struct net_device *, struct z8530_channel *);
-extern int z8530_sync_txdma_open(struct net_device *, struct z8530_channel *);
-extern int z8530_sync_txdma_close(struct net_device *, struct z8530_channel *);
-extern int z8530_channel_load(struct z8530_channel *, u8 *);
-extern netdev_tx_t z8530_queue_xmit(struct z8530_channel *c,
-					  struct sk_buff *skb);
-extern void z8530_null_rx(struct z8530_channel *c, struct sk_buff *skb);
+irqreturn_t z8530_interrupt(int, void *);
+void z8530_describe(struct z8530_dev *, char *mapping, unsigned long io);
+int z8530_init(struct z8530_dev *);
+int z8530_shutdown(struct z8530_dev *);
+int z8530_sync_open(struct net_device *, struct z8530_channel *);
+int z8530_sync_close(struct net_device *, struct z8530_channel *);
+int z8530_sync_dma_open(struct net_device *, struct z8530_channel *);
+int z8530_sync_dma_close(struct net_device *, struct z8530_channel *);
+int z8530_sync_txdma_open(struct net_device *, struct z8530_channel *);
+int z8530_sync_txdma_close(struct net_device *, struct z8530_channel *);
+int z8530_channel_load(struct z8530_channel *, u8 *);
+netdev_tx_t z8530_queue_xmit(struct z8530_channel *c, struct sk_buff *skb);
+void z8530_null_rx(struct z8530_channel *c, struct sk_buff *skb);
 
 
 /*
-- 
1.8.1.2.459.gbcd45b4.dirty

