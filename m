Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaILS7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:59:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34942 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaILS7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:59:31 -0400
Message-ID: <54134291.3040700@codeaurora.org>
Date: Fri, 12 Sep 2014 11:59:29 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>,
        Christopher Covington <cov@codeaurora.org>
CC: Doug Anderson <dianders@chromium.org>, Will Deacon <Will.Deacon@arm.com>,
        "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] clocksource: arch_timer: Allow the device tree to
 specify the physical timer
References: <1410452204-7277-1-git-send-email-dianders@chromium.org> <20140911164710.GW6158@arm.com>	<5411D528.4050605@arm.com> <CAD=FV=XMmizxJFPj0FEhJ7Gk4ZcQaUJDxf_Qq5kGKSvxDFVmzg@mail.gmail.com> <5411DA67.2040402@arm.com> <CAD=FV=UQfo4J3P4wGjOhQZQ5KXKgYAdjPsi1ykKZxQw-FwJz8w@mail.gmail.com> <5411DF5D.8060906@arm.com> <5412DC48.7030708@codeaurora.org> <5412E3BB.9030800@arm.com>
In-Reply-To: <5412E3BB.9030800@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/14 05:14, Marc Zyngier wrote:
> Hi Christopher,
>
> On 12/09/14 12:43, Christopher Covington wrote:
>> Hi Marc,
>>
>> On 09/11/2014 01:43 PM, Marc Zyngier wrote:
>>> On 11/09/14 18:29, Doug Anderson wrote:
>>>
>>>> I did this in the past (again, see Sonny's thread), but didn't
>>>> consider myself knowledgeable to know if that was truly a good test:
>>>>
>>>>        asm volatile("mrc p15, 0, %0, c1, c1, 0" : "=r" (val));
>>>>        pr_info("DOUG: val is %#010x", val);
>>>>        val |= (1 << 2);
>>>>        asm volatile("mcr p15, 0, %0, c1, c1, 0" : : "r" (val));
>>>>        val = 0xffffffff;
>>>>        asm volatile("mrc p15, 0, %0, c1, c1, 0" : "=r" (val));
>>>>        pr_info("DOUG: val is %#010x", val);
>>>>
>>>> The idea being that if you can make modifications to the SCR register
>>>> (and see your changes take effect) then you must be in secure mode.
>>>> In my case the first printout was 0x0 and the second was 0x4.
>>> The main issue is when you're *not* in secure mode. It is likely that
>>> this will explode badly. This is why I suggested something that is set
>>> by the bootloader (after all. it knows which mode it is booted in), and
>>> that the timer driver can use when the CPU comes up.
>> What exactly does "exploding badly" look like? Causing and undefined
>> instruction exception? That's just a branch with a mode switch. Any reason the
>> code couldn't deal with that or even use that to its advantage?
> We surely can handle the UNDEF and do something there. We just can't do
> it the way Doug described it above.
>
>

I suggested doing that for something else a while ago and Will and Dave
we're not thrilled[1]. The suggestion back then was to use DT to
indicate what mode the kernel is running in.

[1]
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-June/105321.html

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

