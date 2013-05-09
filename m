Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3EIEWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 00:22:16 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:43169 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab3EIEWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 00:22:12 -0400
Date: Thu, 9 May 2013 13:22:21 +0900
From: Simon Horman <horms@verge.net.au>
To: Bastian Hecht <hechtb@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Bastian Hecht <hechtb+renesas@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 03/21] ARM: shmobile: don't call irqchip_init
 unconditionally
Message-ID: <20130509042220.GB7832@verge.net.au>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
 <CAL_JsqJWJvxezXy0RGFutxzvBhca-8=uRH2GxdJgzbEGw+OL0A@mail.gmail.com>
 <20130501225748.GD6517@verge.net.au>
 <201305081416.06611.arnd@arndb.de>
 <CABYn4sxrcGmnTAJcQR23nMGy8JvqyDrgPOXF4yBFFU_4C8Pc_g@mail.gmail.com>
 <20130509033819.GC13994@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509033819.GC13994@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 12:38:19PM +0900, Simon Horman wrote:
> On Wed, May 08, 2013 at 03:22:22PM +0200, Bastian Hecht wrote:
> > Hi,
> > 
> > 2013/5/8 Arnd Bergmann <arnd@arndb.de>:
> > > On Thursday 02 May 2013, Simon Horman wrote:
> > >> > > diff --git a/arch/arm/mach-shmobile/intc-r8a7740.c b/arch/arm/mach-shmobile/intc-r8a7740.c
> > >> > > index 8871f77..5dc57f1 100644
> > >> > > --- a/arch/arm/mach-shmobile/intc-r8a7740.c
> > >> > > +++ b/arch/arm/mach-shmobile/intc-r8a7740.c
> > >> > > @@ -53,14 +53,23 @@ static void __init r8a7740_init_irq_common(void)
> > >> > >
> > >> > >  void __init r8a7740_init_irq_of(void)
> > >> > >  {
> > >> > > +       if (!IS_ENABLED(CONFIG_OF))
> > >> > > +               return;
> > >> > > +
> > >> > >         irqchip_init();
> > >> >
> > >> > Why not have an empty irqchip_init? I'd guess we'll need this on other
> > >> > platforms and your default mach.
> > >>
> > >> Thanks, I think that could work.
> > >>
> > >> I will see about making it so.
> > >
> > > Ping
> > 
> > I have sent out a patch adding an empty irqchip_init() when
> > CONFIG_IRQCHIP is not set with the subject
> > [PATCH] irqchip: Add irqchip_init dummy function
> 
> Thanks.
> 
> > > Linux-next is still broken for me. There is also anothe shmobile build bug,
> > > I'll send a separate patch for that, which also needs to go into your tree.
> 
> Sorry about that. I though I had pushed your fix (the first hunk of the
> patch that started this thread), but it seems that I did not.

Sorry once again for the delay in addressing this.
I have pushed a refreshed next branch which includes
both Bastian's fix for irqchip_init() and the patch
that Arnd posted relating to symbol renames.

These changes should appear in linux-next in the not to distant future.
