Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934563AbaFTIAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:00:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:57288 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbaFTIAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:00:30 -0400
Date: Fri, 20 Jun 2014 10:00:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [patch 09/13] irqchip: spear_shirq: Kill the clear_reg
 nonsense
In-Reply-To: <CAOh2x==nhq6OHkd9U17L3r-_7qnnjYLyiqiKYpGdMuSVEj07=g@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1406200954440.5170@nanos>
References: <20140619212606.431750473@linutronix.de> <20140619212713.570396433@linutronix.de> <CAOh2x==nhq6OHkd9U17L3r-_7qnnjYLyiqiKYpGdMuSVEj07=g@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014, Viresh Kumar wrote:

> On Fri, Jun 20, 2014 at 3:04 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > None of the chips has a ACK register.
> 
> I need to recheck on this after looking at datasheets. Arranging for
> them, will revert by tomorrow.
> 
> > The code brainlessly fiddles
> > with the enable register, so it might even reenable a disabled
> > interrupt at least on spear300.
> 
> Ack/Clear register is only configured for SPEAr320, how will it
> make a difference to SPEAr300 ?

Sorry, my bad. misread the code. So this wants a different
changelog.

> And for SPEAr320 as well, the offset mentioned in code for clear
> register is different then ENABLE register.

I still don't see why you'd write something into the status register
on 320, which is RO according to documentation.

> > @@ -150,13 +141,6 @@ static struct spear_shirq spear320_shirq
> >         .nr_irqs        = 7,
> >         .mask           = ((0x1 << 7) - 1) << 0,
> >         .disabled       = 1,
> > -       .regs = {
> > -               .enb_reg = SPEAR320_INT_ENB_MASK_REG,
> > -               .reset_to_enb = 1,
> > -               .status_reg = SPEAR320_INT_STS_MASK_REG,
> > -               .clear_reg = SPEAR320_INT_CLR_MASK_REG,
> > -               .reset_to_clear = 1,
> > -       },
> 
> Was removing .regs completely intentional?
> 
> I don't see these registers getting added again in later patches.

Yes, because that block is NEVER used because disabled = 1

Thanks,

	tglx

