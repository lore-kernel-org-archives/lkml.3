Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab3AUJi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:38:59 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61689 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3AUJi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:38:58 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Mugunthan V N <mugunthanvnm@ti.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: davinci: Fix build breakage
Date: Mon, 21 Jan 2013 10:38:39 +0100
Message-Id: <1358761119-25846-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
X-Provags-ID: V02:K0:s1R7YL0SybXL/Q0xw4dTUMQTNuVeY0oc4YhE7PJYbMd
 ewsntB5xTBhBBqyk0RMoCuh9CjpZuAJlmqee2caJVBHxC/qzCa
 JRv6P4IadnACndtaFXHkffSuep7OeCysieUuBfUsW1/OpywQbt
 bztLekB02gmz5MoUArSjekQCwfiKAaqVRICaOwxmXeUIgLJpg9
 1OKSKivQ468v/tB6ypT2IRU2wxl9C1yXuBqC3GyT19Nhm8ozLf
 n9Wi28IAL89osG01u4ZDNaqbETn3gI0CAyQ3jWhrot9Lv8olRo
 zBw/XONKatGtuyvHHBDkRDbFKQfeqwgZEicMyodt+xe9GNA36V
 cxSJuoSjz9IrSrg9Gkw1eViys+bjyfgRsSyDnVFrKOvZVkeg4V
 8jsK7hmJkSDEVm4ljzYXq/0+NZT0NArEL5Cgqh34m9dnNO/GK/
 XyePM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The correct name of the transmit DMA channel field in struct emac_priv
is txchan, not txch.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/net/ethernet/ti/davinci_emac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 1c97c81..242ec55 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1102,7 +1102,7 @@ static int emac_dev_xmit(struct sk_buff *skb, struct net_device *ndev)
 	/* If there is no more tx desc left free then we need to
 	 * tell the kernel to stop sending us tx frames.
 	 */
-	if (unlikely(cpdma_check_free_tx_desc(priv->txch)))
+	if (unlikely(cpdma_check_free_tx_desc(priv->txchan)))
 		netif_stop_queue(ndev);
 
 	return NETDEV_TX_OK;
-- 
1.8.1.1

