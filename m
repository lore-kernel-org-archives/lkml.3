Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaAGR1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:27:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42207 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaAGR1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:27:09 -0500
Date: Tue, 7 Jan 2014 17:26:59 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.10 075/129] mm/mempolicy: correct putback method for
 isolate pages if failed
Message-ID: <20140107172659.GC4383@hercules>
References: <20140106223859.589799655@linuxfoundation.org>
 <20140106223901.757315615@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106223901.757315615@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 02:38:24PM -0800, Greg Kroah-Hartman wrote:
> 3.10-stable review patch.  If anyone has any objections, please let me know.

This commit was tagged for 3.12 stable only, so you may want to drop it.

Cheers,
--
Luis


> ------------------
> 
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> commit b0e5fd7359f1ce8db4ccb862b3aa80d2f2cbf4d0 upstream.
> 
> queue_pages_range() isolates hugetlbfs pages and putback_lru_pages()
> can't handle these.  We should change it to putback_movable_pages().
> 
> Naoya said that it is worth going into stable, because it can break
> in-use hugepage list.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Acked-by: Rafael Aquini <aquini@redhat.com>
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  mm/mempolicy.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1271,7 +1271,7 @@ static long do_mbind(unsigned long start
>  		if (nr_failed && (flags & MPOL_MF_STRICT))
>  			err = -EIO;
>  	} else
> -		putback_lru_pages(&pagelist);
> +		putback_movable_pages(&pagelist);
>  
>  	up_write(&mm->mmap_sem);
>   mpol_out:
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
