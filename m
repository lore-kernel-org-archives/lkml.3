Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab3KYP1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:27:43 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:61976 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab3KYP1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:27:33 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        bhutchings@solarflare.com, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v2 4/6] net: MOXA ART: add IFF_LIVE_ADDR_CHANGE flag
Date: Mon, 25 Nov 2013 16:27:06 +0100
Message-Id: <1385393228-22416-4-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1385393228-22416-1-git-send-email-jonas.jensen@gmail.com>
References: <1385393228-22416-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.ndo_set_mac_address hook callback already supports IFF_LIVE_ADDR_CHANGE
so add it to our flags.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Applies to next-20131125

 drivers/net/ethernet/moxa/moxart_ether.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index cd46a23..d1c4a83 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -722,7 +722,7 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	ether_setup(ndev);
 	ndev->netdev_ops = &moxart_netdev_ops;
 	netif_napi_add(ndev, &priv->napi, moxart_rx_poll, RX_DESC_NUM);
-	ndev->priv_flags |= IFF_UNICAST_FLT;
+	ndev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE;
 	ndev->irq = irq;
 
 	SET_NETDEV_DEV(ndev, &pdev->dev);
-- 
1.8.2.1

