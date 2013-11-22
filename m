Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab3KVO5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 09:57:39 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:34886 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab3KVO5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 09:57:37 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH 1/5] net: MOXA ART: clear TX descriptor length bits between sends
Date: Fri, 22 Nov 2013 15:57:18 +0100
Message-Id: <1385132242-3204-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add TX_DESC1_BUF_SIZE_MASK to bits that are cleared, before the TX buffer
length is set. Failing to do so can cause the controller to drop dead
i.e. all TX interrupts stop, resulting in complete communication failure.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Applies to next-20131122

 drivers/net/ethernet/moxa/moxart_ether.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index cbd0133..3c14afd 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -349,7 +349,8 @@ static int moxart_mac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	txdes1 = readl(desc + TX_REG_OFFSET_DESC1);
 	txdes1 |= TX_DESC1_LTS | TX_DESC1_FTS;
-	txdes1 &= ~(TX_DESC1_FIFO_COMPLETE | TX_DESC1_INTR_COMPLETE);
+	txdes1 &= ~(TX_DESC1_FIFO_COMPLETE | TX_DESC1_INTR_COMPLETE |
+		    TX_DESC1_BUF_SIZE_MASK);
 	txdes1 |= (len & TX_DESC1_BUF_SIZE_MASK);
 	writel(txdes1, desc + TX_REG_OFFSET_DESC1);
 	writel(TX_DESC0_DMA_OWN, desc + TX_REG_OFFSET_DESC0);
-- 
1.8.2.1

