Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab3EIDjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 23:39:12 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:41288 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab3EIDjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 23:39:11 -0400
Date: Thu, 9 May 2013 12:38:19 +0900
From: Simon Horman <horms@verge.net.au>
To: Bastian Hecht <hechtb@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robherring2@gmail.com>,
        Bastian Hecht <hechtb+renesas@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/21] ARM: shmobile: don't call irqchip_init
 unconditionally
Message-ID: <20130509033819.GC13994@verge.net.au>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
 <CAL_JsqJWJvxezXy0RGFutxzvBhca-8=uRH2GxdJgzbEGw+OL0A@mail.gmail.com>
 <20130501225748.GD6517@verge.net.au>
 <201305081416.06611.arnd@arndb.de>
 <CABYn4sxrcGmnTAJcQR23nMGy8JvqyDrgPOXF4yBFFU_4C8Pc_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABYn4sxrcGmnTAJcQR23nMGy8JvqyDrgPOXF4yBFFU_4C8Pc_g@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 03:22:22PM +0200, Bastian Hecht wrote:
> Hi,
> 
> 2013/5/8 Arnd Bergmann <arnd@arndb.de>:
> > On Thursday 02 May 2013, Simon Horman wrote:
> >> > > diff --git a/arch/arm/mach-shmobile/intc-r8a7740.c b/arch/arm/mach-shmobile/intc-r8a7740.c
> >> > > index 8871f77..5dc57f1 100644
> >> > > --- a/arch/arm/mach-shmobile/intc-r8a7740.c
> >> > > +++ b/arch/arm/mach-shmobile/intc-r8a7740.c
> >> > > @@ -53,14 +53,23 @@ static void __init r8a7740_init_irq_common(void)
> >> > >
> >> > >  void __init r8a7740_init_irq_of(void)
> >> > >  {
> >> > > +       if (!IS_ENABLED(CONFIG_OF))
> >> > > +               return;
> >> > > +
> >> > >         irqchip_init();
> >> >
> >> > Why not have an empty irqchip_init? I'd guess we'll need this on other
> >> > platforms and your default mach.
> >>
> >> Thanks, I think that could work.
> >>
> >> I will see about making it so.
> >
> > Ping
> 
> I have sent out a patch adding an empty irqchip_init() when
> CONFIG_IRQCHIP is not set with the subject
> [PATCH] irqchip: Add irqchip_init dummy function

Thanks.

> > Linux-next is still broken for me. There is also anothe shmobile build bug,
> > I'll send a separate patch for that, which also needs to go into your tree.

Sorry about that. I though I had pushed your fix (the first hunk of the
patch that started this thread), but it seems that I did not.

> Oh thanks Arnd for this fix!
> 
> Cheers,
> 
>  Bastian
