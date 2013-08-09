Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030620Ab3HIS0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:26:19 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56609 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967991Ab3HIS0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:26:17 -0400
From: Kumar Gaurav <kumargauravgupta3@gmail.com>
To: davem@davemloft.net, jiri@resnulli.us, gregkh@linuxfoundation.org,
        yongjun_wei@trendmicro.com.cn, konszert@marvell.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Kumar Gaurav <kumargauravgupta3@gmail.com>
Subject: [PATCH 17/17] net:ethernet:lantiq_etop.c: Removed deprecated IRQF_DISABLED
Date: Fri,  9 Aug 2013 23:55:59 +0530
Message-Id: <1376072759-11814-1-git-send-email-kumargauravgupta3@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed IRQF_DISABLED as it is deprecated and fixed a coding style issue
of more than 80 chars on single line by sliting the line in two.

Signed-off-by: Kumar Gaurav <kumargauravgupta3@gmail.com>
---
 drivers/net/ethernet/lantiq_etop.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index bfdb0686..04c3a82 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -282,7 +282,7 @@ ltq_etop_hw_init(struct net_device *dev)
 
 		if (IS_TX(i)) {
 			ltq_dma_alloc_tx(&ch->dma);
-			request_irq(irq, ltq_etop_dma_irq, IRQF_DISABLED,
+			request_irq(irq, ltq_etop_dma_irq, 0,
 				"etop_tx", priv);
 		} else if (IS_RX(i)) {
 			ltq_dma_alloc_rx(&ch->dma);
@@ -291,7 +291,7 @@ ltq_etop_hw_init(struct net_device *dev)
 				if (ltq_etop_alloc_skb(ch))
 					return -ENOMEM;
 			ch->dma.desc = 0;
-			request_irq(irq, ltq_etop_dma_irq, IRQF_DISABLED,
+			request_irq(irq, ltq_etop_dma_irq, 0,
 				"etop_rx", priv);
 		}
 		ch->dma.irq = irq;
@@ -653,7 +653,9 @@ ltq_etop_init(struct net_device *dev)
 	if (err)
 		goto err_netdev;
 
-	/* Set addr_assign_type here, ltq_etop_set_mac_address would reset it. */
+	/* Set addr_assign_type here,
+	 *ltq_etop_set_mac_address would reset it.
+	 */
 	if (random_mac)
 		dev->addr_assign_type = NET_ADDR_RANDOM;
 
-- 
1.7.9.5

