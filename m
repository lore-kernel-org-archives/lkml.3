Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3JCQ4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:56:43 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:46441 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab3JCQ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:56:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sangjung Woo <sangjung.woo@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbdev: sh_mobile_hdmi: Use devm_kzalloc()
Date: Thu, 03 Oct 2013 18:56:47 +0200
Message-ID: <1732816.05cDxPcW7M@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1380809067-4245-1-git-send-email-sangjung.woo@samsung.com>
References: <1380809067-4245-1-git-send-email-sangjung.woo@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sangjung,

Thank you for the patch.

On Thursday 03 October 2013 23:04:27 Sangjung Woo wrote:
> Use devm_kzalloc() instead of kzalloc() in order to be free
> automatically. This makes cleanup paths more simple.
> 
> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Tomi, could you please pick it up ?

> ---
>  drivers/video/sh_mobile_hdmi.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/video/sh_mobile_hdmi.c b/drivers/video/sh_mobile_hdmi.c
> index bfe4728..64bd0bf 100644
> --- a/drivers/video/sh_mobile_hdmi.c
> +++ b/drivers/video/sh_mobile_hdmi.c
> @@ -1290,7 +1290,7 @@ static int __init sh_hdmi_probe(struct platform_device
> *pdev) }
>  	}
> 
> -	hdmi = kzalloc(sizeof(*hdmi), GFP_KERNEL);
> +	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
>  	if (!hdmi) {
>  		dev_err(&pdev->dev, "Cannot allocate device data\n");
>  		return -ENOMEM;
> @@ -1304,7 +1304,7 @@ static int __init sh_hdmi_probe(struct platform_device
> *pdev) if (IS_ERR(hdmi->hdmi_clk)) {
>  		ret = PTR_ERR(hdmi->hdmi_clk);
>  		dev_err(&pdev->dev, "Unable to get clock: %d\n", ret);
> -		goto egetclk;
> +		return ret;
>  	}
> 
>  	/* select register access functions */
> @@ -1407,8 +1407,6 @@ ereqreg:
>  	clk_disable(hdmi->hdmi_clk);
>  erate:
>  	clk_put(hdmi->hdmi_clk);
> -egetclk:
> -	kfree(hdmi);
> 
>  	return ret;
>  }
> @@ -1433,7 +1431,6 @@ static int __exit sh_hdmi_remove(struct
> platform_device *pdev) iounmap(hdmi->htop1);
>  	iounmap(hdmi->base);
>  	release_mem_region(res->start, resource_size(res));
> -	kfree(hdmi);
> 
>  	return 0;
>  }
-- 
Regards,

Laurent Pinchart

