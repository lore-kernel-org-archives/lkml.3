Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab3EAW5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:57:54 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:40154 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab3EAW5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:57:52 -0400
Date: Thu, 2 May 2013 07:57:48 +0900
From: Simon Horman <horms@verge.net.au>
To: Rob Herring <robherring2@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Bastian Hecht <hechtb+renesas@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/21] ARM: shmobile: don't call irqchip_init
 unconditionally
Message-ID: <20130501225748.GD6517@verge.net.au>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
 <1366910944-3033663-4-git-send-email-arnd@arndb.de>
 <CAL_JsqJWJvxezXy0RGFutxzvBhca-8=uRH2GxdJgzbEGw+OL0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJWJvxezXy0RGFutxzvBhca-8=uRH2GxdJgzbEGw+OL0A@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 10:54:30AM -0500, Rob Herring wrote:
> On Thu, Apr 25, 2013 at 12:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > The irqchip_init function is only available when building
> > with CONFIG_OF enabled, which causes this build failure for
> > bonito_defconfig:
> >
> > arch/arm/mach-shmobile/built-in.o: In function `r8a7740_init_irq_of':
> > :(.init.text+0x580): undefined reference to `irqchip_init'
> >
> > This makes both the OF and the ATAGS portion of the driver
> > conditional, which avoids the build error and also results
> > in smaller object code if not both are enabled, without the
> > need for an #ifdef.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Bastian Hecht <hechtb+renesas@gmail.com>
> > Cc: Simon Horman <horms+renesas@verge.net.au>
> > Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > ---
> >  arch/arm/mach-shmobile/intc-r8a7740.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm/mach-shmobile/intc-r8a7740.c b/arch/arm/mach-shmobile/intc-r8a7740.c
> > index 8871f77..5dc57f1 100644
> > --- a/arch/arm/mach-shmobile/intc-r8a7740.c
> > +++ b/arch/arm/mach-shmobile/intc-r8a7740.c
> > @@ -53,14 +53,23 @@ static void __init r8a7740_init_irq_common(void)
> >
> >  void __init r8a7740_init_irq_of(void)
> >  {
> > +       if (!IS_ENABLED(CONFIG_OF))
> > +               return;
> > +
> >         irqchip_init();
> 
> Why not have an empty irqchip_init? I'd guess we'll need this on other
> platforms and your default mach.

Thanks, I think that could work.

I will see about making it so.
