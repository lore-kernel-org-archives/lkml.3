Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab3LJSh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:37:57 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:42736 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3LJShy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:37:54 -0500
Date: Tue, 10 Dec 2013 18:37:49 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 11/15] mfd: menelaus: Start to use irqdomain
Message-ID: <20131210183749.GC2390@lee--X1>
References: <20131209161422.GC24047@saruman.home>
 <1386606085-26838-1-git-send-email-balbi@ti.com>
 <1386606085-26838-11-git-send-email-balbi@ti.com>
 <20131210092050.GT12675@lee--X1>
 <20131210163430.GG22750@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131210163430.GG22750@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Introduce an irq_chip and irq_domain for menelaus driver. Following
> > > patches will convert uses to traditional request_threaded_irq().
> > > 
> > > While at that, some better error handling had to be added, so we could
> > > free irq descs we allocated.
> > > 
> > > Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > ---
> > >  drivers/mfd/menelaus.c | 127 ++++++++++++++++++++++++++++++++++++++++++++++---
> > 
> > <snip>
> > 
> > > +	irq_domain_add_legacy(node, MENELAUS_NR_IRQS, irq_base, 0,
> > > +			&irq_domain_simple_ops, m);
> > 
> > When will this driver become DT compliant?
> 
> when OMAP2 becomes DT-compliant. It still boots with legacy board-file +
> platform_data.

Really? Tony, are there any plans to DT the platform?

Felipe, what did you think about using irq_domain_add_simple()?

> > > +	m->irq_base = irq_base;
> > > +
> > > +	for (i = irq_base; i < irq_base + MENELAUS_NR_IRQS; i++) {
> > > +		irq_set_chip_data(i, m);
> > > +		irq_set_chip_and_handler(i, &menelaus_irq_chip,
> > > +				handle_simple_irq);
> > > +		irq_set_nested_thread(i, 1);
> > > +		set_irq_flags(i, IRQF_VALID);
> > 
> > This assumes that this h/w only exists on ARM platforms. Is that true?
> 
> it was made *only* for Nokia to use on their ARM-only internet tablets.

If the IP is genuinely not reusable, them I'm fine with it.

I see that the Kconfig is setup in the correct way too, so we're good.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
