Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161634AbaDPPFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:05:20 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:57490 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756113AbaDPPFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:05:19 -0400
Message-ID: <1397660716.3407.93.camel@hornet>
Subject: Re: [PATCH 04/12] clocksource: Sched clock source for Versatile
 Express
From: Pawel Moll <pawel.moll@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 16 Apr 2014 16:05:16 +0100
In-Reply-To: <CAL_JsqLp5o9OnW5kk33BwdnOP97bjgfpMrR=PKEVH4nP4Tnrfg@mail.gmail.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
	 <1392138636-29240-5-git-send-email-pawel.moll@arm.com>
	 <CAL_JsqLiFE_D+PSFg62sVm3wO0uvZT+pwAVyn7Lwn2ma3+3DoA@mail.gmail.com>
	 <1397658125.3407.84.camel@hornet>
	 <CAL_JsqLp5o9OnW5kk33BwdnOP97bjgfpMrR=PKEVH4nP4Tnrfg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 15:45 +0100, Rob Herring wrote:
> >> > +       setup_sched_clock(vexpress_sys_24mhz_read, 32, 24000000);
> >>
> >> This frequency should come from a DT clock binding. You will have to
> >> fallback to 24MHz for backwards compatibility though.
> >
> > I don't see why would it go to the binding. You may have noticed the
> > register is called "SYS_24MHZ", not "SYS_RANDOMCLOCK". The driver
> > *knows* what the frequency is.
> 
> A 24MHz clock is fed to this h/w block to be used by the counter in
> the block. The DT should describe that.

I even have a clk24mhz in the motherboard's dtsi, so adding a phandle to
the node is trivial, can do it. But my point is that, whatever this
clock is (24MHz, 12MHz then multiplied by 2 inside sysreg, 48MHz divided
by 2 etc.), the value in this register is incremented every 1/24 uS by
definition. And the driver can rely on this. Otherwise we're really
talking about a generic mmio-counter-based clock source, with a
clock-frequency property or a clock phandle (and a multiplier/divider
then?).

> >> > +}
> >>
> >> Wouldn't this code work for Versatile and Realview ARM reference
> >> boards? Even the register offset is the same.
> >>
> >> > +CLOCKSOURCE_OF_DECLARE(vexpress, "arm,vexpress-sysreg",
> >> > +               vexpress_sched_clock_init);
> >
> > I guess it would, yes. The sysregs are annoyingly similar and different
> > at the same time.
> >
> > One could of course try to come up with a "generic mmio clock source"
> > binding, taking the frequency as a property, but don't count on me doing
> > this... ;-)
> 
> I'm not asking for that. Just take care of all ARM Ltd boards which
> have the exact same 24MHz counter at offset 0x5C.

Yes, this is doable by all means. I'll rename it to
"clocksource/versatile.c" so we can add relevant compatible values.

Paweł

