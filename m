Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3IZCOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:14:21 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34938 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3IZCOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:14:20 -0400
Date: Thu, 26 Sep 2013 11:14:17 +0900
From: Simon Horman <horms@verge.net.au>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/2] rcar-hpbdma: remove shdma_free_irq() calls
Message-ID: <20130926021417.GC18396@verge.net.au>
References: <201309260228.37765.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309260228.37765.sergei.shtylyov@cogentembedded.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 02:28:37AM +0400, Sergei Shtylyov wrote:
> Commit c1c63a14f4f2419d093acd7164eccdff315baa86 (DMA: shdma: switch to managed
> resource allocation) got rid of shdma_free_irq() but  unfortunately got merged
> later than commit c4f6c41ba790bbbfcebb4c47a709ac8ff1fe1af9 (dma: add driver for
> R-Car HPB-DMAC), so that the HPB-DMAC driver retained the calls and got broken:
> 
> drivers/dma/sh/rcar-hpbdma.c: In function `hpb_dmae_alloc_chan_resources':
> drivers/dma/sh/rcar-hpbdma.c:435: error: implicit declaration of function
> `shdma_free_irq'
> 
> Fix this compilation error by removing the remaining shdma_free_irq() calls.

Tested-by: Simon Horman <horms+renesas@verge.net.au>

> Reported-by: Simon Horman <horms@verge.net.au>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> The patch is against 'fixes-3.12' branch of Vinod Koul's 'slave-dma.git' repo.
> 
>  drivers/dma/sh/rcar-hpbdma.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> Index: slave-dma/drivers/dma/sh/rcar-hpbdma.c
> ===================================================================
> --- slave-dma.orig/drivers/dma/sh/rcar-hpbdma.c
> +++ slave-dma/drivers/dma/sh/rcar-hpbdma.c
> @@ -432,7 +432,6 @@ hpb_dmae_alloc_chan_resources(struct hpb
>  		hpb_chan->xfer_mode = XFER_DOUBLE;
>  	} else {
>  		dev_err(hpb_chan->shdma_chan.dev, "DCR setting error");
> -		shdma_free_irq(&hpb_chan->shdma_chan);
>  		return -EINVAL;
>  	}
>  
> @@ -614,7 +613,6 @@ static void hpb_dmae_chan_remove(struct 
>  	shdma_for_each_chan(schan, &hpbdev->shdma_dev, i) {
>  		BUG_ON(!schan);
>  
> -		shdma_free_irq(schan);
>  		shdma_chan_remove(schan);
>  	}
>  	dma_dev->chancnt = 0;
> 
