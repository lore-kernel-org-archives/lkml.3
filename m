Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaGZP4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 11:56:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:44607 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbaGZP4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 11:56:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,735,1400050800"; 
   d="scan'208";a="461729749"
Date: Sat, 26 Jul 2014 21:19:30 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Randy Dunlap <rdunlap@infradead.org>, Simon Horman <horms@verge.net.au>
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH -next] dma/sh: fix rcar-dma.c printk format warnings
Message-ID: <20140726154930.GX8181@intel.com>
References: <53D28DAF.9090506@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D28DAF.9090506@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 10:02:39AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix printk format warnings by using size_t modifiers ('z'):
> 
> ../drivers/dma/sh/rcar-dmac.c:759:4: warning: format '%u' expects argument of type 'unsigned int', but argument 9 has type 'size_t' [-Wformat=]
> ../drivers/dma/sh/rcar-dmac.c:759:4: warning: format '%u' expects argument of type 'unsigned int', but argument 10 has type 'size_t' [-Wformat=]
> 
This is not present in dmaengine trees. Simon is this in your tree?

-- 
~Vinod


> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: dmaengine@vger.kernel.org
> ---
>  drivers/dma/sh/rcar-dmac.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-next-20140725/drivers/dma/sh/rcar-dmac.c
> ===================================================================
> --- linux-next-20140725.orig/drivers/dma/sh/rcar-dmac.c
> +++ linux-next-20140725/drivers/dma/sh/rcar-dmac.c
> @@ -757,7 +757,7 @@ rcar_dmac_chan_prep_sg(struct rcar_dmac_
>  			hwdesc->size = size;
>  
>  			dev_dbg(chan->chan.device->dev,
> -				"chan%u: hwdesc %p/%p sgl %u@%p, %u/%u %pad -> %pad\n",
> +				"chan%u: hwdesc %p/%p sgl %u@%p, %zu/%zu %pad -> %pad\n",
>  				chan->index, hwdesc, desc, i, sg, size, len,
>  				&hwdesc->src_addr, &hwdesc->dst_addr);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
