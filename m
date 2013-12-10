Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3LJUfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:35:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab3LJUfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:35:39 -0500
Date: Tue, 10 Dec 2013 15:35:05 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Message-ID: <1386707705-w5s8rtqp-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1386667175-19952-7-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386667175-19952-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1386667175-19952-7-git-send-email-liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 07/12] sched/numa: fix set cpupid on page migration
 twice against normal page
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1386667175-19952-7-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 05:19:30PM +0800, Wanpeng Li wrote:
> commit 7851a45cd3 (mm: numa: Copy cpupid on page migration) copy over
> the cpupid at page migration time, there is unnecessary to set it again
> in function alloc_misplaced_dst_page, this patch fix it.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  mm/migrate.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index b1b6663..508cde4 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1557,8 +1557,6 @@ static struct page *alloc_misplaced_dst_page(struct page *page,
>  					  __GFP_NOMEMALLOC | __GFP_NORETRY |
>  					  __GFP_NOWARN) &
>  					 ~GFP_IOFS, 0);
> -	if (newpage)
> -		page_cpupid_xchg_last(newpage, page_cpupid_last(page));
>  
>  	return newpage;
>  }
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
