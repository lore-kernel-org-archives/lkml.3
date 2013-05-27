Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3E0RHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 13:07:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:14593 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab3E0RHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 13:07:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,752,1363158000"; 
   d="scan'208";a="344096362"
Date: Mon, 27 May 2013 22:00:36 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 1/2] dma: at_hdmac: remove unnecessary
 platform_set_drvdata()
Message-ID: <20130527163036.GB26340@intel.com>
References: <002701ce4a0d$47c62000$d7526000$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002701ce4a0d$47c62000$d7526000$@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 12:53:33PM +0900, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Applied both, Thanks

--
~Vinod
> ---
>  drivers/dma/at_hdmac.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index e923cda..c093ab7 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -1472,7 +1472,6 @@ err_of_dma_controller_register:
>  	dma_async_device_unregister(&atdma->dma_common);
>  	dma_pool_destroy(atdma->dma_desc_pool);
>  err_pool_create:
> -	platform_set_drvdata(pdev, NULL);
>  	free_irq(platform_get_irq(pdev, 0), atdma);
>  err_irq:
>  	clk_disable(atdma->clk);
> @@ -1497,7 +1496,6 @@ static int at_dma_remove(struct platform_device *pdev)
>  	dma_async_device_unregister(&atdma->dma_common);
>  
>  	dma_pool_destroy(atdma->dma_desc_pool);
> -	platform_set_drvdata(pdev, NULL);
>  	free_irq(platform_get_irq(pdev, 0), atdma);
>  
>  	list_for_each_entry_safe(chan, _chan, &atdma->dma_common.channels,
> -- 
> 1.7.2.5
> 
