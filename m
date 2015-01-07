Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbbAGGli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 01:41:38 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:33944 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbbAGGlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 01:41:37 -0500
Date: Wed, 7 Jan 2015 01:41:33 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <CAHkRjk4SLvjRtAv6+kP6uUgA7KWk=_PacqxbT1_7LB-QX4=AGQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1501070131540.7959@knanqh.ubzr>
References: <20150104190123.GA20153@amd> <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr> <CA+55aFxMbicJZXzzHc8=vdwCzhz4kdrmZEKjLadZXr7aySZ4zg@mail.gmail.com> <alpine.LFD.2.11.1501041526390.18844@knanqh.ubzr> <CA+55aFxRRcSJ5i=EcQ-qqMrz0icn28JKjQuH3xGU65hjpVm9hw@mail.gmail.com>
 <20150104211555.GB12302@n2100.arm.linux.org.uk> <20150105142206.76ca2e18@lxorguk.ukuu.org.uk> <CAHkRjk5EAUvdR5ED_M=dB+5yu3RtZLgo_aighUrozovHKnOp=w@mail.gmail.com> <CA+55aFwfnT2M1OXzYiy74WCdoRHpKgMby20eqCBe-pEoS6ds-w@mail.gmail.com>
 <CAHkRjk4SLvjRtAv6+kP6uUgA7KWk=_PacqxbT1_7LB-QX4=AGQ@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2015, Catalin Marinas wrote:

> I think that's where the misunderstanding is. We don't have any idea
> how many times we go through the delay loop. We just go through the
> delay loop until the counter (driven by an independent frequency)
> changes X times. From arch/arm/lib/delay.c:
> 
> static void __timer_delay(unsigned long cycles)
> {
>         cycles_t start = get_cycles();
> 
>         while ((get_cycles() - start) < cycles)
>                 cpu_relax();
> }
> 
> where the number of cycles is based on the pre-calculated lpj_fine
> value using the counter/timer frequency (read from DT or hardware).
> 
> I think Nico already pointed out that the way we use loops_per_jiffy
> when the udelay is timer-based is probably wrong. We actually need a
> ticks_per_jiffy which has nothing to do with loops_per_jiffy, the
> former is actually completely independent from the CPU speed.

We already have the former.

The patch I posted rehabilitated thelater.  That's the sanest we can do.
Then we have both a timer based delay and a bogomips that is somewhat 
related to CPU speed again.

I also posted another patch to remove the 3355 bogomips limitation on 
ARM.


Nicolas
