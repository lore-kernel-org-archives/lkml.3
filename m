Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab3BLQkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:40:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:28300 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758698Ab3BLQkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:40:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="284754442"
Date: Tue, 12 Feb 2013 08:16:04 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] dw_dmac: apply default dma_mask if needed
Message-ID: <20130212161604.GO3789@intel.com>
References: <1359471984-26336-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359471984-26336-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 05:06:24PM +0200, Andy Shevchenko wrote:
> In some cases we got the device without dma_mask configured. We have to apply
> the default value to avoid crashes during memory mapping.
> 
what was this generated against, it fails to apply for me.

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index e8d0679..a572a1e 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1673,6 +1673,12 @@ static int dw_probe(struct platform_device *pdev)
>  	if (IS_ERR(regs))
>  		return PTR_ERR(regs);
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
