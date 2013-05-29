Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965149Ab3E2IXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:23:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:54867 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964992Ab3E2IXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:23:22 -0400
Date: Wed, 29 May 2013 10:23:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [patch 7/8] genirq: generic chip: Add linear irq domain
 support
In-Reply-To: <20130529022249.DE5ED3E14F1@localhost>
Message-ID: <alpine.LFD.2.02.1305291019450.2995@ionos>
References: <20130503212258.385818955@linutronix.de> <20130506142348.321859745@linutronix.de> <20130506142539.450634298@linutronix.de> <20130529022249.DE5ED3E14F1@localhost>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013, Grant Likely wrote:
> > --- linux-2.6.orig/include/linux/irq.h
> > +++ linux-2.6/include/linux/irq.h
> > @@ -678,6 +678,8 @@ struct irq_chip_type {
> >   * @wake_active:	Interrupt is marked as an wakeup from suspend source
> >   * @num_ct:		Number of available irq_chip_type instances (usually 1)
> >   * @private:		Private data for non generic chip callbacks
> > + * @installed:		bitfield to denote installed interrupts
> > + * @domain:		irq domain pointer
> >   * @list:		List head for keeping track of instances
> >   * @chip_types:		Array of interrupt irq_chip_types
> >   *
> > @@ -699,6 +701,8 @@ struct irq_chip_generic {
> >  	u32			wake_active;
> >  	unsigned int		num_ct;
> >  	void			*private;
> > +	unsigned long		installed;
> 
> This is probably something that the irqdomain should be keeping track of
> internally, but that's an issue for a separate patch series.

Ok. I just need access to that information, so I can figure out if
it's the first irq of the chip which gets mapped. I need this for
initializing the mask cache.
 
> [...]
> > +struct irq_domain_ops irq_generic_chip_ops = {
> > +	.map = irq_map_generic_chip,
> > +	.xlate = irq_domain_xlate_onecell,
> 
> As discussed on IRC, should use onetwocell here for greater
> compatibility with existing bindings.

Changed that.

Thanks,

	tglx
