Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab3EPHQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:16:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:62970 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903Ab3EPHQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:16:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="242319709"
Date: Thu, 16 May 2013 12:11:09 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au, arnd@arndb.de,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH 08/39] dmaengine: ste_dma40: Remove redundant address
 fetching function
Message-ID: <20130516064109.GG14863@intel.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-9-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368611522-9984-9-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 10:51:31AM +0100, Lee Jones wrote:
> Addresses are now stored in local data structures and are easy to
> obtain, thus a specialist function used to fetch them is now surplus
> to requirement.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
Acked-by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod
>  drivers/dma/ste_dma40.c |   18 ------------------
>  1 file changed, 18 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 57a127e..6ed7757 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -2267,24 +2267,6 @@ err:
>  	return NULL;
>  }
>  
> -static dma_addr_t
> -d40_get_dev_addr(struct d40_chan *chan, enum dma_transfer_direction direction)
> -{
> -	struct stedma40_platform_data *plat = chan->base->plat_data;
> -	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
> -	dma_addr_t addr = 0;
> -
> -	if (chan->runtime_addr)
> -		return chan->runtime_addr;
> -
> -	if (direction == DMA_DEV_TO_MEM)
> -		addr = plat->dev_rx[cfg->dev_type];
> -	else if (direction == DMA_MEM_TO_DEV)
> -		addr = plat->dev_tx[cfg->dev_type];
> -
> -	return addr;
> -}
> -
>  static struct dma_async_tx_descriptor *
>  d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
>  	    struct scatterlist *sg_dst, unsigned int sg_len,
> -- 
> 1.7.10.4
> 
