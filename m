Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab3EHMQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:16:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54735 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab3EHMQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:16:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 03/21] ARM: shmobile: don't call irqchip_init unconditionally
Date: Wed, 8 May 2013 14:16:06 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>,
        Bastian Hecht <hechtb+renesas@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de> <CAL_JsqJWJvxezXy0RGFutxzvBhca-8=uRH2GxdJgzbEGw+OL0A@mail.gmail.com> <20130501225748.GD6517@verge.net.au>
In-Reply-To: <20130501225748.GD6517@verge.net.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305081416.06611.arnd@arndb.de>
X-Provags-ID: V02:K0:V6SfgmSMFRi0TxGBMo3cAblLQTYmWA88FyoCo5PUTCa
 jXCwSjftaP05JMAiNJgfBPv/96nU7lMaJvjYg8Cs/5KVy4G/Ua
 G9fT8+a4a3hQrZgW+QhDYhyyPyWfTxv8lbZPitR33BVArdAowU
 qyiL1fBwQrEQcSIl3L+NiBo7VJeuq91RzZlxz8v5VYXZxB1pmV
 TbXczIjys3i+28t/J2x7tlGLjnNwGkof3bh2M1Kp92Dl55ls3C
 nrtNBN9g0oUTAYJb3jztBNe4MKvZ05XQAYQa4FSbFH1oOVZSsX
 Qix1BrkX1s+gEqzWs8oiky/pj5ykfQDjjNXmO+JqdtoShIntUC
 DhekbSH7PPBnoDgWUb58=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 May 2013, Simon Horman wrote:
> > > diff --git a/arch/arm/mach-shmobile/intc-r8a7740.c b/arch/arm/mach-shmobile/intc-r8a7740.c
> > > index 8871f77..5dc57f1 100644
> > > --- a/arch/arm/mach-shmobile/intc-r8a7740.c
> > > +++ b/arch/arm/mach-shmobile/intc-r8a7740.c
> > > @@ -53,14 +53,23 @@ static void __init r8a7740_init_irq_common(void)
> > >
> > >  void __init r8a7740_init_irq_of(void)
> > >  {
> > > +       if (!IS_ENABLED(CONFIG_OF))
> > > +               return;
> > > +
> > >         irqchip_init();
> > 
> > Why not have an empty irqchip_init? I'd guess we'll need this on other
> > platforms and your default mach.
> 
> Thanks, I think that could work.
> 
> I will see about making it so.

Ping

Linux-next is still broken for me. There is also anothe shmobile build bug,
I'll send a separate patch for that, which also needs to go into your tree.

	Arnd
