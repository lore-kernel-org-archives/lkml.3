Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaJWJpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 05:45:53 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61493 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaJWJpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 05:45:50 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-32-5448ce4b2ac9
Message-id: <5448CE4A.6010207@samsung.com>
Date: Thu, 23 Oct 2014 11:45:46 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: gnurou@gmail.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/panel: ld9040: Update calls to gpiod_get*()
References: <1414052177-19978-1-git-send-email-acourbot@nvidia.com>
In-reply-to: <1414052177-19978-1-git-send-email-acourbot@nvidia.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xq7re5zxCDOb/0LL4/vAUq8WVr+/Z
	LM69esRicXnXHDaLn7vmsTiweuycdZfd4373cSaP3uZ3bB6fN8kFsERx2aSk5mSWpRbp2yVw
	ZVx6sIu14D9PxbFTd1kbGE9xdTFyckgImEjM+XWTHcIWk7hwbz1bFyMXh5DAUkaJjjcnoJxP
	jBJXNv9iBqniFdCS+DOjH8xmEVCVuHj0LhOIzSagKfF38002EFtUIELiypo5jBD1ghI/Jt9j
	6WLk4BABim/rFwMJMwuESjya8ZYdJCws4CJx+lMlSFhIwFmi5dYaFhCbEyg88clbZpASZgE9
	ifsXtSA65SU2r3nLPIFRYBaS+bMQqmYhqVrAyLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cT
	IySAv+5gXHrM6hCjAAejEg9vRbJHiBBrYllxZe4hRgkOZiURXtUzQCHelMTKqtSi/Pii0pzU
	4kOMTBycUg2MGQu/z/ibey33wma/+wbX3+Uc684SmvZot83xSi6N846yQYahOS3djz5qvDi4
	cbrvgcznxbd+VDm0M2hK3NsiptkvZ7Za6rZ6+K2NcRFzddkz01OSjZ8Ux7bs77bRyUx+16l3
	WP707RqlbwtTvwt/dfu8RbDtUEeiXou6FmfGPf+wVc8Zv5oqsRRnJBpqMRcVJwIA15n2ET4C	AAA=
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
>  drivers/gpu/drm/panel/panel-ld9040.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panel/panel-ld9040.c b/drivers/gpu/drm/panel/panel-ld9040.c
> index 42ac67b21e9f..dd1d3f2e624e 100644
> --- a/drivers/gpu/drm/panel/panel-ld9040.c
> +++ b/drivers/gpu/drm/panel/panel-ld9040.c
> @@ -336,17 +336,12 @@ static int ld9040_probe(struct spi_device *spi)
>  	if (ret < 0)
>  		return ret;
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
>  	spi->bits_per_word = 9;
>  	ret = spi_setup(spi);
> 

