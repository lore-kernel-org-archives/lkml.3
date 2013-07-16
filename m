Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab3GPBmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 21:42:14 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64686 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab3GPBmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 21:42:13 -0400
X-AuditID: 9c93016f-b7b50ae0000021a9-fc-51e4a4f35677
Date: Tue, 16 Jul 2013 10:42:14 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] mm, hugetlb: remove redundant list_empty check in
 gather_surplus_pages()
Message-ID: <20130716014214.GF2430@lge.com>
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1373881967-16153-6-git-send-email-iamjoonsoo.kim@lge.com>
 <87vc4bj3nn.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc4bj3nn.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 08:01:24PM +0530, Aneesh Kumar K.V wrote:
> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
> 
> > If list is empty, list_for_each_entry_safe() doesn't do anything.
> > So, this check is redundant. Remove it.
> >
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> 
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index a838e6b..d4a1695 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -1019,10 +1019,8 @@ free:
> >  	spin_unlock(&hugetlb_lock);
> >
> >  	/* Free unnecessary surplus pages to the buddy allocator */
> > -	if (!list_empty(&surplus_list)) {
> > -		list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
> > -			put_page(page);
> > -		}
> > +	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
> > +		put_page(page);
> >  	}
> 
> You can now remove '{' 

Okay.
I will do that.

Thanks.

> 
> 
> >  	spin_lock(&hugetlb_lock);
> >
> > -- 
> > 1.7.9.5
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
