Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbaCEDxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:53:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28048 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbaCEDxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:53:54 -0500
Message-ID: <53169FC5.4080006@oracle.com>
Date: Tue, 04 Mar 2014 22:53:41 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bob Liu <lliubbo@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: kernel BUG at mm/huge_memory.c:2785!
References: <530F3F0A.5040304@oracle.com>	<20140227150313.3BA27E0098@blue.fi.intel.com> <CAA_GA1c02iSmkmCLHFkrK4b4W+JppZ4CSMUJ-Wn1rCs-c=dV6g@mail.gmail.com>
In-Reply-To: <CAA_GA1c02iSmkmCLHFkrK4b4W+JppZ4CSMUJ-Wn1rCs-c=dV6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 10:16 PM, Bob Liu wrote:
> On Thu, Feb 27, 2014 at 11:03 PM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
>> Sasha Levin wrote:
>>> Hi all,
>>>
>>> While fuzzing with trinity inside a KVM tools guest running latest -next kernel I've stumbled on the
>>> following spew:
>>>
>>> [ 1428.146261] kernel BUG at mm/huge_memory.c:2785!
>>
>> Hm, interesting.
>>
>> It seems we either failed to split huge page on vma split or it
>> materialized from under us. I don't see how it can happen:
>>
>>    - it seems we do the right thing with vma_adjust_trans_huge() in
>>      __split_vma();
>>    - we hold ->mmap_sem all the way from vm_munmap(). At least I don't see
>>      a place where we could drop it;
>>
>
> Enable CONFIG_DEBUG_VM may show some useful information, at least we
> can confirm weather rwsem_is_locked(&tlb->mm->mmap_sem) before
> split_huge_page_pmd().

I have CONFIG_DEBUG_VM enabled and that code you're talking is not triggering, so mmap_sem
is locked.


Thanks,
Sasha
