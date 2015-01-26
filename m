Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbbAZOiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:38:23 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35784 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbbAZOiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:38:18 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4] mm/thp: Allocate transparent hugepages on local node
In-Reply-To: <54C62803.8010105@suse.cz>
References: <1421753671-16793-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20150120164832.abe2e47b760e1a8d7bb6055b@linux-foundation.org> <54C62803.8010105@suse.cz>
User-Agent: Notmuch/0.19+30~gd241a48 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 26 Jan 2015 20:07:18 +0530
Message-ID: <8761btvc9t.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012614-0029-0000-0000-0000010C4BBC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vlastimil Babka <vbabka@suse.cz> writes:

> On 01/21/2015 01:48 AM, Andrew Morton wrote:
>> On Tue, 20 Jan 2015 17:04:31 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
>>> + * Should be called with the mm_sem of the vma hold.
>> 
>> That's a pretty cruddy sentence, isn't it?  Copied from
>> alloc_pages_vma().  "vma->vm_mm->mmap_sem" would be better.
>> 
>> And it should tell us whether mmap_sem required a down_read or a
>> down_write.  What purpose is it serving?
>
> This is already said for mmap_sem further above this comment line, which
> should be just deleted (and from alloc_hugepage_vma comment too).
>
>>> + *
>>> + */
>>> +struct page *alloc_hugepage_vma(gfp_t gfp, struct vm_area_struct *vma,
>>> +				unsigned long addr, int order)
>> 
>> This pointlessly bloats the kernel if CONFIG_TRANSPARENT_HUGEPAGE=n?
>> 
>> 
>> 
>> --- a/mm/mempolicy.c~mm-thp-allocate-transparent-hugepages-on-local-node-fix
>> +++ a/mm/mempolicy.c
>
> How about this cleanup on top? I'm not fully decided on the GFP_TRANSHUGE test.
> This is potentially false positive, although I doubt anything else uses the same
> gfp mask bits.

IMHO I found that to be more complex.

>
> Should "hugepage" be extra bool parameter instead? Should I #ifdef the parameter
> only for CONFIG_TRANSPARENT_HUGEPAGE, or is it not worth the ugliness?
>

I guess if we really want to consolidate both the functions, we should
try the above, without all those #ifdef. It is just one extra arg.  But
then is the reason to consolidate that strong ?

-aneesh

