Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3IWFMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 01:12:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:37737 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab3IWFMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 01:12:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,960,1371106800"; 
   d="scan'208";a="364128788"
Date: Mon, 23 Sep 2013 09:51:43 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] DMA: ste_dma40: use a power of 2 check
Message-ID: <20130923042143.GB17188@intel.com>
References: <Pine.LNX.4.64.1309180919470.30215@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1309180919470.30215@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 09:33:08AM +0200, Guennadi Liakhovetski wrote:
> dst_addr_width and src_addr_width should be a power of 2. Currently the 
> driver checks, that they both lie between 1 and 8 and that they are eqal 
typo								     ^^^^^
> to 1 or even. This however leaves an invalid value of 6 uncaught. Use an 
> explicit power of 2 check instead.
> 
Applied, with typo fix above..

~Vinod
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> ---
> 
> Compile tested only. I think 6 is an invalid value in this case, and since 
> you check for odd calues, it seems to me that any value can be supplied 
> here, so, looks like a power of 2 test is a better match for this.
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 82d2b97..3d5e4ee 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -14,6 +14,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/clk.h>
>  #include <linux/delay.h>
> +#include <linux/log2.h>
>  #include <linux/pm.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/err.h>
> @@ -2796,8 +2797,8 @@ static int d40_set_runtime_config(struct dma_chan *chan,
>  	    src_addr_width >  DMA_SLAVE_BUSWIDTH_8_BYTES   ||
>  	    dst_addr_width <= DMA_SLAVE_BUSWIDTH_UNDEFINED ||
>  	    dst_addr_width >  DMA_SLAVE_BUSWIDTH_8_BYTES   ||
> -	    ((src_addr_width > 1) && (src_addr_width & 1)) ||
> -	    ((dst_addr_width > 1) && (dst_addr_width & 1)))
> +	    !is_power_of_2(src_addr_width) ||
> +	    !is_power_of_2(dst_addr_width))
>  		return -EINVAL;
>  
>  	cfg->src_info.data_width = src_addr_width;

-- 
