Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3HZNiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:38:21 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:53383 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab3HZNiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:38:20 -0400
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
Subject: Re: [PATCH v2 15/20] mm, hugetlb: remove a check for return value of alloc_huge_page()
In-Reply-To: <1376040398-11212-16-git-send-email-iamjoonsoo.kim@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com> <1376040398-11212-16-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 26 Aug 2013 19:08:09 +0530
Message-ID: <87sixwd132.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082613-7014-0000-0000-00000383B869
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> Now, alloc_huge_page() only return -ENOSPEC if failed.
> So, we don't worry about other return value.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index bc666cf..24de2ca 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2544,7 +2544,6 @@ retry_avoidcopy:
>  	new_page = alloc_huge_page(vma, address, use_reserve);
>
>  	if (IS_ERR(new_page)) {
> -		long err = PTR_ERR(new_page);
>  		page_cache_release(old_page);
>
>  		/*
> @@ -2573,10 +2572,7 @@ retry_avoidcopy:
>
>  		/* Caller expects lock to be held */
>  		spin_lock(&mm->page_table_lock);
> -		if (err == -ENOMEM)
> -			return VM_FAULT_OOM;
> -		else
> -			return VM_FAULT_SIGBUS;
> +		return VM_FAULT_SIGBUS;
>  	}
>
>  	/*
> @@ -2707,11 +2703,7 @@ retry:
>
>  		page = alloc_huge_page(vma, address, use_reserve);
>  		if (IS_ERR(page)) {
> -			ret = PTR_ERR(page);
> -			if (ret == -ENOMEM)
> -				ret = VM_FAULT_OOM;
> -			else
> -				ret = VM_FAULT_SIGBUS;
> +			ret = VM_FAULT_SIGBUS;
>  			goto out;
>  		}
>  		clear_huge_page(page, address, pages_per_huge_page(h));
> -- 
> 1.7.9.5

