Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3HVHZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:25:50 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61289 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab3HVHZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:25:49 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-80-5215bcfb96cc
Date: Thu, 22 Aug 2013 16:25:55 +0900
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
Subject: Re: [PATCH v2 11/20] mm, hugetlb: make vma_resv_map() works for all
 mapping type
Message-ID: <20130822072555.GG13415@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1376040398-11212-12-git-send-email-iamjoonsoo.kim@lge.com>
 <878uzvgwi7.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878uzvgwi7.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 04:07:36PM +0530, Aneesh Kumar K.V wrote:
> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
> 
> > Util now, we get a resv_map by two ways according to each mapping type.
> > This makes code dirty and unreadable. So unfiying it.
> >
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 869c3e0..e6c0c77 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -421,13 +421,24 @@ void resv_map_release(struct kref *ref)
> >  	kfree(resv_map);
> >  }
> >
> > +static inline struct resv_map *inode_resv_map(struct inode *inode)
> > +{
> > +	return inode->i_mapping->private_data;
> > +}
> 
> it would be nice to get have another function that will return resv_map
> only if we have HPAGE_RESV_OWNER. So that we could use that in
> hugetlb_vm_op_open/close. ? Otherwise 

It is answered in previous reply.

> 
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Thanks.

