Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084AbaBLIMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:12:53 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:21267 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaBLIMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:12:52 -0500
Message-ID: <52FB2CF5.8020503@atmel.com>
Date: Wed, 12 Feb 2014 09:12:37 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>,
        "'Herbert Xu'" <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, "'Peter Korsgaard'" <jacmet@sunsite.dk>
Subject: Re: [PATCH 1/2] hwrng: atmel - Use devm_ioremap_resource()
References: <000001cf27b1$acf29f30$06d7dd90$%han@samsung.com>
In-Reply-To: <000001cf27b1$acf29f30$06d7dd90$%han@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 06:17, Jingoo Han :
> Use devm_ioremap_resource() in order to make the code simpler,
> and remove redundant return value check of platform_get_resource()
> because the value is checked by devm_ioremap_resource().
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks! Bye,

> ---
>  drivers/char/hw_random/atmel-rng.c |   15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
> index bf9fc6b..dfeddf2 100644
> --- a/drivers/char/hw_random/atmel-rng.c
> +++ b/drivers/char/hw_random/atmel-rng.c
> @@ -54,21 +54,14 @@ static int atmel_trng_probe(struct platform_device *pdev)
>  	struct resource *res;
>  	int ret;
>  
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res)
> -		return -EINVAL;
> -
>  	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
>  	if (!trng)
>  		return -ENOMEM;
>  
> -	if (!devm_request_mem_region(&pdev->dev, res->start,
> -				     resource_size(res), pdev->name))
> -		return -EBUSY;
> -
> -	trng->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> -	if (!trng->base)
> -		return -EBUSY;
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	trng->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(trng->base))
> +		return PTR_ERR(trng->base);
>  
>  	trng->clk = clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(trng->clk))
> 


-- 
Nicolas Ferre
