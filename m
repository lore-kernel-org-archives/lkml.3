Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab3KUOi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:38:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab3KUOiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:38:24 -0500
Date: Thu, 21 Nov 2013 09:38:17 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Message-ID: <1385044697-rn5og2ir-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1385038810-15513-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1385038810-15513-1-git-send-email-kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] mm: place page->pmd_huge_pte to right union
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1385038810-15513-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 03:00:10PM +0200, Kirill A. Shutemov wrote:
> I don't know what went wrong, mis-merge or something, but ->pmd_huge_pte
> placed in wrong union within struct page.
> 
> In original patch[1] it's placed to union with ->lru and ->slab, but in
> commit e009bb30c8df it's in union with ->index and ->freelist.
> 
> That union seems also unused for pages with table tables and safe to
> re-use, but it's not what I've tested.
> 
> Let's move it to original place. It fixes indentation at least. :)
> 
> [1] https://lkml.org/lkml/2013/10/7/288
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  include/linux/mm_types.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 10f5a7272b80..011eb85d7b0f 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -65,9 +65,6 @@ struct page {
>  						 * this page is only used to
>  						 * free other pages.
>  						 */
> -#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
> -		pgtable_t pmd_huge_pte; /* protected by page->ptl */
> -#endif
>  		};
>  
>  		union {
> @@ -135,6 +132,9 @@ struct page {
>  
>  		struct list_head list;	/* slobs list of pages */
>  		struct slab *slab_page; /* slab fields */
> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
> +		pgtable_t pmd_huge_pte; /* protected by page->ptl */
> +#endif
>  	};
>  
>  	/* Remainder is not double word aligned */
> -- 
> 1.8.4.3
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
