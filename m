Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab3GaPVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:21:54 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:31245 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab3GaPVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:21:50 -0400
Message-ID: <6cfd1d016086b799235c30684fed6096a36d815a.1375283106.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375283104.git.cmetcalf@tilera.com>
References: <cover.1374609948.git.cmetcalf@tilera.com>
	<cover.1375283104.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 31 Jul 2013 11:05:04 -0400
Subject: [PATCH 07/12] tile: enable GRO in the tilegx network driver
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
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
index 58bd189..3a101b4 100644
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

