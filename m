Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab3ISIdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:33:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab3ISIdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:33:41 -0400
Date: Thu, 19 Sep 2013 10:33:29 +0200
From: Petr Holasek <pholasek@redhat.com>
To: Jianguo Wu <wujianguo@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/ksm: return NULL when doesn't get mergeable page
Message-ID: <20130919083329.GA1620@thinkpad-work.brq.redhat.com>
References: <5236FC88.6050409@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5236FC88.6050409@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013, Jianguo Wu wrote:
> In get_mergeable_page() local variable page is not initialized,
> it may hold a garbage value, when find_mergeable_vma() return NULL,
> get_mergeable_page() may return a garbage value to the caller.
> 
> So initialize page as NULL.
> 
> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
> ---
>  mm/ksm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index b6afe0c..87efbae 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -460,7 +460,7 @@ static struct page *get_mergeable_page(struct rmap_item *rmap_item)
>  	struct mm_struct *mm = rmap_item->mm;
>  	unsigned long addr = rmap_item->address;
>  	struct vm_area_struct *vma;
> -	struct page *page;
> +	struct page *page = NULL;
>  
>  	down_read(&mm->mmap_sem);
>  	vma = find_mergeable_vma(mm, addr);
> -- 
> 1.7.1
> 

When find_mergeable_vma returned NULL, NULL is assigned to page in "out"
statement.
