Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab3GVQVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:21:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691Ab3GVQLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:11:17 -0400
Date: Mon, 22 Jul 2013 18:11:11 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v2 02/10] mm, hugetlb: remove err label in
 dequeue_huge_page_vma()
Message-ID: <20130722161111.GI24400@dhcp22.suse.cz>
References: <1374482191-3500-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1374482191-3500-3-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374482191-3500-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 22-07-13 17:36:23, Joonsoo Kim wrote:
> This label is not needed now, because there is no error handling
> except returing NULL.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index fc4988c..d87f70b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -546,11 +546,11 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
>  	 */
>  	if (!vma_has_reserves(vma) &&
>  			h->free_huge_pages - h->resv_huge_pages == 0)
> -		goto err;
> +		return NULL;
>  
>  	/* If reserves cannot be used, ensure enough pages are in the pool */
>  	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
> -		goto err;
> +		return NULL;
>  
>  retry_cpuset:
>  	cpuset_mems_cookie = get_mems_allowed();
> @@ -573,9 +573,6 @@ retry_cpuset:
>  	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
>  		goto retry_cpuset;
>  	return page;
> -
> -err:
> -	return NULL;

This doesn't give us anything IMO. It is a matter of taste but if there
is no cleanup I would prefer no err label.
-- 
Michal Hocko
SUSE Labs
