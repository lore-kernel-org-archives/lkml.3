Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751016AbaHUECP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 00:02:15 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48084 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaHUECO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 00:02:14 -0400
Message-ID: <53F56EE8.9050009@linaro.org>
Date: Thu, 21 Aug 2014 12:00:40 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Lv Zheng <lv.zheng@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH 19/19] Documentation: ACPI for ARM64
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <CAOesGMjs1dM37ZoFA-xs7tYYaXP-XC3NjJsj291bCNoDwAXwiw@mail.gmail.com> <20140812182347.GA4100@arm.com> <2152407.NpXOMHAEH6@vostro.rjw.lan> <53EC2B35.5010302@linaro.org> <20140814102723.GB9039@arm.com> <53EDCE56.6020702@linaro.org> <20140815100113.GA18863@arm.com> <53F1C776.4080501@linaro.org> <20140820221702.GA26287@localhost>
In-Reply-To: <20140820221702.GA26287@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-8-21 6:17, Olof Johansson wrote:
> On Mon, Aug 18, 2014 at 05:29:26PM +0800, Hanjun Guo wrote:
>> On 2014-8-15 18:01, Catalin Marinas wrote:
>>> Hanjun,
>>
>> Hi Catalin,
>>
>>>
>>> On Fri, Aug 15, 2014 at 10:09:42AM +0100, Hanjun Guo wrote:
>>>> On 2014-8-14 18:27, Catalin Marinas wrote:
>>>>> On Thu, Aug 14, 2014 at 04:21:25AM +0100, Hanjun Guo wrote:
>>>>>> On 2014-8-14 7:41, Rafael J. Wysocki wrote:
>>>>>>> On Tuesday, August 12, 2014 07:23:47 PM Catalin Marinas wrote:
>>>>>>>> If we consider ACPI unusable on ARM but we still want to start merging
>>>>>>>> patches, we should rather make the config option depend on BROKEN
>>>>>>>> (though if it is that unusable that no real platform can use it, I would
>>>>>>>> rather not merge it at all at this stage).
>>>>>>>
>>>>>>> I agree here.
>>>>>>>
>>>>>>> I would recommend creating a separate branch for that living outside of the
>>>>>>> mainline kernel and merging it when there are real users.
>>>>>>
>>>>>> Real users will coming soon, we already tested this patch set on real hardware
>>>>>> (ARM64 Juno platform),
>>>>>
>>>>> I don't consider Juno a server platform ;) (but it's good enough for
>>>>> development).
>>>>>
>>>>>> and I think ARM64 server chips and platforms will show up before 3.18
>>>>>> is released.
>>>>>
>>>>> That's what I've heard/seen. The questions I have are (a) whether
>>>>> current ACPI patchset is enough to successfully run Linux on such
>>>>> _hardware_ platform (maybe not fully optimised, for example just WFI
>>>>> cpuidle) and (b) whether we still want to mandate a DT in the kernel for
>>>>> such platforms.
>>>>
>>>> For (a), this patch set is only for ARM64 core, not including platform
>>>> specific device drivers, it will be covered by the binding of _DSD or
>>>> explicit definition of PNP ID/ACPI ID(s).
>>>
>>> So we go back to the discussions we had few months ago in Macau. I'm not
>>> concerned about the core ARM and architected peripherals covered by ACPI
>>> 5.1 (as long as the current patches get positive technical review). But
>>> I'm concerned about the additional bits needed for a real SoC like _DSD
>>> definitions, how they get reviewed/accepted (or is it just the vendor's
>>> problem?).
>>
>> As the _DSD patch set sent out by Intel folks, _DSD definitions are just
>> DT definitions. To use _DSD or not, I think it depends on OEM use cases,
>> we can bring up Juno without _DSD (Graeme is working on that, still need
>> some time to clean up the code).
>>
>>>
>>> I think SBSA is too vague to guarantee a kernel image running on a
>>> compliant platform without additional (vendor-specific) tweaks. So what
>>> I asked for is (1) a document (guide) to define the strict set of ACPI
>>> features and bindings needed for a real SoC and (2) proof that the
>>> guidelines are enough for real hardware. I think we have (1) under
>>> review with some good feedback so far. As for (2), we can probably only
>>> discuss Juno openly. I think you could share the additional Juno patches
>>> on this list so that reviewers can assess the suitability. If we deem
>>> ACPI not (yet) suitable for Juno, is there other platform we could see
>>> patches for?
>>
>> Ok, we will send out all the patches for Juno in next version for review,
>> as mentioned above, we still need more time to clean up the code.
>>
>>>
>>>>> Given the answer to (a) and what other features are needed, we may or
>>>>> may not mandate (b). We were pretty clear few months ago that (b) is
>>>>> still required but at the time we were only openly talking about ACPI
>>>>> 5.0 which was lacking many features. I think we need to revisit that
>>>>> position based on how usable ACPI 5.1 for ARM (and current kernel
>>>>> implementation) is. Would you mind elaborating what an ACPI-only
>>>>> platform miss?
>>>>
>>>> Do you mean something still missing? We still miss some features for
>>>> ARM in ACPI, but I think they are not critical, here is the list I can
>>>> remember:
>>>> - ITS for GICv3/4;
>>>> - SMMU support;
>>>> - CPU idle control.
>>>
>>> I agree, these are not critical at this stage. But they only refer to
>>> architected peripherals. Is there anything else missing for an SoC? Do
>>> we need to define clocks?
>>
>> No, I prefer not. As we discussed in this thread before, we don't need
>> clock definition if we use SBSA compatible UART on Juno.
>>
>>>
>>>> For ACPI 5.1, it fixes many problems for ARM:
>>>> - weak definition for GIC, so we introduce visualization, v2m and
>>>>   part of GICv3/4 (redistributors) support.
>>>> - No support for PSCI. Fix it to support PSCI 0.2+;
>>>> - Not support for Always-on timer and SBSA-L1 watchdog.
>>>
>>> These are all good, that's why we shouldn't even talk about ACPI 5.0 in
>>> the ARM context.
>>>
>>>> - How to describe device properties, so _DSD is introduced for
>>>>   device probe.
>>>
>>> For the last bullet, is there any review process (at least like what we
>>> have for DT bindings)? On top of such process, do we have guidelines and
>>> example code on how the Linux support should be implemented. As Olof
>>> mentioned, should we see how the DT and ACPI probing paths work
>>> together? I really think we should be very clear here and not let
>>> vendors invent their own independent methods.
>>
>> As said above, Intel folks provided some good examples for that, and
>> clarified a lot of things:
>>
>> https://lkml.org/lkml/2014/8/17/10
>>
>>>
>>>>> I would expect a new server platform designed with ACPI in mind to
>>>>> require minimal SoC specific code, so we may only see a few patches
>>>>> under drivers/ for such platforms adding ACPI-specific probing (possibly
>>>>> new drivers as well if it's a new component).
>>>>>
>>>>>> For this patch set, DT is the first class citizen at now:
>>>>>>
>>>>>> a) We can always set CONFIG_ACPI as off in Kconfig, and use DT only;
>>>>>
>>>>> Not just off but, based on maturity, depend on EXPERT.
>>>>
>>>> Ok. And don't set ACPI default off (pass acpi=on to enable it)?
>>>
>>> That's my view, just make it clear ACPI is experimental at the Kconfig
>>> level because longer term we won't mandate SoCs to provide both DT and
>>> ACPI tables.
>>
>> I agree with you that if we set ACPI default off, firmware will always
>> pass acpi=on if they want to use ACPI, so I think it would be better
>> to depend on EXPERT instead.
>>
>> Olof, is it ok to you too?
> 
> Given that we're going through all these complex schemes to merge code
> that isn't ready and keeping it off by default, the answer is really
> to continue holding off merging it.
> 
> We already had agreement from earlier this year that we needed to see
> several systems in the _market_ that uses ACPI before we have an idea of
> how messy they will be in reality. Not eval boards, development systems
> or reference designs. None of the current discussion has changed that.

