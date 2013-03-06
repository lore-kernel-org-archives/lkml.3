Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab3CFHzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:55:51 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:46395 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3CFHzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:55:48 -0500
Date: Wed, 6 Mar 2013 16:55:45 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        tglx@linutronix.de
Subject: Re: [PATCH] irqchip: intc-irqpin: Initial DT support
Message-ID: <20130306075544.GD29060@verge.net.au>
References: <20130306061608.5231.23213.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130306061608.5231.23213.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 03:16:08PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add initial DT support to the INTC External IRQ Pin
> driver. At this point only hardware with 4-bit wide
> sense registers is supported via DT.

I have added this to topic/intc-external-irq with the related patches.
The holding-pen for INTC.

> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  drivers/irqchip/irq-renesas-intc-irqpin.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> --- 0001/drivers/irqchip/irq-renesas-intc-irqpin.c
> +++ work/drivers/irqchip/irq-renesas-intc-irqpin.c	2013-03-06 14:59:58.000000000 +0900
> @@ -278,6 +278,7 @@ static int intc_irqpin_irq_domain_map(st
>  
>  static struct irq_domain_ops intc_irqpin_irq_domain_ops = {
>  	.map	= intc_irqpin_irq_domain_map,
> +	.xlate  = irq_domain_xlate_twocell,
>  };
>  
>  static int intc_irqpin_probe(struct platform_device *pdev)
> @@ -437,11 +438,19 @@ static int intc_irqpin_remove(struct pla
>  	return 0;
>  }
>  
> +static const struct of_device_id intc_irqpin_dt_ids[] = {
> +	{ .compatible = "renesas,intc-irqpin", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, intc_irqpin_dt_ids);
> +
>  static struct platform_driver intc_irqpin_device_driver = {
>  	.probe		= intc_irqpin_probe,
>  	.remove		= intc_irqpin_remove,
>  	.driver		= {
>  		.name	= "renesas_intc_irqpin",
> +		.of_match_table = intc_irqpin_dt_ids,
> +		.owner  = THIS_MODULE,
>  	}
>  };
>  
> 
