Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab3C1Pge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:36:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47160 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab3C1Pgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:36:32 -0400
Date: Thu, 28 Mar 2013 15:36:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robherring2@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: irq: Call irqchit_init if no init_irq
	function is specified
Message-ID: <20130328153617.GC3368@n2100.arm.linux.org.uk>
References: <1364463704-13692-1-git-send-email-maxime.ripard@free-electrons.com> <51545832.1050504@gmail.com> <20130328145155.GB3368@n2100.arm.linux.org.uk> <201303281525.42334.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303281525.42334.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 03:25:42PM +0000, Arnd Bergmann wrote:
> On Thursday 28 March 2013, Russell King - ARM Linux wrote:
> > Better:
> > 
> > #ifdef CONFIG_OF
> >         if (!machine_desc->init_irq)
> >                 irqchip_init();
> >         else
> > #endif
> >                 machine_desc->init_irq();
> > 
> > which means we don't even get the test if !OF, and if someone mistakenly
> > sets this to NULL for a !OF platform, they get to know about it.
> 
> Right. With the new IS_DEFINED() macro, we could even turn this into
> 
> 	if (IS_DEFINED(CONFIG_OF) && !machine_desc->init_irq)
> 		irqchip_init();
> 	else
> 		machine_desc->init_irq();
> 
> to the same effect.

Provided irqchip_init() keeps its prototype visible, then yes.
