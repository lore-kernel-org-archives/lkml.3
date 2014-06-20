Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966981AbaFTLTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:19:49 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:63067 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966470AbaFTLTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:19:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140620081509.GA25104@arm.com>
References: <1403167145-5267-1-git-send-email-amit.daniel@samsung.com>
	<53A2B9C3.1050906@gmail.com>
	<CAD=FV=VmC-p4_R1GV3U3bg1JojTzNYKyFTa8o8QMJ=3m=WuRYA@mail.gmail.com>
	<53A30D08.6070107@gmail.com>
	<CAD=FV=UjFJ9utR9i=Xu4DRQ7gdULCtXQXgsQ8gUYm6-V5U4GaQ@mail.gmail.com>
	<53A31291.9000007@gmail.com>
	<20140620081509.GA25104@arm.com>
Date: Fri, 20 Jun 2014 16:49:47 +0530
X-Google-Sender-Auth: NE_I54cySVM5NrJsHAjPpnQh89c
Message-ID: <CADGdYn6ZCvnfod3smE_mdJhK-BdkHMtno2GCH8jzX=BRWDCRPQ@mail.gmail.com>
Subject: Re: [PATCH v2] clocksource: exynos-mct: Register the timer for stable udelay
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        David Riley <davidriley@chromium.org>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 1:45 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Thu, Jun 19, 2014 at 05:40:49PM +0100, Tomasz Figa wrote:
>> On 19.06.2014 18:31, Doug Anderson wrote:
>> >>> My personal vote would be to submit a patch to change "cycles_t" to
>> >>> always be 32-bits.  Given that 32-bits was fine for udelay() for ARM
>> >>> that seems sane and simple.  If someone later comes up with a super
>> >>> compelling reason why we need 64-bit timers for udelay (really??) then
>> >>> they can later add all the complexity needed.
>> >>
>> >> Yes, this could work. I'm not sure what else cycles_t is used for, though.
>> >
>> > True, it is a bit questionable to change this since it's a type that's
>> > not obviously just for udelay().  Perhaps a better option would be to
>> > make a new typedef for the result of read_current_timer().  ...or just
>> > change it to return a u32?
>> >
>>
>> Sounds good to me, but let's hear other opinions. I'm adding Will and
>> Jonathan as they wrote the ARM delay timer code.
>
> I think cycles_t is only used for small interval calculations at the moment,
> but I remember Ted mentioning something about using it (or something
> similar) as a source of early entropy, in which case the more bits the
> better.
>
Will,
Thanks for the clarification that cycles_t is used for short
intervals. So it is safe to return lower 32 bit
counter for read_current_timer.

Tomasz, Doug,
As of now let me send a minimal implementation of this read delay
timer to fix the broken udelay for exynos platforms so that it goes to
upstream in rc releases. I will also prepare a fix for all
raw_readl/writel in mct to relaxed version to make it consistent.

> That said, I can't find any code in the tree to that effect.
>
> Will
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
