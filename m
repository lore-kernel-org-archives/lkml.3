Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab3HNJX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:23:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43762 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759357Ab3HNJX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:23:28 -0400
Message-ID: <520B4C8E.1010808@linaro.org>
Date: Wed, 14 Aug 2013 11:23:26 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/6] ARM/ARM64: arch_timer: add macros for bits in
 control register
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376414984-14182-2-git-send-email-Sudeep.KarkadaNagesha@arm.com> <520B44CF.6040403@linaro.org> <6071c584a32b1a5f80923818a477a719@www.loen.fr>
In-Reply-To: <6071c584a32b1a5f80923818a477a719@www.loen.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 11:03 AM, Marc Zyngier wrote:
> Hi Daniel,

[ ... ]

>>> --- a/arch/arm64/include/asm/arch_timer.h
>>> +++ b/arch/arm64/include/asm/arch_timer.h
>>> @@ -101,12 +101,16 @@ static inline void
>>> arch_counter_set_user_access(void)
>>>  {
>>>      u32 cntkctl;
>>>
>>> -    /* Disable user access to the timers and the physical counter. */
>>>      asm volatile("mrs    %0, cntkctl_el1" : "=r" (cntkctl));
>>> -    cntkctl &= ~((3 << 8) | (1 << 0));
>>>
>>> -    /* Enable user access to the virtual counter and frequency. */
>>> -    cntkctl |= (1 << 1);
>>> +    /* Disable user access to the timers and the physical counter. */
>>> +    cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
>>> +            | ARCH_TIMER_USR_VT_ACCESS_EN
>>> +            | ARCH_TIMER_USR_PCT_ACCESS_EN);
>>> +
>>> +    /* Enable user access to the virtual counter. */
>>> +    cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
>>> +
>>>      asm volatile("msr    cntkctl_el1, %0" : : "r" (cntkctl));
>>>  }
>>
>> Before doing those changes, I suggest you kill include/asm/arch_timer.h
>> header file and move the functions directly in the arm_arch_timer.c as
>> they are only used by it.
> 
> How do you suggest to proceed? Having #ifdefs in arm_arch_timer.c to
> cope with the inline assembly functions present in both arm and arm64
> include files? Doesn't seem much of a progress to me...

I understand, this is arguable.

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

