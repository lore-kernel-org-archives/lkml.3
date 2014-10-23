Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaJWJqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 05:46:15 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61514 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbaJWJqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 05:46:11 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-aa-5448ce61eb50
Message-id: <5448CE60.7040004@samsung.com>
Date: Thu, 23 Oct 2014 11:46:08 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
Newsgroups: gmane.comp.video.dri.devel,gmane.linux.kernel
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: gnurou@gmail.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/panel: s6e8aa0: Update calls to gpiod_get*()
References: <1414052218-20157-1-git-send-email-acourbot@nvidia.com>
In-reply-to: <1414052218-20157-1-git-send-email-acourbot@nvidia.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsVy+t/xa7qJ5zxCDA6vNLb4/vAUq8WVr+/Z
	LM69esRicXnXHDaLn7vmsTiweuycdZfd4373cSaP3uZ3bB6fN8kFsERx2aSk5mSWpRbp2yVw
	ZZzsecFY8Ienon//V6YGxpNcXYycHBICJhKLzt1lhLDFJC7cW8/WxcjFISSwlFHi0bObUM4n
	RokbPz6yg1TxCmhJnLi6lAnEZhFQlTi/ZzoLiM0moCnxdzNIAyeHqECExJU1cxgh6gUlfky+
	B1bDJ2ApcWxJJ9AcDg4RoJpt/WIgYWaBUIlHM96CjRcWcJV4dOoH2HghAWeJCXOfgdmcAi4S
	3+ZfZQFpZRbQk7h/UQuiVV5i85q3zBMYBWchWTYLoWoWkqoFjMyrGEVTS5MLipPSc430ihNz
	i0vz0vWS83M3MUJC++sOxqXHrA4xCnAwKvHwViR7hAixJpYVV+YeYpTgYFYS4VU9AxTiTUms
	rEotyo8vKs1JLT7EyMTBKdXAyNgu/+dPdevNL4HXTk04b3q96+2aq9wTvr4pOCmWaih//P58
	1wWHHGY77j7992rV7zMLbj76cz6Ih+GXfZ7t5aP/yq6u9DHoULu07Kj9pOrG+4tYpm60dN6r
	FFByI3/n3L7w5V39ngf2WUlnP23JyBac+jWWZ5pmZ+Fe840+dTzbH56bcLpitpASS3FGoqEW
	c1FxIgC5ih5iSwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 10:16 AM, Alexandre Courbot wrote:
> Add the new flags argument to calls of (devm_)gpiod_get*() and
> remove any direction setting code afterwards.
> 
> Currently both forms (with or without the flags argument)
> are valid thanks to transitional macros in
> <linux/gpio/consumer.h>. These macros will be removed once
> all consumers are updated and the flags argument will become
> compulsary.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

It needs patch "gpio: Fix gpio direction flags not getting set" to work
correctly. It is not yet present in drm-next. Beside this:

Acked-by: Andrzej Hajda <a.hajda@samsung.com>

--
Regards
Andrzej


> ---
>  drivers/gpu/drm/panel/panel-s6e8aa0.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panel/panel-s6e8aa0.c b/drivers/gpu/drm/panel/panel-s6e8aa0.c
> index b5217fe37f02..6427aa187735 100644
> --- a/drivers/gpu/drm/panel/panel-s6e8aa0.c
> +++ b/drivers/gpu/drm/panel/panel-s6e8aa0.c
> @@ -1019,17 +1019,12 @@ static int s6e8aa0_probe(struct mipi_dsi_device *dsi)
>  		return ret;
>  	}
>  
> -	ctx->reset_gpio = devm_gpiod_get(dev, "reset");
> +	ctx->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
>  	if (IS_ERR(ctx->reset_gpio)) {
>  		dev_err(dev, "cannot get reset-gpios %ld\n",
>  			PTR_ERR(ctx->reset_gpio));
>  		return PTR_ERR(ctx->reset_gpio);
>  	}
> -	ret = gpiod_direction_output(ctx->reset_gpio, 1);
> -	if (ret < 0) {
> -		dev_err(dev, "cannot configure reset-gpios %d\n", ret);
> -		return ret;
> -	}
>  
>  	ctx->brightness = GAMMA_LEVEL_NUM - 1;
>  
> 

