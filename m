Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaLPMkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 07:40:51 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:46086 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaLPMkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 07:40:49 -0500
MIME-Version: 1.0
In-Reply-To: <CANqRtoTpSadrrpeBxA-ym4MZBfhY_BEyTPr_sfau8dZGCKttOQ@mail.gmail.com>
References: <20141216094854.22639.69181.sendpatchset@w520>
	<54901420.50403@linaro.org>
	<1418731028.WfBPmyK53y@avalon>
	<CANqRtoTpSadrrpeBxA-ym4MZBfhY_BEyTPr_sfau8dZGCKttOQ@mail.gmail.com>
Date: Tue, 16 Dec 2014 13:40:47 +0100
X-Google-Sender-Auth: Zaro52_3A99MB-HDUGSrGDc2XIQ
Message-ID: <CAMuHMdUzys9pbEjUybyDP-3=uemLZuP5WgXeyONxGmADUJJL4A@mail.gmail.com>
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

On Tue, Dec 16, 2014 at 12:46 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
>> Could you please confirm that you've tested both CONFIG_PREEMPT_NONE and
>> CONFIG_PREEMPT with and without the ARM TWD times, and that you've booted to
>> userspace and tested timer broadcast on all CPUs ?
>
> No I have not. I've booted to user space in initramfs with DT-based
> TWD on Multiplatform for r8a7779. Without this fix (and other r8a7779
> TWD bits) I see a lot of breakage. For instance, TWD and SMP boot is
> broken on r8a7779 - both legacy and non-legacy. I have not gotten to
> sh73a0 yet, but I assume it is busted too.

FWIW, I applied this patch, and booted the result successfully and without
any user-visible changes on:
  - koelsch
  - armadillo-multiplatform
  - kzm9g-legacy
  - kzm9g-multiplatform

Armadillo-legacy is broken, and probably won't come back (cfr.
https://lkml.org/lkml/2014/12/2/339).

Kzm9g-reference still hangs at "Calibrating local timer..." (it did work
at some point in the past).

Note that my local tree is based on renesas-drivers-2014-12-08-v3.18,
renesas-devel-20141212-v3.18, and yesterday's upstream, with CCF,
PM domain, TWD, and lots of WIP patches from the kitchen sink applied.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
