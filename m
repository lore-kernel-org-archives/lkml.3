Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab3KEXnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:43:46 -0500
Received: from [204.155.152.216] ([204.155.152.216]:45645 "EHLO shutemov.name"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755606Ab3KEXnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:43:45 -0500
Date: Wed, 6 Nov 2013 00:47:04 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org, peterz@infradead.org, mingo@redhat.com,
        fengguang.wu@intel.com, kirill.shutemov@linux.intel.com
Subject: Re: + mm-create-a-separate-slab-for-page-ptl-allocation.patch added
 to -mm tree
Message-ID: <20131105224704.GD20167@shutemov.name>
References: <527978e1.gJq89ytISidyDor2%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527978e1.gJq89ytISidyDor2%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 03:01:53PM -0800, akpm@linux-foundation.org wrote:
> diff -puN mm/memory.c~mm-create-a-separate-slab-for-page-ptl-allocation mm/memory.c
> --- a/mm/memory.c~mm-create-a-separate-slab-for-page-ptl-allocation
> +++ a/mm/memory.c
> @@ -4272,11 +4272,19 @@ void copy_user_huge_page(struct page *ds
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
>  
>  #if USE_SPLIT_PTE_PTLOCKS
> +struct kmem_cache *page_ptl_cachep;

Just noticed that it should be static. Could you fix it?
Sorry.

-- 
 Kirill A. Shutemov
