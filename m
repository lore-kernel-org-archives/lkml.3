Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab3HVAbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 20:31:22 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:41274 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab3HVAbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 20:31:21 -0400
Date: Thu, 22 Aug 2013 09:31:16 +0900
From: Simon Horman <horms@verge.net.au>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Vinod Koul'" <vinod.koul@intel.com>, "'Dan Williams'" <djbw@fb.com>,
        linux-kernel@vger.kernel.org,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dma: sh: remove unnecessary platform_set_drvdata()
Message-ID: <20130822003116.GH6902@verge.net.au>
References: <002801ce9e53$2f63b1e0$8e2b15a0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002801ce9e53$2f63b1e0$8e2b15a0$%han@samsung.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 06:45:35PM +0900, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.

Acked-by: Simon Horman <horms+renesas@verge.net.au>

Vinod, could you take this?

> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/dma/sh/shdma.c  |    3 ---
>  drivers/dma/sh/sudmac.c |    2 --
>  2 files changed, 5 deletions(-)
> 
> diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
> index 211e2f1..208de0f 100644
> --- a/drivers/dma/sh/shdma.c
> +++ b/drivers/dma/sh/shdma.c
> @@ -873,7 +873,6 @@ rst_err:
>  	pm_runtime_put(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
>  
> -	platform_set_drvdata(pdev, NULL);
>  	shdma_cleanup(&shdev->shdma_dev);
>  eshdma:
>  	if (dmars)
> @@ -917,8 +916,6 @@ static int sh_dmae_remove(struct platform_device *pdev)
>  		iounmap(shdev->dmars);
>  	iounmap(shdev->chan_reg);
>  
> -	platform_set_drvdata(pdev, NULL);
> -
>  	synchronize_rcu();
>  	kfree(shdev);
>  
> diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
> index c494417..23fffc8 100644
> --- a/drivers/dma/sh/sudmac.c
> +++ b/drivers/dma/sh/sudmac.c
> @@ -393,7 +393,6 @@ static int sudmac_probe(struct platform_device *pdev)
>  chan_probe_err:
>  	sudmac_chan_remove(su_dev);
>  
> -	platform_set_drvdata(pdev, NULL);
>  	shdma_cleanup(&su_dev->shdma_dev);
>  
>  	return err;
> @@ -407,7 +406,6 @@ static int sudmac_remove(struct platform_device *pdev)
>  	dma_async_device_unregister(dma_dev);
>  	sudmac_chan_remove(su_dev);
>  	shdma_cleanup(&su_dev->shdma_dev);
> -	platform_set_drvdata(pdev, NULL);
>  
>  	return 0;
>  }
> -- 
> 1.7.10.4
> 
> 
