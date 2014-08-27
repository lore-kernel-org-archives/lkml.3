Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965084AbaH0V1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:27:52 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:50212 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaH0V1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:27:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMjK65Rc-K0fyFUUJLw6huLT82E-nqJwZO4PqhgopF96Ow@mail.gmail.com>
References: <1409173419-13076-1-git-send-email-sonnyrao@chromium.org> <CAOesGMjK65Rc-K0fyFUUJLw6huLT82E-nqJwZO4PqhgopF96Ow@mail.gmail.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Wed, 27 Aug 2014 14:27:28 -0700
X-Google-Sender-Auth: YNY-_vZJWJVc72Y1ZTBv6Syu1Qk
Message-ID: <CAPz6YkWAPtuy4sAuAK9GtpDgfGsccxeS+pqqe_t_R818Jt01qA@mail.gmail.com>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
To: Olof Johansson <olof@lixom.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 2:19 PM, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Aug 27, 2014 at 2:03 PM, Sonny Rao <sonnyrao@chromium.org> wrote:
>> This is a bug fix for using physical arch timers when
>> the arch_timer_use_virtual boolean is false.  It restores the
>> arch_counter_get_cntpct() function after removal in
>>
>> 0d651e4e "clocksource: arch_timer: use virtual counters"
>>
>> and completes the implementation of memory mapped access for physical
>> timers, so if a system is trying to use physical timers, it will
>> function properly.
>>
>> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
>
> Acked-by: Olof Johansson <olof@lixom.net>
>
> This should have a:
>
> Fixes: 0d651e4e65e9 ("clocksource: arch_timer: use virtual counters")
>
> tag too, and possibly cc stable?

Ok, as far as stable goes, this patch wouldn't apply cleanly going all
the way back to  0d651e4e65e9
As-is, it would need to go after 220069945b29 "clocksource:
arch_timer: Add support for memory mapped timers" and there would need
to be another, simpler, version that went between those two commits.

So, I'm not sure what to do in this situation regarding stable?

>
>
> -Olof
