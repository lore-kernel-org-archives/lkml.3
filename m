Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab3JQNn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:43:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:50907 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab3JQNn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:43:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,514,1378882800"; 
   d="scan'208";a="394414485"
Message-ID: <1382017411.29062.142.camel@smile>
Subject: Re: [PATCH 08/28] dmaengine: dw: use DMA_COMPLETE for dma
 completion status
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Viresh Kumar <viresh.kumar@linaro.org>
Date: Thu, 17 Oct 2013 16:43:31 +0300
In-Reply-To: <1381940926-25564-9-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
	 <1381940926-25564-9-git-send-email-vinod.koul@intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 21:58 +0530, Vinod Koul wrote:
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> CC: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/dma/dw/core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
> index 89eb89f..2c29331 100644
> --- a/drivers/dma/dw/core.c
> +++ b/drivers/dma/dw/core.c
> @@ -1098,13 +1098,13 @@ dwc_tx_status(struct dma_chan *chan,
>  	enum dma_status		ret;
>  
>  	ret = dma_cookie_status(chan, cookie, txstate);
> -	if (ret == DMA_SUCCESS)
> +	if (ret == DMA_COMPLETE)
>  		return ret;
>  
>  	dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
>  
>  	ret = dma_cookie_status(chan, cookie, txstate);
> -	if (ret != DMA_SUCCESS)
> +	if (ret != DMA_COMPLETE)
>  		dma_set_residue(txstate, dwc_get_residue(dwc));
>  
>  	if (dwc->paused && ret == DMA_IN_PROGRESS)

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
