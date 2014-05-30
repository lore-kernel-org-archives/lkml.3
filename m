Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaE3Bx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:53:29 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59792 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaE3Bx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:53:28 -0400
Date: Thu, 29 May 2014 18:52:11 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Michael Ellerman <mpe@ellerman.id.au>
cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, benh@kernel.crashing.org,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, trinity@vger.kernel.org
Subject: Re: [PATCH] hugetlb: restrict hugepage_migration_support() to x86_64
 (Re: BUG at mm/memory.c:1489!)
In-Reply-To: <1401413716.29324.2.camel@concordia>
Message-ID: <alpine.LSU.2.11.1405291851001.27151@eggly.anvils>
References: <1401265922.3355.4.camel@concordia> <alpine.LSU.2.11.1405281712310.7156@eggly.anvils> <1401353983.4930.15.camel@concordia> <1401388474-mqnis5cp@n-horiguchi@ah.jp.nec.com> <1401413716.29324.2.camel@concordia>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014, Michael Ellerman wrote:
> 
> diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
> index 3c1b968..f230a97 100644
> --- a/include/linux/mempolicy.h
> +++ b/include/linux/mempolicy.h
> @@ -175,6 +175,12 @@ static inline int vma_migratable(struct vm_area_struct *vma)
>  {
>         if (vma->vm_flags & (VM_IO | VM_PFNMAP))
>                 return 0;
> +
> +#ifndef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
> +       if (vma->vm_flags & VM_HUGETLB)
> +               return 0;
> +#endif
> +
>         /*
>          * Migration allocates pages in the highest zone. If we cannot
>          * do so then migration (at least from node to node) is not

That's right, thanks.

> 
> 
> Which seems to be what Hugh was referring to in his mail - correct me if I'm
> wrong Hugh.
> 
> With your patch and the above hunk I can run trinity happily for a while,
> whereas without it crashes almost immediately.
> 
> So with the above hunk you can add my tested-by.
> 
> cheers
