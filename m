Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbaGUMfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:35:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:59076 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaGUMfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:35:19 -0400
Date: Mon, 21 Jul 2014 14:35:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ley Foon Tan <lftan@altera.com>
cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH v2 19/29] nios2: Time keeping
In-Reply-To: <CAFiDJ5_AQ7Rby5Ta=mhzwQ28hiR_VbxbxXemSHqP9OyJmJx+Kw@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1407211430300.20847@nanos>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <1405413956-2772-20-git-send-email-lftan@altera.com> <alpine.DEB.2.10.1407151152310.24854@nanos> <CAFiDJ5_AQ7Rby5Ta=mhzwQ28hiR_VbxbxXemSHqP9OyJmJx+Kw@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014, Ley Foon Tan wrote:
> On Tue, Jul 15, 2014 at 6:00 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> >> +     count =
> >> +             readw(timer_membase + ALTERA_TIMER_SNAPH_REG) << 16 |
> >> +             readw(timer_membase + ALTERA_TIMER_SNAPL_REG);
> >
> > So you're serious about having a new architecture with a timer
> > implementation which cant read 32bit in one go? I'm impressed ...
> This is to compatible with 16-bit and 32-bit processors. The older
> version of Nios is 16-bit and Nios II is 32-bit.
> But this timer core doesn't get updated after Nios is end of life.

Sigh.
 
> >> +static cycle_t nios2_timer_read(struct clocksource *cs)
> >> +{
> >> +     unsigned long flags;
> >> +     u32 cycles;
> >> +     u32 tcn;
> >> +
> >> +     local_irq_save(flags);
> >> +     tcn = NIOS2_TIMER_PERIOD - 1 - read_timersnapshot();
> >> +     cycles = nios2_timer_count;
> >
> > This is wrong and completely pointless. The core code takes care about
> > the offset.
> This offset is different from the core code. The core code is handling
> cycle counter overlapping.
> But this is for the offset between last timer interrupt counter and
> current counter (read_timersnapshot()).

So IOW, if you ever lose a timer interrupt, your timekeeping is off by
a full cycle.

Great hardware design, really.

Thanks,

	tglx
