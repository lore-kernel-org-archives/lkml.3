Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbaCEDQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:16:44 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:42154 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbaCEDQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:16:42 -0500
MIME-Version: 1.0
In-Reply-To: <20140227150313.3BA27E0098@blue.fi.intel.com>
References: <530F3F0A.5040304@oracle.com>
	<20140227150313.3BA27E0098@blue.fi.intel.com>
Date: Wed, 5 Mar 2014 11:16:41 +0800
Message-ID: <CAA_GA1c02iSmkmCLHFkrK4b4W+JppZ4CSMUJ-Wn1rCs-c=dV6g@mail.gmail.com>
Subject: Re: mm: kernel BUG at mm/huge_memory.c:2785!
From: Bob Liu <lliubbo@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 11:03 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Sasha Levin wrote:
>> Hi all,
>>
>> While fuzzing with trinity inside a KVM tools guest running latest -next kernel I've stumbled on the
>> following spew:
>>
>> [ 1428.146261] kernel BUG at mm/huge_memory.c:2785!
>
> Hm, interesting.
>
> It seems we either failed to split huge page on vma split or it
> materialized from under us. I don't see how it can happen:
>
>   - it seems we do the right thing with vma_adjust_trans_huge() in
>     __split_vma();
>   - we hold ->mmap_sem all the way from vm_munmap(). At least I don't see
>     a place where we could drop it;
>

Enable CONFIG_DEBUG_VM may show some useful information, at least we
can confirm weather rwsem_is_locked(&tlb->mm->mmap_sem) before
split_huge_page_pmd().

-- 
Regards,
--Bob
