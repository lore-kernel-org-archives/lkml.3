Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaLQNXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 08:23:18 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:40053 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaLQNXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 08:23:16 -0500
MIME-Version: 1.0
In-Reply-To: <2855304.l47b4KVhTf@avalon>
References: <20141216094854.22639.69181.sendpatchset@w520>
	<CAMuHMdUzys9pbEjUybyDP-3=uemLZuP5WgXeyONxGmADUJJL4A@mail.gmail.com>
	<CANqRtoRTcC_ixjY_Qr1T=2Jhh9qu_5+=Z3YRBDUJX8HWHP6Nog@mail.gmail.com>
	<2855304.l47b4KVhTf@avalon>
Date: Wed, 17 Dec 2014 22:23:15 +0900
Message-ID: <CANqRtoR7Jn_r7DfSwq30ZVB7jdt9SY+7mEDqf5bduXBRX8N9Zw@mail.gmail.com>
Subject: Re: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
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

On Wed, Dec 17, 2014 at 11:08 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus and Geert,
>
> On Wednesday 17 December 2014 10:30:33 Magnus Damm wrote:
>> On Tue, Dec 16, 2014 at 9:40 PM, Geert Uytterhoeven wrote:
>> > On Tue, Dec 16, 2014 at 12:46 PM, Magnus Damm wrote:
>> >>> Could you please confirm that you've tested both CONFIG_PREEMPT_NONE and
>> >>> CONFIG_PREEMPT with and without the ARM TWD times, and that you've
>> >>> booted to userspace and tested timer broadcast on all CPUs ?
>> >>
>> >> No I have not. I've booted to user space in initramfs with DT-based
>> >> TWD on Multiplatform for r8a7779. Without this fix (and other r8a7779
>> >> TWD bits) I see a lot of breakage. For instance, TWD and SMP boot is
>> >> broken on r8a7779 - both legacy and non-legacy. I have not gotten to
>> >> sh73a0 yet, but I assume it is busted too.
>> >
>> > FWIW, I applied this patch, and booted the result successfully and without
>> >
>> > any user-visible changes on:
>> >   - koelsch
>> >   - armadillo-multiplatform
>> >   - kzm9g-legacy
>> >   - kzm9g-multiplatform
>>
>> Thanks for testing - now let us wait and see what Laurent says.
>>
>> > Armadillo-legacy is broken, and probably won't come back (cfr.
>> > https://lkml.org/lkml/2014/12/2/339).
>> >
>> > Kzm9g-reference still hangs at "Calibrating local timer..." (it did work
>> > at some point in the past).
>
> kzm9g-reference boots for me with kzm9g_defconfig on Simon's devel branch with
> CONFIG_PREEMPT_NONE but fails to boot with CONFIG_PREEMPT. The platform
> doesn't instantiate the TMU at the moment anyway, so it's unrelated to this
> patch.

Ok, thanks for testing. That makes sense.

> Given that kzm9g-legacy works for me regardless of the preempt configuration
> and on the TMU cpumask, that kzm9g-reference doesn't use TMU, and that you've
> tested kzm9g-multiplaform successfully, I think we can consider that this
> patch is safe from a kzm9g point of view.

I think so too.

> (By the way, how have you tested kzm9g-multiplatform given that none of
> renesas-drivers-2014-12-08-v3.18, renesas-devel-20141212-v3.18 or today's
> upstream support multiplatform kernels for sh73a0 ?)

My recently posted patch set:
[PATCH v2 00/05] ARM: shmobile: sh73a0 and kzm9g Multiplatform revisit

> Magnus, you have told me that you've performed tests on Marzen with
> CONFIG_PREEMPT_NONE and with both TWD enabled and disabled. If you could
> perform the same tests with CONFIG_PREEMPT instead without noticing any
> regression I think we can merge your patch. Whatever breakage it has caused in
> the past is likely hidden somewhere beyond eyesight.

Sorry, but I have not had any time to test this today. What I can tell
from yesterday is that legacy Marzen seemed busted and without my
patch(es) (including this one) multiplatform Marzen was busted as
well.

I'll most likely be buried in paper work tomorrow, but I'll see if I
can find time dealing with Marzen legacy tomorrow. In general I find
legacy upkeep rather time consuming since it seems to degrade rather
quickly, so I much rather spend time fixing up multiplatform.

>> When the time allows I'd like us to try to fix up these somehow. At
>> least I'll give it a go - I guess Armadillo is difficult without any
>> board.
>
> I'd like that very much. Let's get rid of r8a73a4 legacy (Ulrich's patches
> should be ready) first, and possible sh73a0 and r8a7740 as well, and then
> retest our various timers configurations. We should test both CONFIG_PREEMPT
> and CONFIG_PREEMPT none, with all combination of the CMT, TMU, MTU2, TWD and
> ARM architected timer enabled.

Sure, those are the ones I usually care about. From my side I find the
TWD and arch timer upkeep to be heavy enough as-is without considering
the preempt case. But you're right - we should cover all of them.

Thanks,

/ magnus
