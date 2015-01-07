Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbbAGTA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 14:00:58 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:44802 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbbAGTAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 14:00:51 -0500
Date: Wed, 7 Jan 2015 14:00:48 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr>
References: <20150104190123.GA20153@amd> <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr> <20150104201026.GA23427@amd> <alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr> <20150104203724.GA16372@amd> <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
 <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com> <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr> <20150104212659.GC12302@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr> <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
 <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Linus Torvalds wrote:

> On Wed, Jan 7, 2015 at 10:11 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> >
> > I think this makes sense since __delay() expects the number of loops
> > as argument rather than a duration scaled by some factor (based on the
> > generic timer frequency).
> 
> Gaah. You guys make no sense at all.
> 
> No, __delay() does not expect "number of loops".
> 
> It doesn't do that on x86, and it doesn't even do it on arm.
> 
> It *literally* does exactly the reverse of what you say it does.
> 
> __delay() very much expects a "duration scaled by some factor". The
> factor being "loops_per_jiffy" (ok, so it's a "reverse factor", but
> you get the idea).
> 
> And this is very much exactly why bogomips is that "2 *
> loops_per_jiffy * HZ / 1000000".

I think we're all saying more or less the same thing.

The bogomips *reporting* is back on ARM so user space won't break.

We'll make sure it is scaled properly so not to have orders of magnitude 
discrepancy whether the timer based or the CPU based loop is used for 
the purpose of making people feel good.

Any disagreement?


Nicolas
