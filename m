Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3KNAHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 19:07:00 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37812 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3KNAGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 19:06:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        horms@verge.net.au
Subject: Re: [PATCH 01/03] gpio: rcar: Use lazy disable and mask on suspend
Date: Thu, 14 Nov 2013 01:07:30 +0100
Message-ID: <1906707.rpHAsqdqKq@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131113225936.21449.29529.sendpatchset@w520>
References: <20131113225927.21449.78044.sendpatchset@w520> <20131113225936.21449.29529.sendpatchset@w520>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

Thank you for the patch.

On Thursday 14 November 2013 07:59:36 Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Set the ->irq_enable() and ->irq_disable() methods to NULL
> to enable lazy disable of interrupts.

Is that just for optimization purpose, or is there another reason ?

> Also extend the code to set IRQCHIP_MASK_ON_SUSPEND which tells the core
> that only IRQs marked as wakeups need to stay enabled during Suspend-to-RAM.

Shouldn't this be split to a separate patch ?

> Tested on the Lager board with GPIO-keys and Suspend-to-RAM.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  drivers/gpio/gpio-rcar.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- 0001/drivers/gpio/gpio-rcar.c
> +++ work/drivers/gpio/gpio-rcar.c	2013-11-13 19:26:26.000000000 +0900
> @@ -368,10 +368,9 @@ static int gpio_rcar_probe(struct platfo
>  	irq_chip->name = name;
>  	irq_chip->irq_mask = gpio_rcar_irq_disable;
>  	irq_chip->irq_unmask = gpio_rcar_irq_enable;
> -	irq_chip->irq_enable = gpio_rcar_irq_enable;
> -	irq_chip->irq_disable = gpio_rcar_irq_disable;
>  	irq_chip->irq_set_type = gpio_rcar_irq_set_type;
>  	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE | IRQCHIP_SET_TYPE_MASKED;
> +	irq_chip->flags	|= IRQCHIP_MASK_ON_SUSPEND;

You can write it as

        irq_chip->flags = IRQCHIP_SKIP_SET_WAKE | IRQCHIP_SET_TYPE_MASKED
                        | IRQCHIP_MASK_ON_SUSPEND;

>  	p->irq_domain = irq_domain_add_simple(pdev->dev.of_node,
>  					      p->config.number_of_pins,
-- 
Regards,

Laurent Pinchart

