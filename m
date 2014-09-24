Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaIXJah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:30:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43152 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIXJad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:30:33 -0400
Date: Wed, 24 Sep 2014 09:30:21 +0000
From: "Sylvain 'ythier' Hitier" <sylvain.hitier@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Meelis Roos <mroos@linux.ee>
Subject: [PATCH] 3c59x: fix bad split of cpu_to_le32(pci_map_single())
Message-ID: <20140924093021.GA7929@erable>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Author: Sylvain "ythier" Hitier <sylvain.hitier@gmail.com>
Date:   Wed Sep 24 09:22:16 2014 +0000

        3c59x: fix bad split of cpu_to_le32(pci_map_single())
    
        Change the #else branch like the #if DO_ZEROCOPY branch was changed.
    
        Fixes: 6f2b6a3005b2c34c39f207a87667564f64f2f91a
          # 3c59x: Add dma error checking and recovery
    
        Signed-off-by: Sylvain "ythier" Hitier <sylvain.hitier@gmail.com>

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 8ca49f04..0a3108b3 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -2214,7 +2214,7 @@ boomerang_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 	}
 #else
-	dma_addr = cpu_to_le32(pci_map_single(VORTEX_PCI(vp), skb->data, skb->len, PCI_DMA_TODEVICE));
+	dma_addr = pci_map_single(VORTEX_PCI(vp), skb->data, skb->len, PCI_DMA_TODEVICE);
 	if (dma_mapping_error(&VORTEX_PCI(vp)->dev, dma_addr))
 		goto out_dma_err;
 	vp->tx_ring[entry].addr = cpu_to_le32(dma_addr);



Regards,
Sylvain "ythier" Hitier

-- 
Business is about being busy, not being rich...
Lived 777 days in a Debian package => http://en.wikipedia.org/wiki/Apt,_Vaucluse
There's THE room for ideals in this mechanical place!
