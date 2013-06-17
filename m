Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab3FQGN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 02:13:28 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37948 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab3FQGN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 02:13:26 -0400
Message-ID: <51BEA900.9070102@linaro.org>
Date: Mon, 17 Jun 2013 11:43:20 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: thierry.reding@gmail.com, patches@linaro.org, linux-gpio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 04/15] gpio_msm: Convert to use devm_ioremap_resource
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org> <1370864113-17895-5-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1370864113-17895-5-git-send-email-tushar.behera@linaro.org>
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
> CC: linux-gpio@vger.kernel.org
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/gpio/gpio-msm-v1.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-msm-v1.c b/drivers/gpio/gpio-msm-v1.c
> index c798585a..c0ead43 100644
> --- a/drivers/gpio/gpio-msm-v1.c
> +++ b/drivers/gpio/gpio-msm-v1.c
> @@ -652,14 +652,14 @@ static int __devinit gpio_msm_v1_probe(struct platform_device *pdev)
>  		return irq2;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	base1 = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!base1)
> -		return -EADDRNOTAVAIL;
> +	base1 = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(base1))
> +		return PTR_ERR(base1);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	base2 = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!base2)
> -		return -EADDRNOTAVAIL;
> +	base2 = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(base2))
> +		return PTR_ERR(base2);
>  
>  	for (i = FIRST_GPIO_IRQ; i < FIRST_GPIO_IRQ + NR_GPIO_IRQS; i++) {
>  		if (i - FIRST_GPIO_IRQ >=
> 

Ping.

-- 
Tushar Behera
