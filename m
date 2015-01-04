Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbbADVQM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 16:16:12 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43021 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752789AbbADVQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 16:16:10 -0500
Date: Sun, 4 Jan 2015 21:15:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150104211555.GB12302@n2100.arm.linux.org.uk>
References: <20150104190123.GA20153@amd>
 <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
 <CA+55aFxMbicJZXzzHc8=vdwCzhz4kdrmZEKjLadZXr7aySZ4zg@mail.gmail.com>
 <alpine.LFD.2.11.1501041526390.18844@knanqh.ubzr>
 <CA+55aFxRRcSJ5i=EcQ-qqMrz0icn28JKjQuH3xGU65hjpVm9hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxRRcSJ5i=EcQ-qqMrz0icn28JKjQuH3xGU65hjpVm9hw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 12:57:09PM -0800, Linus Torvalds wrote:
> On Sun, Jan 4, 2015 at 12:45 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> >
> > Because we're discussing a choice between two evils.
> 
> .. and Pavel pointed you to several screenfuls of google hits for
> people complaining about this.
> 
> End of discussion. Seriously. Your whinging about "support costs" is
> just crying over the fact that you have users. Deal with it.

No, it is not the end of discussion, because what you've done is /really/
equally bad as what Nico was suggesting.  In fact, it /could/ be worse.

Yes, x86 has the bogomips thing, and it switched to using a TSC.  I'm
willing to bet that on x86, the reported bogomips value is pretty similar
whether it's using the TSC or whether it's using a software timing loop.

This is not the case on ARM.  Here's an example where we use a hardware
timer for the delay loop:

Calibrating delay loop (skipped), value calculated using timer frequency.. 6.00 BogoMIPS (lpj=12000)

which is nowhere near the precision of the CPU clock rate.  So, when
we have a hardware timer based delay implementation, the bogomips
value which the kernel has access to (and thus the loops_per_jiffy
value) is totally ... bogus.

If we want to take note of the "screenfulls of users reporting problems"
then we need a much better solution than a simple revert, because right
now, the simple revert makes machines with GHz clock frequencies look
slower than the old 1990s 26-bit ARM technology.

So, Nico's NAK for a simple revert was the _right_ response, even if the
remainder was not correct.

Now, Pavel is the /first/ to report this regression to the ARM kernel
community.  Yes, it may be that other users found a problem and failed
to report it (which seems to be a /very/ common problem.)  Thanks to
Pavel, we're now aware of it, and now we need to fix it properly, not
via some bastardized and broken revert by someone who doesn't know
the implications of that.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
