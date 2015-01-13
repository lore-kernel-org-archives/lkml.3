Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbbAMJZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:25:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbbAMJZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:25:07 -0500
Message-ID: <54B4E470.1070001@suse.cz>
Date: Tue, 13 Jan 2015 10:25:04 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
CC: akpm@linux-foundation.org, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] mm/thp: Allocate transparent hugepages on local node
References: <1417412803-27234-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20141201113340.GA545@node.dhcp.inet.fi> <87vblvh3b9.fsf@linux.vnet.ibm.com> <547DD100.30307@suse.cz> <87fvcwbuyd.fsf@linux.vnet.ibm.com> <87vbkb7665.fsf@linux.vnet.ibm.com>
In-Reply-To: <87vbkb7665.fsf@linux.vnet.ibm.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 03:42 AM, Aneesh Kumar K.V wrote:
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> writes:
> 
>> Vlastimil Babka <vbabka@suse.cz> writes:
>>
>>> On 12/01/2014 03:06 PM, Aneesh Kumar K.V wrote:
>>>> "Kirill A. Shutemov" <kirill@shutemov.name> writes:
>>>>
>>>>> On Mon, Dec 01, 2014 at 11:16:43AM +0530, Aneesh Kumar K.V wrote:
>>>>>> This make sure that we try to allocate hugepages from local node if
>>>>>> allowed by mempolicy. If we can't, we fallback to small page allocation
>>>>>> based on mempolicy. This is based on the observation that allocating pages
>>>>>> on local node is more beneficial that allocating hugepages on remote node.
>>>>>>
>> ........
>> ......
>>
>>>>>> index e58725aff7e9..fa96af5b31f7 100644
>>>>>> --- a/mm/mempolicy.c
>>>>>> +++ b/mm/mempolicy.c
>>>>>> @@ -2041,6 +2041,46 @@ retry_cpuset:
>>>>>>   	return page;
>>>>>>   }
>>>>>>
>>>>>> +struct page *alloc_hugepage_vma(gfp_t gfp, struct vm_area_struct *vma,
>>>>>> +				unsigned long addr, int order)
>>>
>>> It's somewhat confusing that the name talks about hugepages, yet you 
>>> have to supply the order and gfp. Only the policy handling is tailored 
>>> for hugepages. But maybe it's better than calling the function 
>>> "alloc_pages_vma_local_only_unless_interpolate" :/
>>>
>>
>> I did try to do an API that does
>>
>> struct page *alloc_hugepage_vma(struct vm_area_struct *vma, unsigned long addr)
>>
>> But that will result in further #ifdef in mm/mempolicy, because we will
>> then introduce transparent_hugepage_defrag(vma) and HPAGE_PMD_ORDER
>> there. I was not sure whether we really wanted that.
>>
> 
> Any update on this ? Should I resend the patch rebasing it to the latest
> upstream ?

Yes please.
Thanks

> -aneesh
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

