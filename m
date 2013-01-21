Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3AUXRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:17:23 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51729 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3AUXRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:17:22 -0500
Date: Mon, 21 Jan 2013 23:13:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matt Sealey <matt@genesi-usa.com>
Cc: John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Message-ID: <20130121231318.GC23505@n2100.arm.linux.org.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org> <CAKGA1b=D5CNikijoOAk5xP6TC-nB_gEGtS05ncrPR68sQTMrxw@mail.gmail.com> <50FDC2DD.7090406@linaro.org> <CAKGA1bmtTH1N8nx79MGiMighdQROpNtpvAZXhHKT+mT3kcazBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1bmtTH1N8nx79MGiMighdQROpNtpvAZXhHKT+mT3kcazBQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 04:54:31PM -0600, Matt Sealey wrote:
> Hmm, I think it might be appreciated for people looking at this stuff
> (same as I stumbled into it) for a little comment on WHY the default
> is 200. That way you don't wonder even if you know why EBSA110 has a
> HZ=200 default, why Exynos is lumped in there too (to reduce the
> number of interrupts firing?

Err, _reduce_ ?

Can you please explain why changing HZ from 100 to 200 is a reduction?

> Maybe the Exynos timer interrupt is kind
> of a horrid core NMI kind of thing and it's desirable for it not to be
> every millisecond,

Huh?  HZ=100 is centisecond intervals...

> or maybe it has the same restrictions as EBSA110,
> but where would anyone go to find out this information?)

Maybe the mailing list archives.  No, not these ones.  The full ones
on lists.arm.linux.org.uk.  The lurker archives contain every email
that has been on these mailing lists stretching back into the late
1990s.  They are the only _full_ archives (give or take a few problems
with connectivity between lists.arm.linux.org.uk and lists.infradead.org
throwing the archiver subscription off.)

> I think then the default 100 at the end of the arch/arm/Kconfig is
> saying "you are not allowed to know that such a thing as rope even
> exists," when in fact what we should be doing is just making sure they
> can't swing it over the rafters.. am I taking the analogy too far? :)

I think you're understanding is just waaaayyyyy off.  That default is
there because that is the _architecture_ _default_ and there _has_ to
be a default.  No, including kernel/Kconfig.hz won't give us any kind
of non-specified default because, as I've already said in one of my
other mails, you can't supplement Kconfig symbol definitions by
declaring it multiple times.

> I know where the 60Hz clocksource might come from, the old Amiga
> platforms have one based on the PSU frequency (50Hz in Europe, 60Hz
> US/Japan). Even a 60Hz clocksource is useful though (on the Amiga, at
> least, it is precisely the vsync clock for synchronizing your display
> output on TV-out, which makes it completely useful for the framebuffer
> driver), but.. you just won't expect to assign it as sched_clock or
> your delay timer. And if anyone does I'd expect they'd know full well
> it'd not run so well.

Except in the UK where it'd be 50Hz for the TV out.  (Lengthy irrelevant
explanation why this is so for UK cut.)

> >From that description, we are booting with standard HZ on ARM, and the
> core sched_clock (as in we can call setup_sched_clock)
> and/or/both/optionally using a real delay_timer switch to HRT mode if
> we have the right equipment available in the kernel and at runtime on
> the SoC.. but the process scheduler isn't compiled with the means to
> actually take advantage of us being in HRT mode?

Don't mix sched_clock() into this; it has nothing to do with HZ at all.
You're confusing your apples with your oranges.

> A simple BUILD_BUG_ON and a BUG_ON right after each other in the
> appropriate clocksource driver solves that.. if there's an insistence
> on having at least some rope, we can put them in a field and tell them
> they have to use the moon to actually hang themselves...

No it doesn't - it introduces a whole load of new ways to make the
kernel build or boot fail for pointless reasons - more failures, more
regressions.

No thank you.
