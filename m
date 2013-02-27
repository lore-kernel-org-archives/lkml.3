Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab3B0WlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:41:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58610 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab3B0WlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:41:22 -0500
Message-ID: <512E8B41.8000504@zytor.com>
Date: Wed, 27 Feb 2013 14:40:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>, mingo@redhat.com,
        konrad.wilk@oracle.com, tglx@linutronix.de, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/x86: Flush lazy MMU when DEBUG_PAGEALLOC is set
References: <91983d94-7b7d-4a0b-9470-e7cd823ba139@default>
In-Reply-To: <91983d94-7b7d-4a0b-9470-e7cd823ba139@default>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, policy opinion?

	-hpa

On 02/26/2013 03:57 PM, Boris Ostrovsky wrote:
> 
> ----- hpa@zytor.com wrote:
> 
>> On 02/26/2013 02:56 PM, Boris Ostrovsky wrote:
>>> When CONFIG_DEBUG_PAGEALLOC is set page table updates made by
>>> kernel_map_pages() are not made visible (via TLB flush) immediately
>> if lazy
>>> MMU is on. In environments that support lazy MMU (e.g. Xen) this may
>> lead to
>>> fatal page faults, for example, when zap_pte_range() needs to
>> allocate pages
>>> in __tlb_remove_page() -> tlb_next_batch().
>>>
>>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>> ---
>>>  arch/x86/mm/pageattr.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
>>> index ca1f1c2..7b3216e 100644
>>> --- a/arch/x86/mm/pageattr.c
>>> +++ b/arch/x86/mm/pageattr.c
>>> @@ -1369,6 +1369,8 @@ void kernel_map_pages(struct page *page, int
>> numpages, int enable)
>>>  	 * but that can deadlock->flush only current cpu:
>>>  	 */
>>>  	__flush_tlb_all();
>>> +
>>> +	arch_flush_lazy_mmu_mode();
>>>  }
>>>  
>>>  #ifdef CONFIG_HIBERNATION
>>>
>>
>> This sounds like a critical fix, i.e. a -stable candidate.  Am I
>> correct?
> 
> I considered copying stable but then I decided that this is a debugging feature
> --- kernel_map_pages() is only defined if CONFIG_DEBUG_PAGEALLOC is set and my
> thinking was that stable kernels usually don't do this.
> 
> 
> -boris
> 

