Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab3EHNWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:22:25 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:62688 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab3EHNWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:22:24 -0400
MIME-Version: 1.0
In-Reply-To: <201305081416.06611.arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
	<CAL_JsqJWJvxezXy0RGFutxzvBhca-8=uRH2GxdJgzbEGw+OL0A@mail.gmail.com>
	<20130501225748.GD6517@verge.net.au>
	<201305081416.06611.arnd@arndb.de>
Date: Wed, 8 May 2013 15:22:22 +0200
Message-ID: <CABYn4sxrcGmnTAJcQR23nMGy8JvqyDrgPOXF4yBFFU_4C8Pc_g@mail.gmail.com>
Subject: Re: [PATCH 03/21] ARM: shmobile: don't call irqchip_init unconditionally
From: Bastian Hecht <hechtb@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Simon Horman <horms@verge.net.au>, Rob Herring <robherring2@gmail.com>,
        Bastian Hecht <hechtb+renesas@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013/5/8 Arnd Bergmann <arnd@arndb.de>:
> On Thursday 02 May 2013, Simon Horman wrote:
>> > > diff --git a/arch/arm/mach-shmobile/intc-r8a7740.c b/arch/arm/mach-shmobile/intc-r8a7740.c
>> > > index 8871f77..5dc57f1 100644
>> > > --- a/arch/arm/mach-shmobile/intc-r8a7740.c
>> > > +++ b/arch/arm/mach-shmobile/intc-r8a7740.c
>> > > @@ -53,14 +53,23 @@ static void __init r8a7740_init_irq_common(void)
>> > >
>> > >  void __init r8a7740_init_irq_of(void)
>> > >  {
>> > > +       if (!IS_ENABLED(CONFIG_OF))
>> > > +               return;
>> > > +
>> > >         irqchip_init();
>> >
>> > Why not have an empty irqchip_init? I'd guess we'll need this on other
>> > platforms and your default mach.
>>
>> Thanks, I think that could work.
>>
>> I will see about making it so.
>
> Ping

I have sent out a patch adding an empty irqchip_init() when
CONFIG_IRQCHIP is not set with the subject
[PATCH] irqchip: Add irqchip_init dummy function

> Linux-next is still broken for me. There is also anothe shmobile build bug,
> I'll send a separate patch for that, which also needs to go into your tree.

Oh thanks Arnd for this fix!

Cheers,

 Bastian
