Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab3LEOjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:39:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab3LEOjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:39:48 -0500
Date: Thu, 05 Dec 2013 09:39:30 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Jianguo Wu <wujianguo@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, qiuxishi <qiuxishi@huawei.com>
Message-ID: <1386254370-ui1ehq60-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <52A03EE4.6030609@huawei.com>
References: <52A03EE4.6030609@huawei.com>
Subject: Re: [PATCH] mm: do_mincore() cleanup
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <52A03EE4.6030609@huawei.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 04:52:52PM +0800, Jianguo Wu wrote:
> Two cleanups:
> 1. remove redundant codes for hugetlb pages.
> 2. end = pmd_addr_end(addr, end) restricts [addr, end) within PMD_SIZE,
>    this may increase do_mincore() calls, remove it.
> 
> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Thanks!

Naoya

> ---
>  mm/mincore.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/mincore.c b/mm/mincore.c
> index da2be56..1016233 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -225,13 +225,6 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
>  
>  	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
>  
> -	if (is_vm_hugetlb_page(vma)) {
> -		mincore_hugetlb_page_range(vma, addr, end, vec);
> -		return (end - addr) >> PAGE_SHIFT;
> -	}
> -
> -	end = pmd_addr_end(addr, end);
> -
>  	if (is_vm_hugetlb_page(vma))
>  		mincore_hugetlb_page_range(vma, addr, end, vec);
>  	else
> -- 
> 1.7.1
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
