Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbaCDK53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:57:29 -0500
Received: from www.linutronix.de ([62.245.132.108]:60545 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbaCDK52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:57:28 -0500
Date: Tue, 4 Mar 2014 11:57:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: James Hogan <james.hogan@imgtec.com>, grant.likely@linaro.org,
        linus.walleij@linaro.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irq: Changed the return type of irq_chip.irq_startup()
 from unsigned int to int
In-Reply-To: <20140301160114.GE21483@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1403041134410.18573@ionos.tec.linutronix.de>
References: <CACh+v5Nkuct0J65OHcnSd6Dfq4EyfafY8RpTvdwKXUA7A8_+Xw@mail.gmail.com> <1393521679-32331-1-git-send-email-jjhiblot@traphandler.com> <7150036.UpHTd1PK1K@radagast> <alpine.DEB.2.02.1403011629540.18573@ionos.tec.linutronix.de>
 <20140301160114.GE21483@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2014, Russell King - ARM Linux wrote:

> On Sat, Mar 01, 2014 at 04:31:13PM +0100, Thomas Gleixner wrote:
> > On Fri, 28 Feb 2014, James Hogan wrote:
> > > On Thursday 27 February 2014 18:21:19 Jean-Jacques Hiblot wrote:
> > > >  drivers/irqchip/irq-metag.c               | 4 ++--
> > > 
> > > I think you've missed out drivers/irqchip/irq-metag-ext.c
> > 
> > There is a good reason why I asked to do this with coccinelle.
> 
> Go easy, not everyone understands that complex tool - I certainly don't.
> I ended up deleting it from my system after several failed attempts, and
> I came to the conclusion that to use it properly, you also needed a Julia
> installed along side you to learn how to write its scripts.

The trick is to send your incomplete script with an explanation what
it should do to the cocci mailinglist. Julia and the other folks are
always happy to help. :)

But seriously, I whipped up a cocci script to verify James patch and
yes it found all occurences except one in drivers/gpio/gpio-tz1090.c

The reason is the usage of commata instead of semicolons. You can work
around that with cocci, but that gets ugly ....

Thanks,

	tglx

--- a/drivers/gpio/gpio-tz1090.c
+++ b/drivers/gpio/gpio-tz1090.c
@@ -488,26 +488,26 @@ static int tz1090_gpio_bank_probe(struct tz1090_gpio_bank_info *info)
 	gc->chip_types[0].handler		= handle_level_irq;
 	gc->chip_types[0].regs.ack		= REG_GPIO_IRQ_STS;
 	gc->chip_types[0].regs.mask		= REG_GPIO_IRQ_EN;
-	gc->chip_types[0].chip.irq_startup	= gpio_startup_irq,
-	gc->chip_types[0].chip.irq_ack		= irq_gc_ack_clr_bit,
-	gc->chip_types[0].chip.irq_mask		= irq_gc_mask_clr_bit,
-	gc->chip_types[0].chip.irq_unmask	= irq_gc_mask_set_bit,
-	gc->chip_types[0].chip.irq_set_type	= gpio_set_irq_type,
-	gc->chip_types[0].chip.irq_set_wake	= gpio_set_irq_wake,
-	gc->chip_types[0].chip.flags		= IRQCHIP_MASK_ON_SUSPEND,
+	gc->chip_types[0].chip.irq_startup	= gpio_startup_irq;
+	gc->chip_types[0].chip.irq_ack		= irq_gc_ack_clr_bit;
+	gc->chip_types[0].chip.irq_mask		= irq_gc_mask_clr_bit;
+	gc->chip_types[0].chip.irq_unmask	= irq_gc_mask_set_bit;
+	gc->chip_types[0].chip.irq_set_type	= gpio_set_irq_type;
+	gc->chip_types[0].chip.irq_set_wake	= gpio_set_irq_wake;
+	gc->chip_types[0].chip.flags		= IRQCHIP_MASK_ON_SUSPEND;
 
 	/* edge chip type */
 	gc->chip_types[1].type			= IRQ_TYPE_EDGE_BOTH;
 	gc->chip_types[1].handler		= handle_edge_irq;
 	gc->chip_types[1].regs.ack		= REG_GPIO_IRQ_STS;
 	gc->chip_types[1].regs.mask		= REG_GPIO_IRQ_EN;
-	gc->chip_types[1].chip.irq_startup	= gpio_startup_irq,
-	gc->chip_types[1].chip.irq_ack		= irq_gc_ack_clr_bit,
-	gc->chip_types[1].chip.irq_mask		= irq_gc_mask_clr_bit,
-	gc->chip_types[1].chip.irq_unmask	= irq_gc_mask_set_bit,
-	gc->chip_types[1].chip.irq_set_type	= gpio_set_irq_type,
-	gc->chip_types[1].chip.irq_set_wake	= gpio_set_irq_wake,
-	gc->chip_types[1].chip.flags		= IRQCHIP_MASK_ON_SUSPEND,
+	gc->chip_types[1].chip.irq_startup	= gpio_startup_irq;
+	gc->chip_types[1].chip.irq_ack		= irq_gc_ack_clr_bit;
+	gc->chip_types[1].chip.irq_mask		= irq_gc_mask_clr_bit;
+	gc->chip_types[1].chip.irq_unmask	= irq_gc_mask_set_bit;
+	gc->chip_types[1].chip.irq_set_type	= gpio_set_irq_type;
+	gc->chip_types[1].chip.irq_set_wake	= gpio_set_irq_wake;
+	gc->chip_types[1].chip.flags		= IRQCHIP_MASK_ON_SUSPEND;
 
 	/* Setup chained handler for this GPIO bank */
 	irq_set_handler_data(bank->irq, bank);
