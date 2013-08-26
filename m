Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab3HZWpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 18:45:55 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:36342 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3HZWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 18:45:52 -0400
From: Rob Herring <robherring2@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andreas Herrmann <andreas.herrmann@calxeda.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 01/11] net: calxedaxgmac: remove NETIF_F_FRAGLIST setting
Date: Mon, 26 Aug 2013 17:45:16 -0500
Message-Id: <1377557126-10716-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The xgmac does not actually handle frag lists, so this option should not
be set. It does not appear to have had any impact though.

Reported-by: Lennert Buytenhek <buytenh@wantstofly.org>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/net/ethernet/calxeda/xgmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 7cb148c..71f6720 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1759,7 +1759,7 @@ static int xgmac_probe(struct platform_device *pdev)
 	if (device_can_wakeup(priv->device))
 		priv->wolopts = WAKE_MAGIC;	/* Magic Frame as default */
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA;
+	ndev->hw_features = NETIF_F_SG | NETIF_F_HIGHDMA;
 	if (readl(priv->base + XGMAC_DMA_HW_FEATURE) & DMA_HW_FEAT_TXCOESEL)
 		ndev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				     NETIF_F_RXCSUM;
-- 
1.8.1.2

