Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab3EVVVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:21:23 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39037 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330Ab3EVVVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:21:09 -0400
Message-ID: <519D36C2.5000009@kernel.org>
Date: Wed, 22 May 2013 22:21:06 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
CC: linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: iio: adc: convert to devm_ioremap_resource()
References: <1368270391-15267-1-git-send-email-silviupopescu1990@gmail.com>
In-Reply-To: <1368270391-15267-1-git-send-email-silviupopescu1990@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2013 12:06 PM, Silviu-Mihai Popescu wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Patch number 3 doing the same thing.  I was somewhat tardy applying
the first one so sorry for wasting your time on this.

Jonathan
> ---
>  drivers/iio/adc/exynos_adc.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index 9f3a8ef..22d034a 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -270,16 +270,16 @@ static int exynos_adc_probe(struct platform_device *pdev)
>  	info = iio_priv(indio_dev);
>  
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	info->regs = devm_request_and_ioremap(&pdev->dev, mem);
> -	if (!info->regs) {
> -		ret = -ENOMEM;
> +	info->regs = devm_ioremap_resource(&pdev->dev, mem);
> +	if (IS_ERR(info->regs)) {
> +		ret = PTR_ERR(info->regs);
>  		goto err_iio;
>  	}
>  
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	info->enable_reg = devm_request_and_ioremap(&pdev->dev, mem);
> -	if (!info->enable_reg) {
> -		ret = -ENOMEM;
> +	info->enable_reg = devm_ioremap_resource(&pdev->dev, mem);
> +	if (IS_ERR(info->enable_reg)) {
> +		ret = PTR_ERR(info->enable_reg);
>  		goto err_iio;
>  	}
>  
> 
