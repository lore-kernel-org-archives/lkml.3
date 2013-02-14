Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625Ab3BNO1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:27:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:50623 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933950Ab3BNO1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:27:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,665,1355126400"; 
   d="scan'208";a="287219894"
Date: Thu, 14 Feb 2013 19:56:32 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Dan Williams <djbw@fb.com>, linux-kernel@vger.kernel.org,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] dmaengine: ste_dma40: do not remove descriptors for
 cyclic transfers
Message-ID: <20130214142632.GF29960@intel.com>
References: <1360832590-26562-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360832590-26562-1-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 10:03:10AM +0100, Fabio Baltieri wrote:
> Fix dma_tc_handle() to call d40_desc_remove() and d40_desc_done() only
> for non-cyclic transfers, as this was breaking ux500_pcm since
> introduced in:
> 
> d49278e dmaengine: dma40: Add support to split up large elements
> 
> Reported-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
> 
> Hello Vinod,
> 
> the bug fixed by this patch was around for some time, but the affected
> driver (ux500_pcm) will be enabled in next release cycle for other
> reasons so this patch can safely go on -next.
> 
> Would you take it your tree?
Sure, applied thanks

--
~Vinod
> 
> Thanks,
> Fabio
> 
>  drivers/dma/ste_dma40.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index ad860a2..1734fee 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -1570,10 +1570,10 @@ static void dma_tc_handle(struct d40_chan *d40c)
>  			d40c->busy = false;
>  		pm_runtime_mark_last_busy(d40c->base->dev);
>  		pm_runtime_put_autosuspend(d40c->base->dev);
> -	}
>  
> -	d40_desc_remove(d40d);
> -	d40_desc_done(d40c, d40d);
> +		d40_desc_remove(d40d);
> +		d40_desc_done(d40c, d40d);
> +	}
>  
>  	d40c->pending_tx++;
>  	tasklet_schedule(&d40c->tasklet);
> -- 
> 1.7.12.1
> 
