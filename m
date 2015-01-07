Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbbAGUyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:54:01 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50566 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754224AbbAGUx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:53:58 -0500
Date: Wed, 7 Jan 2015 20:53:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
        Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150107205346.GO12302@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
 <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com>
 <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr>
 <20150104212659.GC12302@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
 <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
 <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com>
 <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr>
 <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
 <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 03:34:42PM -0500, Nicolas Pitre wrote:
> On Wed, 7 Jan 2015, Linus Torvalds wrote:
> 
> > On Wed, Jan 7, 2015 at 11:00 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > >
> > > We'll make sure it is scaled properly so not to have orders of magnitude
> > > discrepancy whether the timer based or the CPU based loop is used for
> > > the purpose of making people feel good.
> > 
> > Why?
> > 
> > You'd basically be lying.  And it might actually hide real problems.
> > If the scaling hides the fact that the timer source cannot do a good
> > job at microsecond resolution delays, then it's not just lying, it's
> > lying in ways that hide real issues. So why should that kind of
> > behavior be encouraged? The actual *real* unscaled resolution of the
> > timer is valid and real information.
> 
> I think you are missing something fundamental in this thread.

I think what Linus is trying to tell us is that:

1. Where the kernel uses a software loop for implementing delays,
   the kernel bogomips gives us a calibration of that loop.

2. Where the kernel uses a hardware timer for implementing delays,
   the kernel bogomips gives us a calibration of that hardware timer.

And it doesn't matter whether or not that timer has anything to do with
the raw CPU speed.

In other words, bogomips is a statement about the accuracy of the
internal kernel mechanism being used for delays, nothing more, nothing
less.

Now, if I understand Linus correctly, what irks him is when someone
upgrades a kernel on a platform, and some userland breaks.  That's
something which I've said multiple times I don't have a problem
agreeing with, and I suspect no one in this thread would disagree
that this is a serious failing, and one which needs fixing ASAP.

However, if running userland on platform A works, and but it doesn't
work on platform B.  The breakage may well be due to platform A reporting
300 bogomips because it's using the kernel software loop, and platform
B reporting 6 bogomips because its using a hardware timer, but the CPU
is actually faster.  However, this is not a kernel problem, and it
certainly is not a regression.  It's a userspace bug which needs
userspace to fix.

Does that make the difference clear?

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
