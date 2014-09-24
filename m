Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbaIXKQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:16:57 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53108 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaIXKQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:16:56 -0400
Date: Wed, 24 Sep 2014 06:16:47 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: "Sylvain 'ythier' Hitier" <sylvain.hitier@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Meelis Roos <mroos@linux.ee>
Subject: Re: [PATCH] 3c59x: fix bad split of cpu_to_le32(pci_map_single())
Message-ID: <20140924101647.GA4651@hmsreliant.think-freely.org>
References: <20140924093021.GA7929@erable>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924093021.GA7929@erable>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 09:30:21AM +0000, Sylvain 'ythier' Hitier wrote:
> Author: Sylvain "ythier" Hitier <sylvain.hitier@gmail.com>
> Date:   Wed Sep 24 09:22:16 2014 +0000
> 
>         3c59x: fix bad split of cpu_to_le32(pci_map_single())
>     
>         Change the #else branch like the #if DO_ZEROCOPY branch was changed.
>     
>         Fixes: 6f2b6a3005b2c34c39f207a87667564f64f2f91a
>           # 3c59x: Add dma error checking and recovery
>     
>         Signed-off-by: Sylvain "ythier" Hitier <sylvain.hitier@gmail.com>
> 
> diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
> index 8ca49f04..0a3108b3 100644
> --- a/drivers/net/ethernet/3com/3c59x.c
> +++ b/drivers/net/ethernet/3com/3c59x.c
> @@ -2214,7 +2214,7 @@ boomerang_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  		}
>  	}
>  #else
> -	dma_addr = cpu_to_le32(pci_map_single(VORTEX_PCI(vp), skb->data, skb->len, PCI_DMA_TODEVICE));
> +	dma_addr = pci_map_single(VORTEX_PCI(vp), skb->data, skb->len, PCI_DMA_TODEVICE);
>  	if (dma_mapping_error(&VORTEX_PCI(vp)->dev, dma_addr))
>  		goto out_dma_err;
>  	vp->tx_ring[entry].addr = cpu_to_le32(dma_addr);
> 
Actually, scratch my last note.  Sorry, too early here.  This isn't about
removing the cpu_to_le32 as its already preformed in the assignment to .addr.
Thats actually somewhat broken for lots of reasons (previously we did 2
cpu_to_le32 swaps, which seems completely wrong).  You do probably want to fixup
the changelog to be a bit more clear as to whats going on here.
Neil

> 
> 
> Regards,
> Sylvain "ythier" Hitier
> 
> -- 
> Business is about being busy, not being rich...
> Lived 777 days in a Debian package => http://en.wikipedia.org/wiki/Apt,_Vaucluse
> There's THE room for ideals in this mechanical place!
> 
