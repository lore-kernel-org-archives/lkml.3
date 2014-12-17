Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaLQLbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 06:31:11 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:49545 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaLQLbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 06:31:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast
Date: Wed, 17 Dec 2014 13:31:14 +0200
Message-ID: <1479998.RpvOtHlbHE@avalon>
User-Agent: KMail/4.14.3 (Linux/3.16.5-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <CAMuHMdWT+yytt1mRZPLvzyXACcw638Sf4DBjHUTf_+iPjsNzbA@mail.gmail.com>
References: <20141216094854.22639.69181.sendpatchset@w520> <2855304.l47b4KVhTf@avalon> <CAMuHMdWT+yytt1mRZPLvzyXACcw638Sf4DBjHUTf_+iPjsNzbA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Wednesday 17 December 2014 09:30:57 Geert Uytterhoeven wrote:
> On Wed, Dec 17, 2014 at 3:08 AM, Laurent Pinchart wrote:
> >> > Kzm9g-reference still hangs at "Calibrating local timer..." (it did
> >> > work at some point in the past).
> > 
> > kzm9g-reference boots for me with kzm9g_defconfig on Simon's devel branch
> > with
>
> OK.
> 
> I had expected the breakage to be something in my tree, either an issue in
> a -next branch I'm using, an interaction with the CCF patches or so, or a
> config issue (e.g. CONFIG_CPU_IDLE became broken lately if the TWD is
> not in DT).
> 
> > (By the way, how have you tested kzm9g-multiplatform given that none of
> > renesas-drivers-2014-12-08-v3.18, renesas-devel-20141212-v3.18 or today's
> > upstream support multiplatform kernels for sh73a0 ?)
> 
> As I said, my local tree contains lots of extra patches (erhm... 233).

We should probably synchronize at some point and get pending patches merged, 
or you'll loose sanity :-)

What multiplatform support patches do you plan to submit for v3.20 ?

> > Magnus, you have told me that you've performed tests on Marzen with
> > CONFIG_PREEMPT_NONE and with both TWD enabled and disabled. If you could
> > perform the same tests with CONFIG_PREEMPT instead without noticing any
> > regression I think we can merge your patch. Whatever breakage it has
> > caused in the past is likely hidden somewhere beyond eyesight.
> > 
> >> When the time allows I'd like us to try to fix up these somehow. At
> >> least I'll give it a go - I guess Armadillo is difficult without any
> >> board.
> 
> I do have an Armadillo.
> 
> > I'd like that very much. Let's get rid of r8a73a4 legacy (Ulrich's patches
> > should be ready) first, and possible sh73a0 and r8a7740 as well, and then
> > retest our various timers configurations. We should test both
> > CONFIG_PREEMPT and CONFIG_PREEMPT none, with all combination of the CMT,
> > TMU, MTU2, TWD and ARM architected timer enabled.
> 
> Yes, getting rid of more legacy is good. It's just a pity for the Penguin on
> the Armadillo's LCD, which doesn't want to visit armadillo-multiplatform.

-- 
Regards,

Laurent Pinchart

