Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbbAHNbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 08:31:21 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:36584 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002AbbAHNbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:31:19 -0500
Date: Thu, 8 Jan 2015 13:29:45 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <Marc.Zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150108132945.31311b10@lxorguk.ukuu.org.uk>
In-Reply-To: <20150107150136.GC2199@e104818-lin.cambridge.arm.com>
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
	<20150107150136.GC2199@e104818-lin.cambridge.arm.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015 15:01:36 +0000
Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Wed, Jan 07, 2015 at 01:20:06AM +0000, Linus Torvalds wrote:
> > On Tue, Jan 6, 2015 at 3:42 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > >>
> > >> That's what bogomips *is*, for chrissake! It's a bogus measure of how
> > >> many times you go through the delay loop.
> > >
> > > I think that's where the misunderstanding is. We don't have any idea
> > > how many times we go through the delay loop. We just go through the
> > > delay loop until the counter (driven by an independent frequency)
> > > changes X times.
> > 
> > .. and that's exactly what we do on x86 too with the TSC. It's fine.
> 
> I may be mistaken but isn't TSC somehow related to the CPU frequency on
> x86?

CPU frequency isn't a constant.

Seriously CPU frequency isn't a useful construct in this discussion. It
too is bogus, so the TSC may be tied to some clock rate but the clock
rate isn't necessarily a constant, and if its a constant its not tied to
the rate your CPU will be issuing instructions at any given point.

The x86 bogomips has a relationship in some cases to the cpu base clock,
but that relationship itself depends on the CPU model.

It's a random nunber. There is broken code out there which breaks if you
don't give it some random number. If you make something up then it
"works" (or is at least no more broken than it was).

I doubt any x86 code would break if we simply printed "1000000" all the
time.


Alan
