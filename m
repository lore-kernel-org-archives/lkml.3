Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab3FJI53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:57:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55894 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab3FJI50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:57:26 -0400
Message-ID: <51B594F2.9030000@arm.com>
Date: Mon, 10 Jun 2013 09:57:22 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2] arm64: kernel: compiling issue, need delete read_current_timer().
References: <5199C725.8050102@asianux.com> <168084c28e8ba5124c05553e97463172@localhost> <20130520095606.GH31359@mudshark.cambridge.arm.com> <519AF2DC.2040200@asianux.com> <20130521085325.GB10453@mudshark.cambridge.arm.com> <519B425D.4030806@asianux.com> <51A32F40.1050309@asianux.com> <51B2B50A.1050305@asianux.com>
In-Reply-To: <51B2B50A.1050305@asianux.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 10 Jun 2013 08:57:23.0387 (UTC) FILETIME=[85D268B0:01CE65B8]
X-MC-Unique: 113061009572303201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/13 05:37, Chen Gang wrote:
> Hello Maintainers:
> 
> Please help check it, when you have time.
> 
> Thanks.
> 
> On 05/27/2013 06:02 PM, Chen Gang wrote:
>> Hello Maintainers:
>>
>> Please help check this patch whether OK, when you have time.
>>
>> Thanks.
>>
>> On 05/21/2013 05:46 PM, Chen Gang wrote:
>>>
>>> Under arm64, we will calibrate the delay loop statically using a known
>>> timer frequency, so delete read_current_timer(), or it will cause
>>> compiling issue with allmodconfig.
>>>
>>> The related error:
>>>   ERROR: "read_current_timer" [lib/rbtree_test.ko] undefined!
>>>   ERROR: "read_current_timer" [lib/interval_tree_test.ko] undefined!
>>>   ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined!
>>>   ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!
>>>
>>>
>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>> ---
>>>  arch/arm64/include/asm/timex.h |    6 +++---
>>>  arch/arm64/kernel/time.c       |    6 ------
>>>  2 files changed, 3 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/timex.h b/arch/arm64/include/asm/timex.h
>>> index b24a31a..81a076e 100644
>>> --- a/arch/arm64/include/asm/timex.h
>>> +++ b/arch/arm64/include/asm/timex.h
>>> @@ -16,14 +16,14 @@
>>>  #ifndef __ASM_TIMEX_H
>>>  #define __ASM_TIMEX_H
>>>  
>>> +#include <asm/arch_timer.h>
>>> +
>>>  /*
>>>   * Use the current timer as a cycle counter since this is what we use for
>>>   * the delay loop.
>>>   */
>>> -#define get_cycles()	({ cycles_t c; read_current_timer(&c); c; })
>>> +#define get_cycles()	arch_counter_get_cntvct()
>>>  
>>>  #include <asm-generic/timex.h>
>>>  
>>> -#define ARCH_HAS_READ_CURRENT_TIMER
>>> -
>>>  #endif
>>> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
>>> index a551f88..03dc371 100644
>>> --- a/arch/arm64/kernel/time.c
>>> +++ b/arch/arm64/kernel/time.c
>>> @@ -68,12 +68,6 @@ unsigned long long notrace sched_clock(void)
>>>  	return arch_timer_read_counter() * sched_clock_mult;
>>>  }
>>>  
>>> -int read_current_timer(unsigned long *timer_value)
>>> -{
>>> -	*timer_value = arch_timer_read_counter();
>>> -	return 0;
>>> -}
>>> -
>>>  void __init time_init(void)
>>>  {
>>>  	u32 arch_timer_rate;

Sorry for the delay replying. This looks good to me.

FWIW:
Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...

