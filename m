Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab3HUJbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:31:15 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41156 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3HUJbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:31:14 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 05/20] mm, hugetlb: grab a page_table_lock after page_cache_release
In-Reply-To: <1376040398-11212-6-git-send-email-iamjoonsoo.kim@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com> <1376040398-11212-6-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Wed, 21 Aug 2013 15:01:05 +0530
Message-ID: <87ppt7gzl2.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082109-3864-0000-0000-000009B0896C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> We don't need to grab a page_table_lock when we try to release a page.
> So, defer to grab a page_table_lock.
>
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>


Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index c017c52..6c8eec2 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2627,10 +2627,11 @@ retry_avoidcopy:
>  	}
>  	spin_unlock(&mm->page_table_lock);
>  	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
> -	/* Caller expects lock to be held */
> -	spin_lock(&mm->page_table_lock);
>  	page_cache_release(new_page);
>  	page_cache_release(old_page);
> +
> +	/* Caller expects lock to be held */
> +	spin_lock(&mm->page_table_lock);
>  	return 0;
>  }
>
> -- 
> 1.7.9.5

