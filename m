Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbaFWNpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:45:47 -0400
Received: from smtprelay0021.hostedemail.com ([216.40.44.21]:45074 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756105AbaFWNm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:968:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2729:3138:3139:3140:3141:3142:3352:3865:3867:4225:4250:4321:4419:5007:6119:6261:8603:10004:10026:10848:11026:11473:11658:11914:12043:12114:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stem19_8e04f22b0c84a
X-Filterd-Recvd-Size: 2262
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 16/22] mwl8k: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:44 -0700
Message-Id: <5a221c96b8c3ab59cf343fda8e86397259ca224e.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/mwl8k.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 3c0a0a8..7e6b981 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1159,12 +1159,11 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
 
 	size = MWL8K_RX_DESCS * priv->rxd_ops->rxd_size;
 
-	rxq->rxd = pci_alloc_consistent(priv->pdev, size, &rxq->rxd_dma);
+	rxq->rxd = pci_zalloc_consistent(priv->pdev, size, &rxq->rxd_dma);
 	if (rxq->rxd == NULL) {
 		wiphy_err(hw->wiphy, "failed to alloc RX descriptors\n");
 		return -ENOMEM;
 	}
-	memset(rxq->rxd, 0, size);
 
 	rxq->buf = kcalloc(MWL8K_RX_DESCS, sizeof(*rxq->buf), GFP_KERNEL);
 	if (rxq->buf == NULL) {
@@ -1451,12 +1450,11 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 
 	size = MWL8K_TX_DESCS * sizeof(struct mwl8k_tx_desc);
 
-	txq->txd = pci_alloc_consistent(priv->pdev, size, &txq->txd_dma);
+	txq->txd = pci_zalloc_consistent(priv->pdev, size, &txq->txd_dma);
 	if (txq->txd == NULL) {
 		wiphy_err(hw->wiphy, "failed to alloc TX descriptors\n");
 		return -ENOMEM;
 	}
-	memset(txq->txd, 0, size);
 
 	txq->skb = kcalloc(MWL8K_TX_DESCS, sizeof(*txq->skb), GFP_KERNEL);
 	if (txq->skb == NULL) {
-- 
1.8.1.2.459.gbcd45b4.dirty

