Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441Ab3CDRIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:08:10 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:60381 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758375Ab3CDRIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:08:07 -0500
Message-ID: <1362416898.24058.1.camel@gitbox>
Subject: Re: [PATCH 1/1] gpio/vt8500: Convert to devm_ioremap_resource()
From: Tony Prisk <linux@prisktech.co.nz>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, thierry.reding@avionic-design.de
Date: Tue, 05 Mar 2013 06:08:18 +1300
In-Reply-To: <1362388179-26841-1-git-send-email-sachin.kamat@linaro.org>
References: <1362388179-26841-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-04 at 14:39 +0530, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages; so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/gpio/gpio-vt8500.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-vt8500.c b/drivers/gpio/gpio-vt8500.c
> index 81683ca..b2d8d6f 100644
> --- a/drivers/gpio/gpio-vt8500.c
> +++ b/drivers/gpio/gpio-vt8500.c
> @@ -309,11 +309,9 @@ static int vt8500_gpio_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> -	gpio_base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!gpio_base) {
> -		dev_err(&pdev->dev, "Unable to map GPIO registers\n");
> -		return -ENOMEM;
> -	}
> +	gpio_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(gpio_base))
> +		return PTR_ERR(gpio_base);
>  
>  	ret = vt8500_add_chips(pdev, gpio_base, of_id->data);
>  

Acked-by: Tony Prisk <linux@prisktech.co.nz>

