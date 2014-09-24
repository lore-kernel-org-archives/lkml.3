Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaIXOMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:12:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42890 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaIXOMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:12:12 -0400
Message-ID: <5422D138.8000002@codeaurora.org>
Date: Wed, 24 Sep 2014 10:12:08 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Nathan Lynch <Nathan_Lynch@mentor.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Sonny Rao <sonnyrao@chromium.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] arm_arch_timer: VDSO preparation, code consolidation
References: <1411052390-27238-1-git-send-email-nathan_lynch@mentor.com> <20140922153919.GQ25809@arm.com> <20140922223022.GO5182@n2100.arm.linux.org.uk> <5420BE92.7050504@mentor.com>
In-Reply-To: <5420BE92.7050504@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nathan,

On 09/22/2014 08:28 PM, Nathan Lynch wrote:
> On 09/22/2014 05:30 PM, Russell King - ARM Linux wrote:
>> On Mon, Sep 22, 2014 at 04:39:19PM +0100, Will Deacon wrote:
>>> On Thu, Sep 18, 2014 at 03:59:32PM +0100, Nathan Lynch wrote:
>>>> This series contains the necessary changes to allow architected timer
>>>> access from user-space on 32-bit ARM.  This allows the VDSO to support
>>>> high resolution timestamps for clock_gettime and gettimeofday.  This
>>>> also merges substantially similar code from arm and arm64 into the
>>>> core arm_arch_timer driver.
>>>>
>>>> The functional changes are:
>>>> - When available, CNTVCT is made readable by user space on arm, as it
>>>>   is on arm64.
>>>> - The clocksource name becomes "arch_mem_counter" if CP15 access to
>>>>   the counter is not available.
>>>>
>>>> These changes have been carried as part of the ARM VDSO patch set over
>>>> the last several months, but I am splitting them out here as I assume
>>>> they should go through the clocksource maintainers.
>>>
>>> For the series:
>>>
>>>   Acked-by: Will Deacon <will.deacon@arm.com>
>>>
>>> I'm not sure which tree the arch-timer stuff usually goes through, but
>>> the arm/arm64 bits look fine so I'm happy for them to merged together.
>>
>> I raised a while back with Will whether there's much point to having
>> this on ARM.  While it's useful for virtualisation, the majority of
>> 32-bit ARM doesn't run virtualised.  So there's little point in having
>> the VDSO on the majority of platforms - it will just add additional
>> unnecessary cycles slowing down the system calls that the VDSO is
>> designed to try to speed up.
> 
> Hmm, this patch set is merely exposing the hardware counter when it is
> present for the VDSO's use; I take it you have no objection to that?
> 
> While the 32-bit ARM VDSO I've posted (in a different thread) exploits a
> facility that is required by the virtualization option in the
> architecture, its utility is not limited to guest operating systems.

Just to clarify, were the performance improvements you measured from a
virtualized guest or native?

>> So, my view is that this VDSO will only be of very limited use for
>> 32-bit ARM, and should not be exposed to userspace unless there is
>> a reason for it to be exposed (iow, the hardware necessary to support
>> it is present.)
> 
> My thinking is that it should prove useful in a growing subset of v7
> CPUs.  It is useful today on Cortex-A15 and -A7, and I believe -A12 and
> -A17 implement the generic timer facility as well.

I count 18 dts* files that have "arm,armv7-timer", including platforms with
Krait, Exynos, and Tegra processors.

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
