Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaLQIZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:25:23 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57171 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaLQIZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:25:22 -0500
MIME-Version: 1.0
In-Reply-To: <CANqRtoRTcC_ixjY_Qr1T=2Jhh9qu_5+=Z3YRBDUJX8HWHP6Nog@mail.gmail.com>
References: <20141216094854.22639.69181.sendpatchset@w520>
	<54901420.50403@linaro.org>
	<1418731028.WfBPmyK53y@avalon>
	<CANqRtoTpSadrrpeBxA-ym4MZBfhY_BEyTPr_sfau8dZGCKttOQ@mail.gmail.com>
	<CAMuHMdUzys9pbEjUybyDP-3=uemLZuP5WgXeyONxGmADUJJL4A@mail.gmail.com>
	<CANqRtoRTcC_ixjY_Qr1T=2Jhh9qu_5+=Z3YRBDUJX8HWHP6Nog@mail.gmail.com>
Date: Wed, 17 Dec 2014 09:25:19 +0100
X-Google-Sender-Auth: vlTGGedYRagIjG8KRWDZEQicHIA
Message-ID: <CAMuHMdVDHX4PAvNKaxBDm4n2gjHgi4qv9Ui_FgiCgLPdKAXxcw@mail.gmail.com>
Subject: Re: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Wed, Dec 17, 2014 at 2:30 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
>> Armadillo-legacy is broken, and probably won't come back (cfr.
>> https://lkml.org/lkml/2014/12/2/339).
>>
>> Kzm9g-reference still hangs at "Calibrating local timer..." (it did work
>> at some point in the past).
>
> When the time allows I'd like us to try to fix up these somehow. At
> least I'll give it a go - I guess Armadillo is difficult without any
> board.

To fix Armadillo, we have to instantiate the GIC from C code, which is
a step backwards.

>> Note that my local tree is based on renesas-drivers-2014-12-08-v3.18,
>> renesas-devel-20141212-v3.18, and yesterday's upstream, with CCF,
>> PM domain, TWD, and lots of WIP patches from the kitchen sink applied.
>
> The TWD portion above - is it driver code or integration stuff? If the
> latter - is there any reason why these can't be picked up by Simon and
> merged right away.

Integration stuff. Basically it's
http://www.spinics.net/lists/arm-kernel/msg383413.html

In the mean time, I found the right clock, but I still have to repost that
(sorry, recovering from being ill --- merge windows don't help much ;-)

> My plan is to dig into sh73a0 (maybe including TWD) later today.

Okay, thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
