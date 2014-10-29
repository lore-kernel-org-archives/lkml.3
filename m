Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbaJ2INS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:13:18 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:35716 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbaJ2INN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:13:13 -0400
MIME-Version: 1.0
In-Reply-To: <20141029020833.GA29787@verge.net.au>
References: <20141028004131.GA8280@verge.net.au>
	<CAMuHMdXmOeJowF9FSQtoUzNK4zohvSYm+r3qp41-JigAOJ=+fg@mail.gmail.com>
	<20141028092305.GA11937@verge.net.au>
	<CAMuHMdUnwT7a1Gewz3AW-R9EaQBfYkJ2y7ZQ6uW4GaxBAHXzXg@mail.gmail.com>
	<20141029001258.GE20702@verge.net.au>
	<20141029020833.GA29787@verge.net.au>
Date: Wed, 29 Oct 2014 09:13:11 +0100
X-Google-Sender-Auth: LdrnnPelMsNWOYS1NwDnZUhYdPg
Message-ID: <CAMuHMdWkP=t2WL64X8vKdOPXW_ZpbibXQ66un8GfVTWoc-o+tw@mail.gmail.com>
Subject: Re: non-Multiplatform APE6EVM broken in v3.18-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 3:08 AM, Simon Horman <horms@verge.net.au> wrote:
> On Wed, Oct 29, 2014 at 09:12:58AM +0900, Simon Horman wrote:
>> On Tue, Oct 28, 2014 at 10:32:32AM +0100, Geert Uytterhoeven wrote:
>> > On Tue, Oct 28, 2014 at 10:23 AM, Simon Horman <horms@verge.net.au> wrote:
>> > > On Tue, Oct 28, 2014 at 08:59:28AM +0100, Geert Uytterhoeven wrote:
>> > >> On Tue, Oct 28, 2014 at 1:41 AM, Simon Horman <horms@verge.net.au> wrote:
>> > >> > I have noticed that there appears to be a regression between v3.17 and
>> > >> > v3.18-rc1 such that non-multiplatform APE6EVM (ape6evm_defconfig) no longer
>> > >> > boots.  This appears to be the case using both reference DT (MACH_APE6EVM)

> It seems that the boot stops here:
>
> ...
> smsc911x smsc911x eth0: MAC Address: 00:08:f7:00:02:4b
> rcar_thermal rcar_thermal: Runtime PM disabled, clock forced on.
> rcar_thermal rcar_thermal: 3 sensor probed
> sh_mobile_sdhi sh_mobile_sdhi.0: Runtime PM disabled, clock forced on.
> sh_mobile_sdhi sh_mobile_sdhi.0: No vqmmc regulator found
>
> I re-ran my bisection and this time the following showed up as the culprit.
>
> I suspect that the initialisation of mmcif, which is usually the next
> device to be initialised, sleeps and never wakes up because the timer is
> disabled.
>
> commit c387f07e6205cc13f57c1def5f885bf0a20e1c2d
> Author: Sudeep Holla <sudeep.holla@arm.com>
> Date:   Mon Sep 29 01:50:05 2014 +0200
>
>     clocksource: arm_arch_timer: Discard unavailable timers correctly

Apparently reported and fixed by Laurent and a few others, cfr.
http://www.spinics.net/lists/arm-kernel/msg371615.html

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
