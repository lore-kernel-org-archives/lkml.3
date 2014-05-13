Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaEMFIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 01:08:01 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:56679 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaEMFH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 01:07:59 -0400
From: xuyongjiande@gmail.com
To: eric.dumazet@gmail.com
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yongjian Xu <xuyongjiande@gmail.com>
Subject: [PATCH] e1000: remove the check: skb->len<=0
Date: Tue, 13 May 2014 13:07:09 +0800
Message-Id: <1399957629-13536-1-git-send-email-xuyongjiande@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yongjian Xu <xuyongjiande@gmail.com>

There is no case skb->len would be 0 or 'negative'.
Remove the check.

Signed-off-by: Yongjian Xu <xuyongjiande@gmail.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 27058df..660971f 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -3105,11 +3105,6 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 	 */
 	tx_ring = adapter->tx_ring;
 
-	if (unlikely(skb->len <= 0)) {
-		dev_kfree_skb_any(skb);
-		return NETDEV_TX_OK;
-	}
-
 	/* On PCI/PCI-X HW, if packet size is less than ETH_ZLEN,
 	 * packets may get corrupted during padding by HW.
 	 * To WA this issue, pad all small packets manually.
-- 
1.9.1

