Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbbAMVtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:49:15 -0500
Received: from mga03.intel.com ([134.134.136.65]:39922 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbbAMVtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:49:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,751,1413270000"; 
   d="scan'208";a="669349482"
Message-ID: <54B592D6.4090406@linux.intel.com>
Date: Tue, 13 Jan 2015 13:49:10 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, Pavel Emelyanov <xemul@openvz.org>,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] mm: rename mm->nr_ptes to mm->nr_pgtables
References: <1421176456-21796-1-git-send-email-kirill.shutemov@linux.intel.com> <1421176456-21796-2-git-send-email-kirill.shutemov@linux.intel.com> <20150113214355.GC2253@moon>
In-Reply-To: <20150113214355.GC2253@moon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 01:43 PM, Cyrill Gorcunov wrote:
> On Tue, Jan 13, 2015 at 09:14:15PM +0200, Kirill A. Shutemov wrote:
>> We're going to account pmd page tables too. Let's rename mm->nr_pgtables
>> to something more generic.
>>
>> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> --- a/fs/proc/task_mmu.c
>> +++ b/fs/proc/task_mmu.c
>> @@ -64,7 +64,7 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
>>  		data << (PAGE_SHIFT-10),
>>  		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
>>  		(PTRS_PER_PTE * sizeof(pte_t) *
>> -		 atomic_long_read(&mm->nr_ptes)) >> 10,
>> +		 atomic_long_read(&mm->nr_pgtables)) >> 10,
> 
> This implies that (PTRS_PER_PTE * sizeof(pte_t)) = (PTRS_PER_PMD * sizeof(pmd_t))
> which might be true for all archs, right?

I wonder if powerpc is OK on this front today.  This diagram:

	http://linux-mm.org/PageTableStructure

says that they use a 128-byte "pte" table when mapping 16M pages.  I
wonder if they bump mm->nr_ptes for these.