I think some SBSA compatible ARM64 server boards would work, such as Seattle
board, right?

> 
> There's also the concern that there are still significant portions missing
> from 5.1 that won't be there until 5.2 or later. Having experimental
> 5.1 support for a few systems (out of tree) is likely going to result in
> finding out things that don't work well and should be revised -- if we
> don't merge this now then we can avoid having to keep the 5.1 backwards
> compatibility forever. Compare this to how we've been regretting some
> of the early-defined bindings on DT and wish we didn't have to keep
> them around. Please learn from our mistakes. :-)

Yes, there are some features missing in ACPI 5.1, and I list them out
in previous email replying Catalin, as I said, they are not critical
for ARM64 for now.

> 
> On the patches themselves:
> 
> It's great to see the patch sets posted, and they're looking pretty good
> -- things are very much heading in the right direction. My main remaining
> objection is around how it is integrated with the arch code. I don't
> like seeing all the dual code paths that ACPI introduces. It's obvious
> that two completely different entities have written the ACPI and the DT
> portions of the kernel, and we can't really have that situation for a
> brand new architecture like this.
> 
> So, I'd like to see closer integration between the two before code
> goes in. More shared code path and driving the differences through data
> (or possibly function pointers in places, etc), and fewer completely
> separate implementations.

I'm working on it, I hope I can achieve that, you know, it needs
more efforts to do it :)

> 
> Until then, please keep posting patches for review -- it's useful
> to see where it's going. I think it's also useful to get the generic
> ACPI integration merged as it has been already (with pieces going in
> over time).

Sure I will :)

Thanks
Hanjun
