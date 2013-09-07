Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750983Ab3IGG4z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 02:56:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49718 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750832Ab3IGG4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 02:56:54 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: davem@davemloft.net
Cc: jogo@openwrt.org, joe@perches.com, jg1.han@samsung.com, mbizon@freebox.fr,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] bcm63xx_enet: remove deprecated IRQF_DISABLED
Date: Sat,  7 Sep 2013 08:56:50 +0200
Message-Id: <1378537010-7128-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from
drivers/net/ethernet/broadcom/bcm63xx_enet.c

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 8ac48fb..b9a5fb6 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -926,13 +926,13 @@ static int bcm_enet_open(struct net_device *dev)
 	if (ret)
 		goto out_phy_disconnect;
 
-	ret = request_irq(priv->irq_rx, bcm_enet_isr_dma, IRQF_DISABLED,
+	ret = request_irq(priv->irq_rx, bcm_enet_isr_dma, 0,
 			  dev->name, dev);
 	if (ret)
 		goto out_freeirq;
 
 	ret = request_irq(priv->irq_tx, bcm_enet_isr_dma,
-			  IRQF_DISABLED, dev->name, dev);
+			  0, dev->name, dev);
 	if (ret)
 		goto out_freeirq_rx;
 
@@ -2156,13 +2156,13 @@ static int bcm_enetsw_open(struct net_device *dev)
 	enet_dmac_writel(priv, 0, ENETDMAC_IRMASK, priv->tx_chan);
 
 	ret = request_irq(priv->irq_rx, bcm_enet_isr_dma,
-			  IRQF_DISABLED, dev->name, dev);
+			  0, dev->name, dev);
 	if (ret)
 		goto out_freeirq;
 
 	if (priv->irq_tx != -1) {
 		ret = request_irq(priv->irq_tx, bcm_enet_isr_dma,
-				  IRQF_DISABLED, dev->name, dev);
+				  0, dev->name, dev);
 		if (ret)
 			goto out_freeirq_rx;
 	}
-- 
1.8.1.2

