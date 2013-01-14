Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab3ANOPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:15:15 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:32950 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756Ab3ANOPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:15:13 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: mvebu: Don't free chip label memory
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1358160800-12185-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358160800-12185-1-git-send-email-thierry.reding@avionic-design.de>
Date: Mon, 14 Jan 2013 14:15:04 +0000
Message-Id: <20130114141504.C91503E232D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013 11:53:20 +0100, Thierry Reding <thierry.reding@avionic-design.de> wrote:
> The gpio_chip.label field is a const char * and assigned the value of a
> call to dev_name(). Memory obtained from dev_name() should not be freed
> by drivers.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

Linus, can you put this in your fixes branch?

Thanks,
g.

> ---
>  drivers/gpio/gpio-mvebu.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
> index 7d9bd94..6819d63 100644
> --- a/drivers/gpio/gpio-mvebu.c
> +++ b/drivers/gpio/gpio-mvebu.c
> @@ -547,7 +547,6 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
>  	mvchip->membase = devm_request_and_ioremap(&pdev->dev, res);
>  	if (! mvchip->membase) {
>  		dev_err(&pdev->dev, "Cannot ioremap\n");
> -		kfree(mvchip->chip.label);
>  		return -ENOMEM;
>  	}
>  
> @@ -557,14 +556,12 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
>  		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>  		if (! res) {
>  			dev_err(&pdev->dev, "Cannot get memory resource\n");
> -			kfree(mvchip->chip.label);
>  			return -ENODEV;
>  		}
>  
>  		mvchip->percpu_membase = devm_request_and_ioremap(&pdev->dev, res);
>  		if (! mvchip->percpu_membase) {
>  			dev_err(&pdev->dev, "Cannot ioremap\n");
> -			kfree(mvchip->chip.label);
>  			return -ENOMEM;
>  		}
>  	}
> @@ -625,7 +622,6 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
>  	mvchip->irqbase = irq_alloc_descs(-1, 0, ngpios, -1);
>  	if (mvchip->irqbase < 0) {
>  		dev_err(&pdev->dev, "no irqs\n");
> -		kfree(mvchip->chip.label);
>  		return -ENOMEM;
>  	}
>  
> @@ -633,7 +629,6 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
>  				    mvchip->membase, handle_level_irq);
>  	if (! gc) {
>  		dev_err(&pdev->dev, "Cannot allocate generic irq_chip\n");
> -		kfree(mvchip->chip.label);
>  		return -ENOMEM;
>  	}
>  
> @@ -668,7 +663,6 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
>  		irq_remove_generic_chip(gc, IRQ_MSK(ngpios), IRQ_NOREQUEST,
>  					IRQ_LEVEL | IRQ_NOPROBE);
>  		kfree(gc);
> -		kfree(mvchip->chip.label);
>  		return -ENODEV;
>  	}
>  
> -- 
> 1.8.1
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
