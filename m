Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab3HATfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:35:51 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:21420 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab3HATfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:35:41 -0400
Message-ID: <b7ed5023c15e0044201d95921fef1f909d35dd32.1375385120.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375385119.git.cmetcalf@tilera.com>
References: <20130801.113100.2059303096028571906.davem@davemloft.net>
	<cover.1375385119.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 1 Aug 2013 11:36:42 -0400
Subject: [PATCH v3 08/13] tile: enable GRO in the tilegx network driver
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/net/ethernet/tile/tilegx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
index 17bcf33..2b1c31f 100644
--- a/drivers/net/ethernet/tile/tilegx.c
+++ b/drivers/net/ethernet/tile/tilegx.c
@@ -422,7 +422,7 @@ static void tile_net_receive_skb(struct net_device *dev, struct sk_buff *skb,
 	if (idesc->cs && idesc->csum_seed_val == 0xFFFF)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
-	netif_receive_skb(skb);
+	napi_gro_receive(&info->napi, skb);
 
 	/* Update stats. */
 	tile_net_stats_add(1, &dev->stats.rx_packets);
-- 
1.8.3.1

