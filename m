Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab3BXNjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 08:39:49 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:28819 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754229Ab3BXNjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 08:39:48 -0500
X-IronPort-AV: E=Sophos;i="4.84,728,1355094000"; 
   d="scan'208";a="4259588"
Date: Sun, 24 Feb 2013 14:39:45 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Julia Lawall <julia.lawall@lip6.fr>, ben-linux@fluff.org,
        kgene.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, heiko@sntech.de,
        linux-kernel@vger.kernel.org
Subject: Re: question about arch/arm/mach-s3c24xx/irq.c
In-Reply-To: <20130224123849.GH17833@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1302241437360.1943@hadrien>
References: <alpine.DEB.2.02.1302241241440.1943@hadrien> <20130224123849.GH17833@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding the person who introduced the code]

On Sun, 24 Feb 2013, Russell King - ARM Linux wrote:

> On Sun, Feb 24, 2013 at 12:45:11PM +0100, Julia Lawall wrote:
> > The function s3c24xx_irq_map in arch/arm/mach-s3c24xx/irq.c contains the
> > code:
> >
> >                 parent_irq_data = &parent_intc->irqs[irq_data->parent_irq];
> > 		if (!irq_data) {
> >                         pr_err("irq-s3c24xx: no irq data found for hwirq %lu\n",
> >                                hw);
> >                         goto err;
> > 		}
> >
> > At this point irq_data has already been tested, so the null test on
> > irq_data does not look correct.  But I wonder if parent_irq_data could
> > ever be null here?
>
> That would be really obscure - because that would require parent_intc to
> be a "negative" pointer (to counter-act the indexing by
> irq_data->parent_irq).  So it looks to me like the above is redundant.

Even at its original definition irq_data seems unlikely to be NULL:

        struct s3c_irq_intc *intc = h->host_data;
	struct s3c_irq_data *irq_data = &intc->irqs[hw];
	...
	if (!irq_data) {
                pr_err("irq-s3c24xx: no irq data found for hwirq %lu\n", hw);
                return -EINVAL;
        }

That is, it could be an invalid value, but whether it actually hits 0
would seem to depend on the value hw?

Heiko, is NULL really a possibility?

thanks,
julia
