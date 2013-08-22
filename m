Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab3HVGx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 02:53:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55994 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3HVGx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 02:53:26 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-13-5215b5653515
Date: Thu, 22 Aug 2013 15:53:33 +0900
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
Subject: Re: [PATCH v2 07/20] mm, hugetlb: unify region structure handling
Message-ID: <20130822065333.GC13415@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1376040398-11212-8-git-send-email-iamjoonsoo.kim@lge.com>
 <87bo4rgx6m.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo4rgx6m.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 03:52:57PM +0530, Aneesh Kumar K.V wrote:
> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
> 
> > Currently, to track a reserved and allocated region, we use two different
> > ways for MAP_SHARED and MAP_PRIVATE. For MAP_SHARED, we use
> > address_mapping's private_list and, for MAP_PRIVATE, we use a resv_map.
> > Now, we are preparing to change a coarse grained lock which protect
> > a region structure to fine grained lock, and this difference hinder it.
> > So, before changing it, unify region structure handling.
> >
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> > index a3f868a..9bf2c4a 100644
> > --- a/fs/hugetlbfs/inode.c
> > +++ b/fs/hugetlbfs/inode.c
> > @@ -366,7 +366,12 @@ static void truncate_hugepages(struct inode *inode, loff_t lstart)
> >
> >  static void hugetlbfs_evict_inode(struct inode *inode)
> >  {
> > +	struct resv_map *resv_map;
> > +
> >  	truncate_hugepages(inode, 0);
> > +	resv_map = (struct resv_map *)inode->i_mapping->private_data;
> 
> can you add a comment around saying root inode doesn't have resv_map. 

Okay! I will do it.

Thanks.
