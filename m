Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab3FRRcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:32:50 -0400
Received: from shell.v3.sk ([195.168.3.45]:40786 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933102Ab3FRRct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:32:49 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Lubomir Rintel <lkundrak@v3.sk>,
        Lennert Buytenhek <buytenh@wantstofly.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mv643xx_eth: Allocate receive queue initialized to zero
Date: Tue, 18 Jun 2013 19:32:38 +0200
Message-Id: <1371576759-21782-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zero pointer in rx_skb is how respective rxq_deinit() finds out out that a skb
slot is unallocated. If rxq_refill() fails (e.g. on OOM condition), subsequent
teardown would result in an attempt to kfree() invalid pointers.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
 drivers/net/ethernet/marvell/mv643xx_eth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 2ad1494..d1cbfb1 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1757,7 +1757,7 @@ static int rxq_init(struct mv643xx_eth_private *mp, int index)
 	memset(rxq->rx_desc_area, 0, size);
 
 	rxq->rx_desc_area_size = size;
-	rxq->rx_skb = kmalloc_array(rxq->rx_ring_size, sizeof(*rxq->rx_skb),
+	rxq->rx_skb = kcalloc(rxq->rx_ring_size, sizeof(*rxq->rx_skb),
 				    GFP_KERNEL);
 	if (rxq->rx_skb == NULL)
 		goto out_free;
-- 
1.7.1

