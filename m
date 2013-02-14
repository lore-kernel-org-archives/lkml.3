Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab3BNJqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:46:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:40164 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910Ab3BNJqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:46:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,664,1355126400"; 
   d="scan'208";a="285643466"
Date: Thu, 14 Feb 2013 15:15:16 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH v2] dw_dmac: apply default dma_mask if needed
Message-ID: <20130214094515.GC27887@intel.com>
References: <1360831270-5777-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360831270-5777-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 10:41:09AM +0200, Andy Shevchenko wrote:
> In some cases we got the device without dma_mask configured. We have to apply
> the default value to avoid crashes during memory mapping.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Applied, thanks

> ---
> Since v1:
> - rebased on top of recent next branch from Vinod
>  drivers/dma/dw_dmac.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 6694676..4c83f18 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1661,6 +1661,12 @@ static int dw_probe(struct platform_device *pdev)
>  	if (!regs)
>  		return -EBUSY;
>  
> +	/* Apply default dma_mask if needed */
> +	if (!pdev->dev.dma_mask) {
> +		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> +		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> +	}
> +
>  	dw_params = dma_read_byaddr(regs, DW_PARAMS);
>  	autocfg = dw_params >> DW_PARAMS_EN & 0x1;
>  
> -- 
> 1.7.10.4
> 
