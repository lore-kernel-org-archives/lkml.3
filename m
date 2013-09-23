Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab3IWWLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:11:49 -0400
Received: from smtprelay0239.hostedemail.com ([216.40.44.239]:40949 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754181Ab3IWWLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:11:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:4250:4321:5007:6261:7903:8603:10004:10026:10848:11026:11473:11657:11658:11914:12043:12291:12438:12517:12519:12555:12683:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: card38_2c01d8aa0bd46
X-Filterd-Recvd-Size: 4263
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] 8390: Remove extern from function prototypes
Date: Mon, 23 Sep 2013 15:11:29 -0700
Message-Id: <6ba89944a5841cbbd76b9a1412e1e7b6c41e1efe.1379974101.git.joe@perches.com>
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
 drivers/net/ethernet/8390/8390.h | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/8390/8390.h b/drivers/net/ethernet/8390/8390.h
index ef325ff..2923c51 100644
--- a/drivers/net/ethernet/8390/8390.h
+++ b/drivers/net/ethernet/8390/8390.h
@@ -28,42 +28,42 @@ extern int ei_debug;
 #endif
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
-extern void ei_poll(struct net_device *dev);
-extern void eip_poll(struct net_device *dev);
+void ei_poll(struct net_device *dev);
+void eip_poll(struct net_device *dev);
 #endif
 
 
 /* Without I/O delay - non ISA or later chips */
-extern void NS8390_init(struct net_device *dev, int startp);
-extern int ei_open(struct net_device *dev);
-extern int ei_close(struct net_device *dev);
-extern irqreturn_t ei_interrupt(int irq, void *dev_id);
-extern void ei_tx_timeout(struct net_device *dev);
-extern netdev_tx_t ei_start_xmit(struct sk_buff *skb, struct net_device *dev);
-extern void ei_set_multicast_list(struct net_device *dev);
-extern struct net_device_stats *ei_get_stats(struct net_device *dev);
+void NS8390_init(struct net_device *dev, int startp);
+int ei_open(struct net_device *dev);
+int ei_close(struct net_device *dev);
+irqreturn_t ei_interrupt(int irq, void *dev_id);
+void ei_tx_timeout(struct net_device *dev);
+netdev_tx_t ei_start_xmit(struct sk_buff *skb, struct net_device *dev);
+void ei_set_multicast_list(struct net_device *dev);
+struct net_device_stats *ei_get_stats(struct net_device *dev);
 
 extern const struct net_device_ops ei_netdev_ops;
 
-extern struct net_device *__alloc_ei_netdev(int size);
+struct net_device *__alloc_ei_netdev(int size);
 static inline struct net_device *alloc_ei_netdev(void)
 {
 	return __alloc_ei_netdev(0);
 }
 
 /* With I/O delay form */
-extern void NS8390p_init(struct net_device *dev, int startp);
-extern int eip_open(struct net_device *dev);
-extern int eip_close(struct net_device *dev);
-extern irqreturn_t eip_interrupt(int irq, void *dev_id);
-extern void eip_tx_timeout(struct net_device *dev);
-extern netdev_tx_t eip_start_xmit(struct sk_buff *skb, struct net_device *dev);
-extern void eip_set_multicast_list(struct net_device *dev);
-extern struct net_device_stats *eip_get_stats(struct net_device *dev);
+void NS8390p_init(struct net_device *dev, int startp);
+int eip_open(struct net_device *dev);
+int eip_close(struct net_device *dev);
+irqreturn_t eip_interrupt(int irq, void *dev_id);
+void eip_tx_timeout(struct net_device *dev);
+netdev_tx_t eip_start_xmit(struct sk_buff *skb, struct net_device *dev);
+void eip_set_multicast_list(struct net_device *dev);
+struct net_device_stats *eip_get_stats(struct net_device *dev);
 
 extern const struct net_device_ops eip_netdev_ops;
 
-extern struct net_device *__alloc_eip_netdev(int size);
+struct net_device *__alloc_eip_netdev(int size);
 static inline struct net_device *alloc_eip_netdev(void)
 {
 	return __alloc_eip_netdev(0);
-- 
1.8.1.2.459.gbcd45b4.dirty

