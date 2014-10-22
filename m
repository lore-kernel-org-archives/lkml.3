Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaJVOBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:01:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbaJVOBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:01:07 -0400
Message-ID: <5447B84C.4000909@redhat.com>
Date: Wed, 22 Oct 2014 15:59:40 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Bob Liu <lliubbo@gmail.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Gleb Natapov <gleb@kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jianyu Zhan <nasa4836@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        kvm@vger.kernel.org, linux390@de.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH v3 0/4] mm: new function to forbid zeropage mappings for
 a process
References: <1413976170-42501-1-git-send-email-dingel@linux.vnet.ibm.com>
In-Reply-To: <1413976170-42501-1-git-send-email-dingel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/22/2014 01:09 PM, Dominik Dingel wrote:
> s390 has the special notion of storage keys which are some sort of page flags
> associated with physical pages and live outside of direct addressable memory.
> These storage keys can be queried and changed with a special set of instructions.
> The mentioned instructions behave quite nicely under virtualization, if there is: 
> - an invalid pte, then the instructions will work on memory in the host page table
> - a valid pte, then the instructions will work with the real storage key
> 
> Thanks to Martin with his software reference and dirty bit tracking,
> the kernel does not issue any storage key instructions as now a 
> software based approach will be taken, on the other hand distributions 
> in the wild are currently using them.
> 
> However, for virtualized guests we still have a problem with guest pages 
> mapped to zero pages and the kernel same page merging.  
> With each one multiple guest pages will point to the same physical page
> and share the same storage key.
> 
> Let's fix this by introducing a new function which s390 will define to
> forbid new zero page mappings.  If the guest issues a storage key related 
> instruction we flag the mm_struct, drop existing zero page mappings
> and unmerge the guest memory.
> 
> v2 -> v3:
>  - Clearing up patch description Patch 3/4
>  - removing unnecessary flag in mmu_context (Paolo)

... and zero the mm_use_skey flag correctly, too. :)

> v1 -> v2: 
>  - Following Dave and Paolo suggestion removing the vma flag

Thanks, the patches look good.  I expect that they will either go in
through the s390 tree, or come in via Christian.

If the latter, Martin, please reply with your Acked-by.

Paolo
