Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab3AUVEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:04:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51586 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3AUVED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:04:03 -0500
Date: Mon, 21 Jan 2013 21:03:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Matt Sealey <matt@genesi-usa.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Ben Dooks <ben@simtec.co.uk>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Message-ID: <20130121210341.GW23505@n2100.arm.linux.org.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301212041.17951.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 08:41:17PM +0000, Arnd Bergmann wrote:
> On Monday 21 January 2013, Matt Sealey wrote:
> > 
> > ARM seems to be the only "major" platform not using the
> > kernel/Kconfig.hz definitions, instead rolling it's own and setting
> > what could be described as both reasonable and unreasonable defaults
> > for platforms.

No, you've got this totally wrong.

They're not defaults.  And I object to your use of "unreasonable" too.
I've no idea where you get that from.

There's a reason why we have different HZ rates - some platforms just
can't do the standard 100Hz tick rate.  No way - their timers can't
divide down to that interrupt rate.  Sorry to spoil your ivory tower
with a few facts, but your statement is just rediculous.

The reason we don't use kernel/Kconfig.hz is precisely because of that;
we _HAVE_ to have different HZ definitions on different platforms, and
you'll notice that kernel/Kconfig.hz makes _no_ prevision for this.

Now, while things have moved forwards and we have clocksource/clockevent
support, not every platform can support this timekeeping structure;
ebsa110 certainly can't.  There's one timer and one timer only which
is usable, which even needs to be manually reloaded by the CPU.  No
other independent counter to act as a clock source.

As for Samsung and the rest I can't comment.  The original reason OMAP
used this though was because the 32768Hz counter can't produce 100Hz
without a .1% error - too much error under pre-clocksource
implementations for timekeeping.  Whether that's changed with the
clocksource/clockevent support needs to be checked.

It's entirely possible with the modern clocksource/clockevent support
that many of these platforms can have their alternative HZ tick rates
removed - but there will continue to be a subset which can't, and all
the time that we have such a subset, kernel/Kconfig.hz can't be used
without modification.
