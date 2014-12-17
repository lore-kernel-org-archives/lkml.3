Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaLQBag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 20:30:36 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:65459 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaLQBae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 20:30:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUzys9pbEjUybyDP-3=uemLZuP5WgXeyONxGmADUJJL4A@mail.gmail.com>
References: <20141216094854.22639.69181.sendpatchset@w520>
	<54901420.50403@linaro.org>
	<1418731028.WfBPmyK53y@avalon>
	<CANqRtoTpSadrrpeBxA-ym4MZBfhY_BEyTPr_sfau8dZGCKttOQ@mail.gmail.com>
	<CAMuHMdUzys9pbEjUybyDP-3=uemLZuP5WgXeyONxGmADUJJL4A@mail.gmail.com>
Date: Wed, 17 Dec 2014 10:30:33 +0900
Message-ID: <CANqRtoRTcC_ixjY_Qr1T=2Jhh9qu_5+=Z3YRBDUJX8HWHP6Nog@mail.gmail.com>
Subject: Re: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast
From: Magnus Damm <magnus.damm@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
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

Hi Geert,

On Tue, Dec 16, 2014 at 9:40 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Magnus,
>
> On Tue, Dec 16, 2014 at 12:46 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
>>> Could you please confirm that you've tested both CONFIG_PREEMPT_NONE and
>>> CONFIG_PREEMPT with and without the ARM TWD times, and that you've booted to
>>> userspace and tested timer broadcast on all CPUs ?
>>
>> No I have not. I've booted to user space in initramfs with DT-based
>> TWD on Multiplatform for r8a7779. Without this fix (and other r8a7779
>> TWD bits) I see a lot of breakage. For instance, TWD and SMP boot is
>> broken on r8a7779 - both legacy and non-legacy. I have not gotten to
>> sh73a0 yet, but I assume it is busted too.
>
> FWIW, I applied this patch, and booted the result successfully and without
> any user-visible changes on:
>   - koelsch
>   - armadillo-multiplatform
>   - kzm9g-legacy
>   - kzm9g-multiplatform

Thanks for testing - now let us wait and see what Laurent says.

> Armadillo-legacy is broken, and probably won't come back (cfr.
> https://lkml.org/lkml/2014/12/2/339).
>
> Kzm9g-reference still hangs at "Calibrating local timer..." (it did work
> at some point in the past).

When the time allows I'd like us to try to fix up these somehow. At
least I'll give it a go - I guess Armadillo is difficult without any
board.

> Note that my local tree is based on renesas-drivers-2014-12-08-v3.18,
> renesas-devel-20141212-v3.18, and yesterday's upstream, with CCF,
> PM domain, TWD, and lots of WIP patches from the kitchen sink applied.

The TWD portion above - is it driver code or integration stuff? If the
latter - is there any reason why these can't be picked up by Simon and
merged right away.

My plan is to dig into sh73a0 (maybe including TWD) later today.

Thanks for your help!

/ magnus
