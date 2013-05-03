Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763356Ab3ECTJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:09:18 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:29168 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763294Ab3ECTJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:09:17 -0400
Message-ID: <51840B50.6010603@parallels.com>
Date: Fri, 03 May 2013 23:09:04 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Matt Mackall <mpm@selenic.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH 4/5] mm: soft-dirty bits for user memory changes tracking
References: <517FED13.8090806@parallels.com> <517FED64.4020400@parallels.com> <5183A137.4060808@linux.vnet.ibm.com>
In-Reply-To: <5183A137.4060808@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 03:36 PM, Xiao Guangrong wrote:
> On 05/01/2013 12:12 AM, Pavel Emelyanov wrote:
> 
>> +static inline void clear_soft_dirty(struct vm_area_struct *vma,
>> +		unsigned long addr, pte_t *pte)
>> +{
>> +#ifdef CONFIG_MEM_SOFT_DIRTY
>> +	/*
>> +	 * The soft-dirty tracker uses #PF-s to catch writes
>> +	 * to pages, so write-protect the pte as well. See the
>> +	 * Documentation/vm/soft-dirty.txt for full description
>> +	 * of how soft-dirty works.
>> +	 */
>> +	pte_t ptent = *pte;
>> +	ptent = pte_wrprotect(ptent);
>> +	ptent = pte_clear_flags(ptent, _PAGE_SOFT_DIRTY);
>> +	set_pte_at(vma->vm_mm, addr, pte, ptent);
>> +#endif
> 
> It seems that TLBs are not flushed and mmu-notification is not called?

TLBs are flushed by clear_refs_write()->flush_tlb_mm().

As far as MMU notification is concerned -- yes, you're right! I will
prepare the patch for this soon.

> .
> 


Thanks,
Pavel
