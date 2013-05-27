Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab3E0KxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:53:16 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:43458 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab3E0KxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:53:15 -0400
MIME-Version: 1.0
In-Reply-To: <1369480087-24786-5-git-send-email-dt.tangr@gmail.com>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com>
	<1369480087-24786-5-git-send-email-dt.tangr@gmail.com>
Date: Mon, 27 May 2013 12:53:14 +0200
Message-ID: <CACRpkda4Qe1e+dkcSgPLf5dcHASvOG=Y=Dvrnv=oGnon+FRzzg@mail.gmail.com>
Subject: Re: [RFC PATCHv4 4/6] clocksource: TI-Nspire timer support
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Tang <dt.tangr@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 1:08 PM, Daniel Tang <dt.tangr@gmail.com> wrote:

> Add clocksource and clockevent driver for the TI-Nspire.
>
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>

This is *much* improved :-D

But:

> +++ b/drivers/clocksource/zevio-timer.c

> +static void zevio_timer_set_mode(enum clock_event_mode mode,
> +               struct clock_event_device *dev)
> +{
> +       unsigned long flags;
> +       struct zevio_timer *timer = container_of(dev,
> +                       struct zevio_timer,
> +                       clkevt);
> +
> +       local_irq_save(flags);
> +
> +       switch (mode) {
> +       case CLOCK_EVT_MODE_PERIODIC:
> +               /* Unsupported */
> +               break;
> +       case CLOCK_EVT_MODE_RESUME:
> +       case CLOCK_EVT_MODE_ONESHOT:
> +               /* Enable timer interrupts */
> +               writel(TIMER_INTR_MSK, timer->interrupt_regs + IO_INTR_MSK);
> +               writel(TIMER_INTR_ALL, timer->interrupt_regs + IO_INTR_ACK);
> +               dev->mode = mode;
> +               break;
> +       case CLOCK_EVT_MODE_SHUTDOWN:
> +       case CLOCK_EVT_MODE_UNUSED:
> +               /* Disable timer interrupts */
> +               writel(0, timer->interrupt_regs + IO_INTR_MSK);
> +               writel(TIMER_INTR_ALL, timer->interrupt_regs + IO_INTR_ACK);
> +               /* Stop timer */
> +               writel(CNTL_STOP_TIMER, timer->timer1 + IO_CONTROL);
> +               dev->mode = mode;
> +               break;
> +       }

Surely both the compiler and checkpatch is complaining that this
switch does not contain a default: clause?

If you fix this you can add my:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
