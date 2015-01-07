Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbbAGPBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:01:48 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56767 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAGPBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:01:46 -0500
Date: Wed, 7 Jan 2015 15:01:36 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <Marc.Zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150107150136.GC2199@e104818-lin.cambridge.arm.com>
References: <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
 <CA+55aFxMbicJZXzzHc8=vdwCzhz4kdrmZEKjLadZXr7aySZ4zg@mail.gmail.com>
 <alpine.LFD.2.11.1501041526390.18844@knanqh.ubzr>
 <CA+55aFxRRcSJ5i=EcQ-qqMrz0icn28JKjQuH3xGU65hjpVm9hw@mail.gmail.com>
 <20150104211555.GB12302@n2100.arm.linux.org.uk>
 <20150105142206.76ca2e18@lxorguk.ukuu.org.uk>
 <CAHkRjk5EAUvdR5ED_M=dB+5yu3RtZLgo_aighUrozovHKnOp=w@mail.gmail.com>
 <CA+55aFwfnT2M1OXzYiy74WCdoRHpKgMby20eqCBe-pEoS6ds-w@mail.gmail.com>
 <CAHkRjk4SLvjRtAv6+kP6uUgA7KWk=_PacqxbT1_7LB-QX4=AGQ@mail.gmail.com>
 <CA+55aFw8x01fBKczTSNkAZ06rwULVp0A=pASJACs8S1SB_Orew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw8x01fBKczTSNkAZ06rwULVp0A=pASJACs8S1SB_Orew@mail.gmail.com>
Thread-Topic: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 01:20:06AM +0000, Linus Torvalds wrote:
> On Tue, Jan 6, 2015 at 3:42 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> >>
> >> That's what bogomips *is*, for chrissake! It's a bogus measure of how
> >> many times you go through the delay loop.
> >
> > I think that's where the misunderstanding is. We don't have any idea
> > how many times we go through the delay loop. We just go through the
> > delay loop until the counter (driven by an independent frequency)
> > changes X times.
> 
> .. and that's exactly what we do on x86 too with the TSC. It's fine.

I may be mistaken but isn't TSC somehow related to the CPU frequency on
x86?

On ARM, the generic/architected timer is not. It's just a timer+counter
(used as clocksource and event generator in Linux) clocked at a
frequency completely independent from the CPU frequency, *no* relation
between the two.

I think a better comparison would be to HPET rather than TSC. But on x86
we use HPET to calibrate the TSC and use the TSC for the delay loop. If
on x86 the BogoMIPS was changed to report the HPET frequency, would you
be ok with it?

> > With the current arm timer-based (and arm64) implementation, the
> > reported BogoMIPS has nothing to do with the CPU benchmark. It just
> > tells you that a X MHz counter needs X*1000000/HZ ticks per jiffy.
> 
> Yes. And that's a valid bogomips. We've done that for ages on x86.

See above, my understanding of TSC is that the x86 BogoMIPS is at least
in some way closely related to the CPU frequency. That's more like a
perf counter on ARM counting the CPU cycles but we don't use it for
udelay() (as it may or may not be enabled in a production system).

-- 
Catalin
