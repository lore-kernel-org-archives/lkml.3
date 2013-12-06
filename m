Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab3LFSoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:44:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab3LFSoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:44:07 -0500
Date: Fri, 06 Dec 2013 13:43:57 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Message-ID: <1386355437-ly5a1ny8-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1386319310-28016-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1386319310-28016-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1386319310-28016-2-git-send-email-iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 2/4] mm/mempolicy: correct putback method for isolate
 pages if failed
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1386319310-28016-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

On Fri, Dec 06, 2013 at 05:41:48PM +0900, Joonsoo Kim wrote:
> queue_pages_range() isolates hugetlbfs pages and putback_lru_pages() can't
> handle these. We should change it to putback_movable_pages().
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Nice fix, thanks.
I think that this patch is worth going into -stable 3.12,
because it can break in-use hugepage list.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index eca4a31..6d04d37 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1318,7 +1318,7 @@ static long do_mbind(unsigned long start, unsigned long len,
>  		if (nr_failed && (flags & MPOL_MF_STRICT))
>  			err = -EIO;
>  	} else
> -		putback_lru_pages(&pagelist);
> +		putback_movable_pages(&pagelist);
>  
>  	up_write(&mm->mmap_sem);
>   mpol_out:
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
