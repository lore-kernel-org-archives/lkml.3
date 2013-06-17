Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab3FQJMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:12:33 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33780 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3FQJMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:12:31 -0400
Message-ID: <51BED2F9.1020307@linaro.org>
Date: Mon, 17 Jun 2013 14:42:25 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: thierry.reding@gmail.com, patches@linaro.org,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH 11/15] regulator: ti-abb: Convert to use devm_ioremap_resource
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org> <1370864113-17895-12-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1370864113-17895-12-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 05:05 PM, Tushar Behera wrote:
> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> CC: Mark Brown <broonie@kernel.org>
> CC: Liam Girdwood <lgirdwood@gmail.com>
> ---
>  drivers/regulator/ti-abb-regulator.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
> index 870d209..f494a11 100644
> --- a/drivers/regulator/ti-abb-regulator.c
> +++ b/drivers/regulator/ti-abb-regulator.c
> @@ -722,10 +722,10 @@ static int ti_abb_probe(struct platform_device *pdev)
>  		ret = -ENODEV;
>  		goto err;
>  	}
> -	abb->base = devm_request_and_ioremap(dev, res);
> -	if (!abb->base) {
> +	abb->base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(abb->base)) {
>  		dev_err(dev, "Unable to map '%s'\n", pname);
> -		ret = -ENOMEM;
> +		ret = PTR_ERR(abb->base);
>  		goto err;
>  	}
>  
> @@ -776,10 +776,10 @@ static int ti_abb_probe(struct platform_device *pdev)
>  		ret = -ENODEV;
>  		goto skip_opt;
>  	}
> -	abb->ldo_base = devm_request_and_ioremap(dev, res);
> -	if (!abb->ldo_base) {
> +	abb->ldo_base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(abb->ldo_base)) {
>  		dev_err(dev, "Unable to map '%s'\n", pname);
> -		ret = -ENOMEM;
> +		ret = PTR_ERR(abb->ldo_base);
>  		goto err;
>  	}
>  
> 

Ping.

-- 
Tushar Behera
