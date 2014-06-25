Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbaFYJy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:54:58 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54159 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbaFYJyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:54:53 -0400
Date: Wed, 25 Jun 2014 10:54:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH] pwm-backlight: use devm_gpiod_get_optional()
Message-ID: <20140625095447.GT13803@lee--X1>
References: <1403687898-26881-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403687898-26881-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Make use of the new devm_gpiod_get_optional() to simplify the probe
> code.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/video/backlight/pwm_bl.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Looks good.  Applied, thanks.

> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
> index 38ca88bc5c3e..d1e0a7c6cac7 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -245,13 +245,10 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>  	pb->dev = &pdev->dev;
>  	pb->enabled = false;
>  
> -	pb->enable_gpio = devm_gpiod_get(&pdev->dev, "enable");
> +	pb->enable_gpio = devm_gpiod_get_optional(&pdev->dev, "enable");
>  	if (IS_ERR(pb->enable_gpio)) {
>  		ret = PTR_ERR(pb->enable_gpio);
> -		if (ret == -ENOENT)
> -			pb->enable_gpio = NULL;
> -		else
> -			goto err_alloc;
> +		goto err_alloc;
>  	}
>  
>  	/*

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
