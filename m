Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaBSDI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:08:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaBSDI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:08:57 -0500
Message-ID: <5304202B.20203@redhat.com>
Date: Tue, 18 Feb 2014 22:08:27 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        peterz@infradead.org, chegu_vinod@hp.com, aarcange@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH -mm 3/3] move mmu notifier call from change_protection
 to change_pmd_range
References: <1392761566-24834-1-git-send-email-riel@redhat.com> <1392761566-24834-4-git-send-email-riel@redhat.com> <alpine.DEB.2.02.1402181823420.20791@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402181823420.20791@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 09:24 PM, David Rientjes wrote:
> On Tue, 18 Feb 2014, riel@redhat.com wrote:
> 
>> From: Rik van Riel <riel@redhat.com>
>>
>> The NUMA scanning code can end up iterating over many gigabytes
>> of unpopulated memory, especially in the case of a freshly started
>> KVM guest with lots of memory.
>>
>> This results in the mmu notifier code being called even when
>> there are no mapped pages in a virtual address range. The amount
>> of time wasted can be enough to trigger soft lockup warnings
>> with very large KVM guests.
>>
>> This patch moves the mmu notifier call to the pmd level, which
>> represents 1GB areas of memory on x86-64. Furthermore, the mmu
>> notifier code is only called from the address in the PMD where
>> present mappings are first encountered.
>>
>> The hugetlbfs code is left alone for now; hugetlb mappings are
>> not relocatable, and as such are left alone by the NUMA code,
>> and should never trigger this problem to begin with.
>>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Reported-by: Xing Gang <gang.xing@hp.com>
>> Tested-by: Chegu Vinod <chegu_vinod@hp.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> Might have been cleaner to move the 
> mmu_notifier_invalidate_range_{start,end}() to hugetlb_change_protection() 
> as well, though.

I can certainly do that if you want.  Just let me know
and I'll send a v2 of patch 3 :)

-- 
All rights reversed
