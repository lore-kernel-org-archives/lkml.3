Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab3HZMic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:38:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54563 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3HZMib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:38:31 -0400
Date: Mon, 26 Aug 2013 14:38:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Jingoo Han <jg1.han@samsung.com>
cc: "'Vinod Koul'" <vinod.koul@intel.com>, "'Dan Williams'" <djbw@fb.com>,
        linux-kernel@vger.kernel.org,
        "'Simon Horman'" <horms+renesas@verge.net.au>
Subject: Re: [PATCH] dma: sh: remove unnecessary platform_set_drvdata()
In-Reply-To: <002801ce9e53$2f63b1e0$8e2b15a0$%han@samsung.com>
Message-ID: <Pine.LNX.4.64.1308261134240.1767@axis700.grange>
References: <002801ce9e53$2f63b1e0$8e2b15a0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:TnbUqIU72CO932WbJY1OrKDJhVoWF1QvjcgMch8dcrJ
 qkzieZisfJck8+ySmalkoIc8kzNSw1rsWbF/BjdzQALtRtfjQU
 ZFCRpQLZTdpWEjwCU0131yDMi3WgIKDB9xtU+Z9X2YFvQwrALD
 mjra5vmM9TRe00DAmB8ioQdIloy2w9Ql1jzY+sHhix8k/+VAVN
 NNs2vtcvNynyD2sJgCiKUWPp7PMTP6+WZdeHnMy80errKCnFhI
 jwDV51RapF0V+ECqxZ3x0Pzz3TzWaEKzAS06rjiAdjMAFMhOas
 w5fD4WXCA8b6tlFmGSLMwP/a7ZZFF83qefNHBvHEyKlwFnQGyR
 qk0kcEeVCCTdtzTvitTB1UsaJ2tfGAopym+Xz0uXVOhKBt3K8f
 S4I1MaXNmUp/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013, Jingoo Han wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

This has to be updated on top of current 
http://git.infradead.org/users/vkoul/slave-dma.git next branch, there it 
will patch the drivers/dma/sh/shdmac.c file, not drivers/dma/sh/shdma.c. 
After that feel free to add my

Acked-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>

Thanks
Guennadi

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

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
