Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990AbbAFVoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:44:21 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50514 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536AbbAFVoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:44:20 -0500
Date: Tue, 6 Jan 2015 22:44:16 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, David Rientjes <rientjes@google.com>,
        Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH V4 1/4] mm: set page->pfmemalloc in prep_new_page()
Message-ID: <20150106214416.GA8391@dhcp22.suse.cz>
References: <1420478263-25207-1-git-send-email-vbabka@suse.cz>
 <1420478263-25207-2-git-send-email-vbabka@suse.cz>
 <20150106143008.GA20860@dhcp22.suse.cz>
 <54AC4F5F.90306@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AC4F5F.90306@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 06-01-15 22:10:55, Vlastimil Babka wrote:
> On 01/06/2015 03:30 PM, Michal Hocko wrote:
[...]
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 1bb65e6f48dd..1682d766cb8e 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2175,10 +2175,11 @@ zonelist_scan:
> >  		}
> >  
> >  try_this_zone:
> > -		page = buffered_rmqueue(preferred_zone, zone, order,
> > +		do {
> > +			page = buffered_rmqueue(preferred_zone, zone, order,
> >  						gfp_mask, migratetype);
> > -		if (page)
> > -			break;
> > +		} while (page && prep_new_page(page, order, gfp_mask,
> > +					       alloc_flags));
> 
> Hm but here we wouldn't return page on success.

Right.

> I wonder if you overlooked the return, hence your "not breaking out of
> the loop" remark?

This was merely to show the intention. Sorry for not being clear enough.

-- 
Michal Hocko
SUSE Labs
