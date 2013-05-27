Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab3E0M2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:28:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:47098 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab3E0M2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:28:47 -0400
Date: Mon, 27 May 2013 14:28:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
cc: Daniel Tang <dt.tangr@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC PATCHv4 4/6] clocksource: TI-Nspire timer support
In-Reply-To: <CACRpkda4Qe1e+dkcSgPLf5dcHASvOG=Y=Dvrnv=oGnon+FRzzg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1305271427320.4220@ionos>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com> <1369480087-24786-5-git-send-email-dt.tangr@gmail.com> <CACRpkda4Qe1e+dkcSgPLf5dcHASvOG=Y=Dvrnv=oGnon+FRzzg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 May 2013, Linus Walleij wrote:
> > +static void zevio_timer_set_mode(enum clock_event_mode mode,
> > +               struct clock_event_device *dev)
> > +{
> > +       unsigned long flags;
> > +       struct zevio_timer *timer = container_of(dev,
> > +                       struct zevio_timer,
> > +                       clkevt);
> > +
> > +       local_irq_save(flags);
> > +
> > +       switch (mode) {
> > +       case CLOCK_EVT_MODE_PERIODIC:
> > +               /* Unsupported */
> > +               break;
> > +       case CLOCK_EVT_MODE_RESUME:
> > +       case CLOCK_EVT_MODE_ONESHOT:
> > +               /* Enable timer interrupts */
> > +               writel(TIMER_INTR_MSK, timer->interrupt_regs + IO_INTR_MSK);
> > +               writel(TIMER_INTR_ALL, timer->interrupt_regs + IO_INTR_ACK);
> > +               dev->mode = mode;
> > +               break;
> > +       case CLOCK_EVT_MODE_SHUTDOWN:
> > +       case CLOCK_EVT_MODE_UNUSED:
> > +               /* Disable timer interrupts */
> > +               writel(0, timer->interrupt_regs + IO_INTR_MSK);
> > +               writel(TIMER_INTR_ALL, timer->interrupt_regs + IO_INTR_ACK);
> > +               /* Stop timer */
> > +               writel(CNTL_STOP_TIMER, timer->timer1 + IO_CONTROL);
> > +               dev->mode = mode;
> > +               break;
> > +       }
> 
> Surely both the compiler and checkpatch is complaining that this
> switch does not contain a default: clause?

Well, if you have a switch with an enum, the compiler complains if you
do not have a case for each enum value and the above has all enum
values covered AFAICT. :)

Thanks,

	tglx

