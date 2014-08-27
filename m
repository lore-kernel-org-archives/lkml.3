Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936080AbaH0WdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 18:33:17 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:62755 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbaH0WdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 18:33:16 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:1c6c:caf9:79ec:cfa9]
In-Reply-To: <53FE5B09.2020403@codeaurora.org>
References: <1409173419-13076-1-git-send-email-sonnyrao@chromium.org>
	<CAOesGMjK65Rc-K0fyFUUJLw6huLT82E-nqJwZO4PqhgopF96Ow@mail.gmail.com>
	<CAPz6YkWAPtuy4sAuAK9GtpDgfGsccxeS+pqqe_t_R818Jt01qA@mail.gmail.com>
	<53FE5B09.2020403@codeaurora.org>
Date: Wed, 27 Aug 2014 15:33:15 -0700
Message-ID: <CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
From: Olof Johansson <olof@lixom.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Sonny Rao <sonnyrao@chromium.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 3:26 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> +Mark (author of change in question)
>
> On 08/27/14 14:27, Sonny Rao wrote:
>> On Wed, Aug 27, 2014 at 2:19 PM, Olof Johansson <olof@lixom.net> wrote:
>>> On Wed, Aug 27, 2014 at 2:03 PM, Sonny Rao <sonnyrao@chromium.org> wrote:
>>>> This is a bug fix for using physical arch timers when
>>>> the arch_timer_use_virtual boolean is false.  It restores the
>>>> arch_counter_get_cntpct() function after removal in
>>>>
>>>> 0d651e4e "clocksource: arch_timer: use virtual counters"
>>>>
>>>> and completes the implementation of memory mapped access for physical
>>>> timers, so if a system is trying to use physical timers, it will
>>>> function properly.
>>>>
>>>> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
>>> Acked-by: Olof Johansson <olof@lixom.net>
>>>
>>> This should have a:
>>>
>>> Fixes: 0d651e4e65e9 ("clocksource: arch_timer: use virtual counters")
>>>
>>> tag too, and possibly cc stable?
>> Ok, as far as stable goes, this patch wouldn't apply cleanly going all
>> the way back to  0d651e4e65e9
>> As-is, it would need to go after 220069945b29 "clocksource:
>> arch_timer: Add support for memory mapped timers" and there would need
>> to be another, simpler, version that went between those two commits.
>>
>> So, I'm not sure what to do in this situation regarding stable?

Greg tends to make a best-effort, you'll find out when he looks at
backporting and can reply with a "punt" or "here's the right patch"
then.

> Is there any reason why the virtual counter can't be read? Maybe we're
> the hyp and we need to make sure we don't use the virtual timer so that
> the guest can use it, but that doesn't have any effect on the usage of
> the virtual counter for the clocksource.

There are several cases where virtual is unusable -- in particular it
might not have been configured properly (i.e. the phys/virt offset is
at a bad value).


-Olof
