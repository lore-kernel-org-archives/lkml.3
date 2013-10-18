Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3JRXtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 19:49:23 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:48735 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab3JRXtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 19:49:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+fanWoUdRS6zbEASwiQUAI
Date: Fri, 18 Oct 2013 16:49:14 -0700
From: Tony Lindgren <tony@atomide.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "pinctl-single.c" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 17 (pinctrl-single.c)
Message-ID: <20131018234914.GV15154@atomide.com>
References: <20131018003847.GH2443@sirena.org.uk>
 <5261792C.7030203@infradead.org>
 <CACRpkdaz22N8-9Rg8vR=KGOEL5P6sZm6Hh5PT4Uq381+QmPs7g@mail.gmail.com>
 <20131018233951.GU15154@atomide.com>
 <5261C72D.1090302@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5261C72D.1090302@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap <rdunlap@infradead.org> [131018 16:41]:
> On 10/18/13 16:39, Tony Lindgren wrote:
> > 
> > Looks like we need a little bit of arch specific handling
> > with the generic IRQ. Fix the issue with an ifdef the
> > same way as other drivers do.
> > 
> > ARM needs things set to IRQF_VALID, which also then sets
> > noprobe. Others seem to use just irq_set_noprobe().
> > 
> > Otherwise we can get:
> > 
> > drivers/pinctrl/pinctrl-single.c: In function 'pcs_irqdomain_map':
> > drivers/pinctrl/pinctrl-single.c:1750:2: error: implicit declaration of function 'set_irq_flags' [-Werror=implicit-function-declaration]
> 
> Did you address this error?  I don't see a fix for it...

Yes set_irq_flags() is defined for ARM archs in
arch/arm/include/asm/hw_irq.h which is included from
include/linux/irq.h as <asm/hw_irq.h>. So the ifdef
below takes care of that too.

> > +#ifdef CONFIG_ARM
> > +	set_irq_flags(irq, IRQF_VALID);
> > +#else
> > +	irq_set_noprobe(irq);
> > +#endif

Regards,

Tony
