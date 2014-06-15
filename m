Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaFOUoP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:44:15 -0400
Received: from smtprelay0207.hostedemail.com ([216.40.44.207]:37041 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752056AbaFOUii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:2729:3138:3139:3140:3141:3142:3352:3865:3866:4225:4321:4385:5007:6261:7903:8603:10004:10026:10848:11026:11657:11658:11914:12043:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crib23_67f1a59927351
X-Filterd-Recvd-Size: 2151
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: [PATCH -next 10/26] broadcom: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:39 -0700
Message-Id: <6b329f3d7f7b5f14d19304178bc95f9081b07bf5.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 3e8d1a8..8c61c81 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -2165,27 +2165,25 @@ static int bcm_enetsw_open(struct net_device *dev)
 
 	/* allocate rx dma ring */
 	size = priv->rx_ring_size * sizeof(struct bcm_enet_desc);
-	p = dma_alloc_coherent(kdev, size, &priv->rx_desc_dma, GFP_KERNEL);
+	p = dma_zalloc_coherent(kdev, size, &priv->rx_desc_dma, GFP_KERNEL);
 	if (!p) {
 		dev_err(kdev, "cannot allocate rx ring %u\n", size);
 		ret = -ENOMEM;
 		goto out_freeirq_tx;
 	}
 
-	memset(p, 0, size);
 	priv->rx_desc_alloc_size = size;
 	priv->rx_desc_cpu = p;
 
 	/* allocate tx dma ring */
 	size = priv->tx_ring_size * sizeof(struct bcm_enet_desc);
-	p = dma_alloc_coherent(kdev, size, &priv->tx_desc_dma, GFP_KERNEL);
+	p = dma_zalloc_coherent(kdev, size, &priv->tx_desc_dma, GFP_KERNEL);
 	if (!p) {
 		dev_err(kdev, "cannot allocate tx ring\n");
 		ret = -ENOMEM;
 		goto out_free_rx_ring;
 	}
 
-	memset(p, 0, size);
 	priv->tx_desc_alloc_size = size;
 	priv->tx_desc_cpu = p;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

