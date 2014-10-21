Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbaJUJiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:38:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:54233 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbaJUJiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:38:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,761,1406617200"; 
   d="scan'208";a="617762575"
Message-ID: <1413884289.2396.22.camel@linux.intel.com>
Subject: Re: [PATCH v4 2/3] dma: imx-sdma: correct print format
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Robin Gong <b38343@freescale.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 21 Oct 2014 12:38:09 +0300
In-Reply-To: <1413853781-18384-3-git-send-email-b38343@freescale.com>
References: <1413853781-18384-1-git-send-email-b38343@freescale.com>
	 <1413853781-18384-3-git-send-email-b38343@freescale.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 09:09 +0800, Robin Gong wrote:
> correct print format for 'size_t', 'dma_address_t',etc.

Ah, okay, you may disregard few of my comments to previous patch.

But here, please, fix the style of commit message (spaces, capital
letters, etc).

> 
> Signed-off-by: Robin Gong <b38343@freescale.com>
> ---
>  drivers/dma/imx-sdma.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index fc4a0df..7e8aa2d 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -1041,7 +1041,7 @@ static struct dma_async_tx_descriptor *sdma_prep_memcpy(
>  		return NULL;
>  
>  	if (len >= NUM_BD * SDMA_BD_MAX_CNT) {
> -		dev_err(sdma->dev, "channel%d: maximum bytes exceeded:%d > %d\n"
> +		dev_err(sdma->dev, "channel%d: maximum bytes exceeded:%zu > %d\n"
>  			, channel, len, NUM_BD * SDMA_BD_MAX_CNT);
>  		goto err_out;
>  	}
> @@ -1050,8 +1050,8 @@ static struct dma_async_tx_descriptor *sdma_prep_memcpy(
>  
>  	sdmac->buf_tail = 0;
>  
> -	dev_dbg(sdma->dev, "memcpy: %x->%x, len=%d, channel=%d.\n",
> -		dma_src, dma_dst, len, channel);
> +	dev_dbg(sdma->dev, "memcpy: %pad->%pad, len=%zu, channel=%d.\n",
> +		&dma_src, &dma_dst, len, channel);
>  
>  	sdmac->direction = DMA_MEM_TO_MEM;
>  
> @@ -1104,7 +1104,7 @@ static struct dma_async_tx_descriptor *sdma_prep_memcpy(
>  			param &= ~BD_CONT;
>  		}
>  
> -		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",
> +		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%u %s%s\n",
>  				i, count, bd->buffer_addr,
>  				param & BD_WRAP ? "wrap" : "",
>  				param & BD_INTR ? " intr" : "");
> @@ -1220,8 +1220,8 @@ static struct dma_async_tx_descriptor *sdma_prep_sg(
>  			param &= ~BD_CONT;
>  		}
>  
> -		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",
> -				i, count, sg_src->dma_address,
> +		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%pad %s%s\n",
> +				i, count, &sg_src->dma_address,
>  				param & BD_WRAP ? "wrap" : "",
>  				param & BD_INTR ? " intr" : "");
>  
> @@ -1291,7 +1291,7 @@ static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
>  	}
>  
>  	if (period_len > SDMA_BD_MAX_CNT) {
> -		dev_err(sdma->dev, "SDMA channel %d: maximum period size exceeded: %d > %d\n",
> +		dev_err(sdma->dev, "SDMA channel %d: maximum period size exceeded: %zu > %d\n",
>  				channel, period_len, SDMA_BD_MAX_CNT);
>  		goto err_out;
>  	}
> @@ -1315,8 +1315,8 @@ static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
>  		if (i + 1 == num_periods)
>  			param |= BD_WRAP;
>  
> -		dev_dbg(sdma->dev, "entry %d: count: %d dma: %#llx %s%s\n",
> -				i, period_len, (u64)dma_addr,
> +		dev_dbg(sdma->dev, "entry %d: count: %d dma: %pad %s%s\n",
> +				i, period_len, &dma_addr,
>  				param & BD_WRAP ? "wrap" : "",
>  				param & BD_INTR ? " intr" : "");
>  


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

