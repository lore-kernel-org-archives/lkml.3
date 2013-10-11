Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab3JKCrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 22:47:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:51244 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab3JKCre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 22:47:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1076,1371106800"; 
   d="scan'208";a="306412164"
Date: Fri, 11 Oct 2013 07:25:02 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, horms@verge.net.au
Subject: Re: [PATCH 1/2] rcar-hpbdma: remove shdma_free_irq() calls
Message-ID: <20131011015502.GD2954@intel.com>
References: <201309260228.37765.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309260228.37765.sergei.shtylyov@cogentembedded.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
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
> 
> Reported-by: Simon Horman <horms@verge.net.au>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Applied both, Thanks

~Vinod
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

-- 
