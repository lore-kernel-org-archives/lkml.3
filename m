Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab3KYP2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:28:06 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:43079 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab3KYP1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:27:36 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        bhutchings@solarflare.com, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v2 6/6] net: MOXA ART: use eth_mac_addr()
Date: Mon, 25 Nov 2013 16:27:08 +0100
Message-Id: <1385393228-22416-6-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1385393228-22416-1-git-send-email-jonas.jensen@gmail.com>
References: <1385393228-22416-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace boilerplate in moxart_set_mac_address() with eth_mac_addr().

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Applies to next-20131125

 drivers/net/ethernet/moxa/moxart_ether.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index ef7a347..e6e42ee 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -57,12 +57,7 @@ static void moxart_update_mac_address(struct net_device *ndev)
 
 static int moxart_set_mac_address(struct net_device *ndev, void *addr)
 {
-	struct sockaddr *address = addr;
-
-	if (!is_valid_ether_addr(address->sa_data))
-		return -EADDRNOTAVAIL;
-
-	memcpy(ndev->dev_addr, address->sa_data, ndev->addr_len);
+	eth_mac_addr(ndev, addr);
 	moxart_update_mac_address(ndev);
 
 	return 0;
-- 
1.8.2.1

