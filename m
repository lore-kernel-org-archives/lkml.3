Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaLQIbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:31:01 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:39522 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbaLQIa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:30:59 -0500
MIME-Version: 1.0
In-Reply-To: <2855304.l47b4KVhTf@avalon>
References: <20141216094854.22639.69181.sendpatchset@w520>
	<CAMuHMdUzys9pbEjUybyDP-3=uemLZuP5WgXeyONxGmADUJJL4A@mail.gmail.com>
	<CANqRtoRTcC_ixjY_Qr1T=2Jhh9qu_5+=Z3YRBDUJX8HWHP6Nog@mail.gmail.com>
	<2855304.l47b4KVhTf@avalon>
Date: Wed, 17 Dec 2014 09:30:57 +0100
X-Google-Sender-Auth: te9_rbSDlNjA1v3uusBL2vpLFdQ
Message-ID: <CAMuHMdWT+yytt1mRZPLvzyXACcw638Sf4DBjHUTf_+iPjsNzbA@mail.gmail.com>
Subject: Re: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, Dec 17, 2014 at 3:08 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>> > Kzm9g-reference still hangs at "Calibrating local timer..." (it did work
>> > at some point in the past).
>
> kzm9g-reference boots for me with kzm9g_defconfig on Simon's devel branch with

OK.

I had expected the breakage to be something in my tree, either an issue in
a -next branch I'm using, an interaction with the CCF patches or so, or a
config issue (e.g. CONFIG_CPU_IDLE became broken lately if the TWD is
not in DT).

> (By the way, how have you tested kzm9g-multiplatform given that none of
> renesas-drivers-2014-12-08-v3.18, renesas-devel-20141212-v3.18 or today's
> upstream support multiplatform kernels for sh73a0 ?)

As I said, my local tree contains lots of extra patches (erhm... 233).

> Magnus, you have told me that you've performed tests on Marzen with
> CONFIG_PREEMPT_NONE and with both TWD enabled and disabled. If you could
> perform the same tests with CONFIG_PREEMPT instead without noticing any
> regression I think we can merge your patch. Whatever breakage it has caused in
> the past is likely hidden somewhere beyond eyesight.
>
>> When the time allows I'd like us to try to fix up these somehow. At
>> least I'll give it a go - I guess Armadillo is difficult without any
>> board.

I do have an Armadillo.

> I'd like that very much. Let's get rid of r8a73a4 legacy (Ulrich's patches
> should be ready) first, and possible sh73a0 and r8a7740 as well, and then
> retest our various timers configurations. We should test both CONFIG_PREEMPT
> and CONFIG_PREEMPT none, with all combination of the CMT, TMU, MTU2, TWD and
> ARM architected timer enabled.

Yes, getting rid of more legacy is good. It's just a pity for the Penguin on the
Armadillo's LCD, which doesn't want to visit armadillo-multiplatform.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
