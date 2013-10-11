Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab3JKBT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:19:28 -0400
Received: from intranet.asianux.com ([58.214.24.6]:44616 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab3JKBT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:19:27 -0400
X-Spam-Score: -100.8
Message-ID: <525751E2.3020207@asianux.com>
Date: Fri, 11 Oct 2013 09:18:26 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] arm64: include: asm: atomic.h: use 'unsigned int'
 and 'atomic_t' instead of 'unsigned long' for atomic_clear_mask()
References: <52561137.3070608@asianux.com> <5256117A.4000009@asianux.com> <5256121A.9030504@asianux.com> <52561269.60900@asianux.com> <20131010100733.GH3817@mudshark.cambridge.arm.com> <52568998.2080108@asianux.com> <20131010142305.GG6199@mudshark.cambridge.arm.com>
In-Reply-To: <20131010142305.GG6199@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 10:23 PM, Will Deacon wrote:
> On Thu, Oct 10, 2013 at 12:03:52PM +0100, Chen Gang wrote:
>> On 10/10/2013 06:07 PM, Will Deacon wrote:
>>> On Thu, Oct 10, 2013 at 03:35:21AM +0100, Chen Gang wrote:
>>>> In current kernel wide source, for arm64, only s390 scsi drivers use
>>>> atomic_clear_mask(), now, s390 itself need use 'unsigned int' and
>>>> 'atomic_t', so need match s390's atomic_clear_mask().
>>>>
>>>>
>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>> ---
>>>>  arch/arm64/include/asm/atomic.h |   13 +++++++------
>>>>  1 files changed, 7 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
>>>> index 8363644..58808fc 100644
>>>> --- a/arch/arm64/include/asm/atomic.h
>>>> +++ b/arch/arm64/include/asm/atomic.h
>>>> @@ -126,16 +126,17 @@ static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
>>>>  	return oldval;
>>>>  }
>>>>  
>>>> -static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
>>>> +static inline void atomic_clear_mask(unsigned int mask, atomic_t *ptr)
>>>>  {
>>>> -	unsigned long tmp, tmp2;
>>>> +	unsigned int tmp;
>>>
>>> Same comment here as for ARM; I think you want a signed int.
>>>
>>
>> OK, replied in patch 2/3 for ARM.
>>
>> BTW: do arm64 need atomic_clear_mask()?
> 
> No. Neither ARM nor arm64 need this function.
> 

OK, thank you for your confirmation.

Hmm... can we remove atomic_clear_mask() from ARM and arm64? (in my
opinion, if not need, better to remove it).

> Will
> 
> 

Thanks.
-- 
Chen Gang
