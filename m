Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbaFWNnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:43:06 -0400
Received: from smtprelay0030.hostedemail.com ([216.40.44.30]:33797 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756129AbaFWNnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:43:01 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2729:3138:3139:3140:3141:3142:3352:3865:4225:4250:4321:4419:4605:5007:6261:9592:10004:10026:10848:11026:11657:11658:11914:12043:12114:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: word87_8e5fa79106d4d
X-Filterd-Recvd-Size: 2444
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 17/22] rtl818x: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:45 -0700
Message-Id: <b4cf2aa62c7bec157a3e7079cdebe0670cdcba7c.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 1e25929..7577e01 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -964,16 +964,13 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
 	else
 		priv->rx_ring_sz = sizeof(struct rtl8180_rx_desc);
 
-	priv->rx_ring = pci_alloc_consistent(priv->pdev,
-					     priv->rx_ring_sz * 32,
-					     &priv->rx_ring_dma);
-
+	priv->rx_ring = pci_zalloc_consistent(priv->pdev, priv->rx_ring_sz * 32,
+					      &priv->rx_ring_dma);
 	if (!priv->rx_ring || (unsigned long)priv->rx_ring & 0xFF) {
 		wiphy_err(dev->wiphy, "Cannot allocate RX ring\n");
 		return -ENOMEM;
 	}
 
-	memset(priv->rx_ring, 0, priv->rx_ring_sz * 32);
 	priv->rx_idx = 0;
 
 	for (i = 0; i < 32; i++) {
@@ -1032,14 +1029,14 @@ static int rtl8180_init_tx_ring(struct ieee80211_hw *dev,
 	dma_addr_t dma;
 	int i;
 
-	ring = pci_alloc_consistent(priv->pdev, sizeof(*ring) * entries, &dma);
+	ring = pci_zalloc_consistent(priv->pdev, sizeof(*ring) * entries,
+				     &dma);
 	if (!ring || (unsigned long)ring & 0xFF) {
 		wiphy_err(dev->wiphy, "Cannot allocate TX ring (prio = %d)\n",
 			  prio);
 		return -ENOMEM;
 	}
 
-	memset(ring, 0, sizeof(*ring)*entries);
 	priv->tx_ring[prio].desc = ring;
 	priv->tx_ring[prio].dma = dma;
 	priv->tx_ring[prio].idx = 0;
-- 
1.8.1.2.459.gbcd45b4.dirty

