Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbaIQNFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:05:48 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48175 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaIQNFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:05:45 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: netdev@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Meelis Roos <mroos@linux.ee>
Subject: [PATCH 2/2] 3c59x: Fix bad offset spec in skb_frag_dma_map
Date: Wed, 17 Sep 2014 09:04:45 -0400
Message-Id: <1410959085-7351-2-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410959085-7351-1-git-send-email-nhorman@tuxdriver.com>
References: <alpine.LRH.2.11.1409160209280.21050@adalberg.ut.ee>
 <1410959085-7351-1-git-send-email-nhorman@tuxdriver.com>
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently aded the use of skb_frag_dma_map to 3c59x, but didn't realize it
automatically included the frag_offset internally, as well as provided an option
to specify an extra offset in the parameter list.  We need to specify an offset
of 0 in the parameter list to avoid skb corruption that results in lost
connections.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>
CC: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
---
 drivers/net/ethernet/3com/3c59x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 5621dab..0f59d68 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -2186,7 +2186,7 @@ boomerang_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 			dma_addr = skb_frag_dma_map(&VORTEX_PCI(vp)->dev, frag,
-						    frag->page_offset,
+						    0,
 						    frag->size,
 						    DMA_TO_DEVICE);
 			if (dma_mapping_error(&VORTEX_PCI(vp)->dev, dma_addr)) {
-- 
1.9.3

