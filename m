Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbaFWUvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:51:49 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60504 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbaFWUvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:51:47 -0400
Date: Mon, 23 Jun 2014 13:51:43 -0700
From: Patrick McLean <chutzpah@gentoo.org>
To: tip-bot for Rik van Riel <tipbot@zytor.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        kirill.shutemov@linux.intel.com, peterz@infradead.org,
        hannes@cmpxchg.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com,
        akpm@linux-foundation.org, mgorman@suse.de, sunil.k.pandey@intel.com,
        tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: [tip:sched/core] mm/numa: Remove BUG_ON() in
 __handle_mm_fault()
Message-ID: <20140623135143.0b2f8646@gentoo.org>
In-Reply-To: <tip-107437febd495a50e2cd09c81bbaa84d30e57b07@git.kernel.org>
References: <20140429153615.2d72098e@annuminas.surriel.com>
	<tip-107437febd495a50e2cd09c81bbaa84d30e57b07@git.kernel.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014 03:43:19 -0700

Could this please be included in 3.14 and 3.15 stable as well.

tip-bot for Rik van Riel <tipbot@zytor.com> wrote:

> Commit-ID:  107437febd495a50e2cd09c81bbaa84d30e57b07
> Gitweb:
> http://git.kernel.org/tip/107437febd495a50e2cd09c81bbaa84d30e57b07
> Author:     Rik van Riel <riel@redhat.com> AuthorDate: Tue, 29 Apr
> 2014 15:36:15 -0400 Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 7 May 2014 13:33:48 +0200
> 
> mm/numa: Remove BUG_ON() in __handle_mm_fault()
> 
> Changing PTEs and PMDs to pte_numa & pmd_numa is done with the
> mmap_sem held for reading, which means a pmd can be instantiated
> and turned into a numa one while __handle_mm_fault() is examining
> the value of old_pmd.
> 
> If that happens, __handle_mm_fault() should just return and let
> the page fault retry, instead of throwing an oops. This is
> handled by the test for pmd_trans_huge(*pmd) below.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Reported-by: Sunil Pandey <sunil.k.pandey@intel.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: linux-mm@kvack.org
> Cc: lwoodman@redhat.com
> Cc: dave.hansen@intel.com
> Link:
> http://lkml.kernel.org/r/20140429153615.2d72098e@annuminas.surriel.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org> ---
>  mm/memory.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index d0f0bef..9c2dc65 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3900,9 +3900,6 @@ static int __handle_mm_fault(struct mm_struct
> *mm, struct vm_area_struct *vma, }
>  	}
>  
> -	/* THP should already have been handled */
> -	BUG_ON(pmd_numa(*pmd));
> -
>  	/*
>  	 * Use __pte_alloc instead of pte_alloc_map, because we can't
>  	 * run pte_offset_map on the pmd, if an huge pmd could
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

