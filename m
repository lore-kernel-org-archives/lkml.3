Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaDLJ5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 05:57:22 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:54992 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaDLJ5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 05:57:20 -0400
From: Vincenzo Maffione <v.maffione@gmail.com>
To: konrad.wilk@oracle.com
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vincenzo Maffione <v.maffione@gmail.com>
Subject: [PATCH] drivers: net: xen-netfront: fix array initialization bug
Date: Sat, 12 Apr 2014 11:55:40 +0200
Message-Id: <1397296540-3007-1-git-send-email-v.maffione@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the initialization of an array used in the TX
datapath that was mistakenly initialized together with the
RX datapath arrays. An out of range array access could happen
when RX and TX rings had different sizes.

Signed-off-by: Vincenzo Maffione <v.maffione@gmail.com>
---
 drivers/net/xen-netfront.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 057b057..158b5e6 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1291,13 +1291,13 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
 	for (i = 0; i < NET_TX_RING_SIZE; i++) {
 		skb_entry_set_link(&np->tx_skbs[i], i+1);
 		np->grant_tx_ref[i] = GRANT_INVALID_REF;
+		np->grant_tx_page[i] = NULL;
 	}
 
 	/* Clear out rx_skbs */
 	for (i = 0; i < NET_RX_RING_SIZE; i++) {
 		np->rx_skbs[i] = NULL;
 		np->grant_rx_ref[i] = GRANT_INVALID_REF;
-		np->grant_tx_page[i] = NULL;
 	}
 
 	/* A grant for every tx ring slot */
-- 
1.9.1

