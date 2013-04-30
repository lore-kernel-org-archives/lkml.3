Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259Ab3D3B6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 21:58:45 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:47041 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378Ab3D3B6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 21:58:42 -0400
Date: Tue, 30 Apr 2013 10:58:40 +0900
From: Simon Horman <horms@verge.net.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bastian Hecht <hechtb+renesas@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH 03/21] ARM: shmobile: don't call irqchip_init
 unconditionally
Message-ID: <20130430015840.GG22535@verge.net.au>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
 <1366910944-3033663-4-git-send-email-arnd@arndb.de>
 <20130426004835.GA20070@verge.net.au>
 <201304291649.08084.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304291649.08084.arnd@arndb.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 04:49:07PM +0200, Arnd Bergmann wrote:
> On Friday 26 April 2013, Simon Horman wrote:
> > > diff --git a/arch/arm/mach-shmobile/intc-r8a7740.c b/arch/arm/mach-shmobile/intc-r8a7740.c
> > > index 8871f77..5dc57f1 100644
> > > --- a/arch/arm/mach-shmobile/intc-r8a7740.c
> > > +++ b/arch/arm/mach-shmobile/intc-r8a7740.c
> > > @@ -53,14 +53,23 @@ static void __init r8a7740_init_irq_common(void)
> > >  
> > >  void __init r8a7740_init_irq_of(void)
> > >  {
> > > +     if (!IS_ENABLED(CONFIG_OF))
> > > +             return;
> > > +
> > 
> > In other parts of the shmobile I believe that such code is
> > guarded by #ifdef CONFIG_OF and I believe not guarding this code in
> > some way was an oversight.
> > 
> > The above change seems fine to me.
> 
> Ok. The change that broke the code is only present in linux-next from
> one of your trees, but is not in arm-soc. Could you include the change
> in your tree, either by folding into one of your patches or adapting
> my patch appropriately?

Yes, or of course. I'll queue-up your patch with
the second hunk (below) removed.

> > > +
> > > +     gic_dist_base = ioremap_nocache(0xc2800000, 0x1000);
> > > +     gic_cpu_base = ioremap_nocache(0xc2000000, 0x1000);
> > >  
> > >       /* initialize the Generic Interrupt Controller PL390 r0p0 */
> > >       gic_init(0, 29, gic_dist_base, gic_cpu_base);
> > 
> > This one seems broken as the armadillo800eva board currently uses
> > it to initialise GIC even if CONFIG_ATAGS is not defined.
> > 
> > I did test the above change on the armadillo800eva board
> > with the above change and CONFIG_ATAGS disabled, the result was
> > a boot failure. With the change reverted booting seems fine.
> 
> Yes, I see my mistake now. The second change was clearly wrong
> as this function is also used for DT boards, not for ATAGS boards.
> 
> 	Arnd
> 
