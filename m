Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaB1Nwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:52:34 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:40277 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaB1Nwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:52:33 -0500
Message-ID: <5310949F.7000901@atmel.com>
Date: Fri, 28 Feb 2014 14:52:31 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>,
        "'Herbert Xu'" <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, "'Peter Korsgaard'" <jacmet@sunsite.dk>
Subject: Re: [PATCH 1/5] hwrng: atmel - Use devm_clk_get()
References: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com>
In-Reply-To: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/2014 06:00, Jingoo Han :
> Use devm_clk_get() to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks a lot.

> ---
>  drivers/char/hw_random/atmel-rng.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
> index dfeddf2..851bc7e 100644
> --- a/drivers/char/hw_random/atmel-rng.c
> +++ b/drivers/char/hw_random/atmel-rng.c
> @@ -63,13 +63,13 @@ static int atmel_trng_probe(struct platform_device *pdev)
>  	if (IS_ERR(trng->base))
>  		return PTR_ERR(trng->base);
>  
> -	trng->clk = clk_get(&pdev->dev, NULL);
> +	trng->clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(trng->clk))
>  		return PTR_ERR(trng->clk);
>  
>  	ret = clk_enable(trng->clk);
>  	if (ret)
> -		goto err_enable;
> +		return ret;
>  
>  	writel(TRNG_KEY | 1, trng->base + TRNG_CR);
>  	trng->rng.name = pdev->name;
> @@ -85,9 +85,6 @@ static int atmel_trng_probe(struct platform_device *pdev)
>  
>  err_register:
>  	clk_disable(trng->clk);
> -err_enable:
> -	clk_put(trng->clk);
> -
>  	return ret;
>  }
>  
> @@ -99,7 +96,6 @@ static int atmel_trng_remove(struct platform_device *pdev)
>  
>  	writel(TRNG_KEY, trng->base + TRNG_CR);
>  	clk_disable(trng->clk);
> -	clk_put(trng->clk);
>  
>  	return 0;
>  }
> 


-- 
Nicolas Ferre
