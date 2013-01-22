Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3AVAH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:07:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51775 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3AVAH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:07:57 -0500
Date: Tue, 22 Jan 2013 00:02:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matt Sealey <matt@genesi-usa.com>
Cc: John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Message-ID: <20130122000241.GE23505@n2100.arm.linux.org.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org> <CAKGA1b=D5CNikijoOAk5xP6TC-nB_gEGtS05ncrPR68sQTMrxw@mail.gmail.com> <50FDC2DD.7090406@linaro.org> <CAKGA1bmtTH1N8nx79MGiMighdQROpNtpvAZXhHKT+mT3kcazBQ@mail.gmail.com> <20130121231318.GC23505@n2100.arm.linux.org.uk> <CAKGA1b=wDE9ujby_gcoHJudsG=JbWDdNRo+thCe8BhoJLi+B5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1b=wDE9ujby_gcoHJudsG=JbWDdNRo+thCe8BhoJLi+B5Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 05:30:31PM -0600, Matt Sealey wrote:
> But it would effectively stop users drinking kool-aid.. if you set
> your HZ to something stupid, you don't even get a kernel to build, and
> certainly don't get to boot past the first 40 lines of boot messages..
> I think most people would rather a build error, or a runtime
> unmistakable, unmissable warning than a subtle and almost
> imperceptible skew in NTP synchronization, to use your example.

1. a kernel which doesn't build.  What do you think both Arnd and myself
   have been doing for the last few years, building such things as
   random configurations and such like, finding stuff that doesn't work
   and fixing the kernel so that we end up with _NO_ configuration which
   fails to build.

   Are you seriously about to tell us that we're wasting our time and we
   should just let the kernel build fail in all horrid sorts of ways?

2. As for NTP behaviour... well, have you ever experienced a system where
   NTP has to keep doing step corrections on the time of day, where some
   steps (eg, backwards) cause services to quit because time of day must
   be monotonic...

What you're proposing is that we litter the ARM arch with all sorts of
tests for CONFIG_HZ and #error out on ones that don't make sense.  I
think you're smoking crack.

What I think is that we should _not_ allow CONFIG_HZ to be set to
anything which isn't appropriate for the platforms - or indeed the
reverse.  That's going to be extremely difficult to do with multi-arch
because it's effectively a two-way dependency.

I don't think we can do that with kernel/Kconfig.hz unless we introduce
another layer of permissive configurations for the HZ_1000... etc, but
I'm not sure that anyone outside ARM would like even that.
