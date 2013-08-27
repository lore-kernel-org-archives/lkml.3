Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3H0H6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 03:58:15 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54045 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab3H0H6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 03:58:12 -0400
X-AuditID: 9c93016f-b7cf0ae00000518f-22-521c5c13058e
Date: Tue, 27 Aug 2013 16:58:38 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v2 14/20] mm, hugetlb: call vma_needs_reservation before
 entering alloc_huge_page()
Message-ID: <20130827075838.GC6795@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1376040398-11212-15-git-send-email-iamjoonsoo.kim@lge.com>
 <87vc2sd15e.fsf@linux.vnet.ibm.com>
 <87mwo4d0p2.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwo4d0p2.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> @@ -2504,6 +2498,8 @@ static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
> >>  	struct hstate *h = hstate_vma(vma);
> >>  	struct page *old_page, *new_page;
> >>  	int outside_reserve = 0;
> >> +	long chg;
> >> +	bool use_reserve;
> >>  	unsigned long mmun_start;	/* For mmu_notifiers */
> >>  	unsigned long mmun_end;		/* For mmu_notifiers */
> >>
> >> @@ -2535,7 +2531,17 @@ retry_avoidcopy:
> >>
> >>  	/* Drop page_table_lock as buddy allocator may be called */
> >>  	spin_unlock(&mm->page_table_lock);
> >> -	new_page = alloc_huge_page(vma, address, outside_reserve);
> >> +	chg = vma_needs_reservation(h, vma, address);
> >> +	if (chg == -ENOMEM) {
> >
> > why not 
> >
> >     if (chg < 0) ?
> >
> > Should we try to unmap the page from child and avoid cow here ?. May be
> > with outside_reserve = 1 we will never have vma_needs_reservation fail.
> > Any how it would be nice to document why this error case is different
> > from alloc_huge_page error case.
> >
> 
> I guess patch  16 address this . So if we do if (chg < 0) we are good
> here.

Okay! I will change it.

> 
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Thanks.

