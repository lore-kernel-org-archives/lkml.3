Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3KYP1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:27:30 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:44316 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab3KYP12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:27:28 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        bhutchings@solarflare.com, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v2 1/6] net: MOXA ART: clear TX descriptor length bits between sends
Date: Mon, 25 Nov 2013 16:27:03 +0100
Message-Id: <1385393228-22416-1-git-send-email-jonas.jensen@gmail.com>
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
    Applies to next-20131125

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

