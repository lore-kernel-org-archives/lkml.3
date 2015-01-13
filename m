Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbbAMCma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 21:42:30 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:47717 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbAMCm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 21:42:29 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] mm/thp: Allocate transparent hugepages on local node
In-Reply-To: <87fvcwbuyd.fsf@linux.vnet.ibm.com>
References: <1417412803-27234-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20141201113340.GA545@node.dhcp.inet.fi> <87vblvh3b9.fsf@linux.vnet.ibm.com> <547DD100.30307@suse.cz> <87fvcwbuyd.fsf@linux.vnet.ibm.com>
User-Agent: Notmuch/0.19+2~g32855b9 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Tue, 13 Jan 2015 08:12:10 +0530
Message-ID: <87vbkb7665.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011302-0025-0000-0000-000000E8272D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> writes:

> Vlastimil Babka <vbabka@suse.cz> writes:
>
>> On 12/01/2014 03:06 PM, Aneesh Kumar K.V wrote:
>>> "Kirill A. Shutemov" <kirill@shutemov.name> writes:
>>>
>>>> On Mon, Dec 01, 2014 at 11:16:43AM +0530, Aneesh Kumar K.V wrote:
>>>>> This make sure that we try to allocate hugepages from local node if
>>>>> allowed by mempolicy. If we can't, we fallback to small page allocation
>>>>> based on mempolicy. This is based on the observation that allocating pages
>>>>> on local node is more beneficial that allocating hugepages on remote node.
>>>>>
> ........
> ......
>
>>>>> index e58725aff7e9..fa96af5b31f7 100644
>>>>> --- a/mm/mempolicy.c
>>>>> +++ b/mm/mempolicy.c
>>>>> @@ -2041,6 +2041,46 @@ retry_cpuset:
>>>>>   	return page;
>>>>>   }
>>>>>
>>>>> +struct page *alloc_hugepage_vma(gfp_t gfp, struct vm_area_struct *vma,
>>>>> +				unsigned long addr, int order)
>>
>> It's somewhat confusing that the name talks about hugepages, yet you 
>> have to supply the order and gfp. Only the policy handling is tailored 
>> for hugepages. But maybe it's better than calling the function 
>> "alloc_pages_vma_local_only_unless_interpolate" :/
>>
>
> I did try to do an API that does
>
> struct page *alloc_hugepage_vma(struct vm_area_struct *vma, unsigned long addr)
>
> But that will result in further #ifdef in mm/mempolicy, because we will
> then introduce transparent_hugepage_defrag(vma) and HPAGE_PMD_ORDER
> there. I was not sure whether we really wanted that.
>

Any update on this ? Should I resend the patch rebasing it to the latest
upstream ?

-aneesh

