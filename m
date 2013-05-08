Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab3EHEAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 00:00:43 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51588 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab3EHEA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 00:00:26 -0400
Date: Wed, 8 May 2013 09:57:02 +0900
From: Simon Horman <horms@verge.net.au>
To: Axel Lin <axel.lin@ingics.com>
Cc: Magnus Damm <damm@opensource.se>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: renesas-irqc: Fix irqc_probe error handling
Message-ID: <20130508005702.GB23419@verge.net.au>
References: <1367831012.3547.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367831012.3547.2.camel@phoenix>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 05:03:32PM +0800, Axel Lin wrote:
> The code in goto err3 path is wrong because it will call fee_irq() with k == 0,
> which means it does free_irq(p->irq[-1].requested_irq, &p->irq[-1]);
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/irqchip/irq-renesas-irqc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks, I have queued this up for v3.11 in the intc-external-irq branch
of my renesas tree on kernel.org.

> 
> diff --git a/drivers/irqchip/irq-renesas-irqc.c b/drivers/irqchip/irq-renesas-irqc.c
> index 649cd69..3651f77 100644
> --- a/drivers/irqchip/irq-renesas-irqc.c
> +++ b/drivers/irqchip/irq-renesas-irqc.c
> @@ -252,8 +252,8 @@ static int irqc_probe(struct platform_device *pdev)
>  
>  	return 0;
>  err3:
> -	for (; k >= 0; k--)
> -		free_irq(p->irq[k - 1].requested_irq, &p->irq[k - 1]);
> +	while (--k >= 0)
> +		free_irq(p->irq[k].requested_irq, &p->irq[k]);
>  
>  	irq_domain_remove(p->irq_domain);
>  err2:
> -- 
> 1.8.1.2
> 
> 
> 
