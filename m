Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab3GWH1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:27:24 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52205 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3GWH1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:27:22 -0400
X-AuditID: 9c93016f-b7b50ae0000021a9-d5-51ee3058c7bf
Date: Tue, 23 Jul 2013 16:27:24 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/10] mm, hugetlb: remove err label in
 dequeue_huge_page_vma()
Message-ID: <20130723072724.GA2266@lge.com>
References: <1374482191-3500-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1374482191-3500-3-git-send-email-iamjoonsoo.kim@lge.com>
 <20130722161111.GI24400@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722161111.GI24400@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 06:11:11PM +0200, Michal Hocko wrote:
> On Mon 22-07-13 17:36:23, Joonsoo Kim wrote:
> > This label is not needed now, because there is no error handling
> > except returing NULL.
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index fc4988c..d87f70b 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -546,11 +546,11 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
> >  	 */
> >  	if (!vma_has_reserves(vma) &&
> >  			h->free_huge_pages - h->resv_huge_pages == 0)
> > -		goto err;
> > +		return NULL;
> >  
> >  	/* If reserves cannot be used, ensure enough pages are in the pool */
> >  	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
> > -		goto err;
> > +		return NULL;
> >  
> >  retry_cpuset:
> >  	cpuset_mems_cookie = get_mems_allowed();
> > @@ -573,9 +573,6 @@ retry_cpuset:
> >  	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
> >  		goto retry_cpuset;
> >  	return page;
> > -
> > -err:
> > -	return NULL;
> 
> This doesn't give us anything IMO. It is a matter of taste but if there
> is no cleanup I would prefer no err label.

Okay. If this patchset need respin, I will omit this one.

Thanks.

> -- 
> Michal Hocko
> SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
