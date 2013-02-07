Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab3BGUhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 15:37:50 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:46321 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757486Ab3BGUht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 15:37:49 -0500
Message-ID: <1360269467.27863.9.camel@joe-AO722>
Subject: [PATCH] mwl8k: Remove unnecessary alloc/OOM messages
From: Joe Perches <joe@perches.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 07 Feb 2013 12:37:47 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc failures already get standardized OOM
messages and a dump_stack.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/mwl8k.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 224cf91..e31f779 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1146,7 +1146,6 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
 
 	rxq->buf = kcalloc(MWL8K_RX_DESCS, sizeof(*rxq->buf), GFP_KERNEL);
 	if (rxq->buf == NULL) {
-		wiphy_err(hw->wiphy, "failed to alloc RX skbuff list\n");
 		pci_free_consistent(priv->pdev, size, rxq->rxd, rxq->rxd_dma);
 		return -ENOMEM;
 	}
@@ -1439,7 +1438,6 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 
 	txq->skb = kcalloc(MWL8K_TX_DESCS, sizeof(*txq->skb), GFP_KERNEL);
 	if (txq->skb == NULL) {
-		wiphy_err(hw->wiphy, "failed to alloc TX skbuff list\n");
 		pci_free_consistent(priv->pdev, size, txq->txd, txq->txd_dma);
 		return -ENOMEM;
 	}


