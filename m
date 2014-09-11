Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaIKQ2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:28:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48319 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755921AbaIKQ2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:28:39 -0400
Date: Thu, 11 Sep 2014 18:28:37 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 1/7] irqchip: atmel-aic5: Add sama5d4 support
Message-ID: <20140911162836.GB3131@piout.net>
References: <1410450852-1834-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1410450852-1834-2-git-send-email-alexandre.belloni@free-electrons.com>
 <5411CB17.1060608@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5411CB17.1060608@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2014 at 18:17:27 +0200, Nicolas Ferre wrote :
> On 11/09/2014 17:54, Alexandre Belloni :
> > Add sama5d4 support to irq-atmel-aic5.
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > ---
> > Cc: Jason Cooper <jason@lakedaemon.net>
> 
> Supposed to be before the "---" ;-)

This actually depends on the maintainer preferences, after the ---
marker means that it will not appear in the final commit log which was
my intention.

> 
> >  drivers/irqchip/irq-atmel-aic5.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
> > index dc7d98607a89..a11aae8fb006 100644
> > --- a/drivers/irqchip/irq-atmel-aic5.c
> > +++ b/drivers/irqchip/irq-atmel-aic5.c
> > @@ -295,6 +295,7 @@ static void __init sama5d3_aic_irq_fixup(struct device_node *root)
> >  
> >  static const struct of_device_id __initdata aic5_irq_fixups[] = {
> >  	{ .compatible = "atmel,sama5d3", .data = sama5d3_aic_irq_fixup },
> > +	{ .compatible = "atmel,sama5d4", .data = sama5d3_aic_irq_fixup },
> >  	{ /* sentinel */ },
> >  };
> >  
> > @@ -349,3 +350,12 @@ static int __init sama5d3_aic5_of_init(struct device_node *node,
> >  	return aic5_of_init(node, parent, NR_SAMA5D3_IRQS);
> >  }
> >  IRQCHIP_DECLARE(sama5d3_aic5, "atmel,sama5d3-aic", sama5d3_aic5_of_init);
> > +
> > +#define NR_SAMA5D4_IRQS		68
> > +
> > +static int __init sama5d4_aic5_of_init(struct device_node *node,
> > +				       struct device_node *parent)
> > +{
> > +	return aic5_of_init(node, parent, NR_SAMA5D4_IRQS);
> > +}
> > +IRQCHIP_DECLARE(sama5d4_aic5, "atmel,sama5d4-aic", sama5d4_aic5_of_init);
> > 
> 
> 
> -- 
> Nicolas Ferre

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
