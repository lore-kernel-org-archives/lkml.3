Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3FDEln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 00:41:43 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50406 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3FDElm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 00:41:42 -0400
X-AuditID: 9c930179-b7c07ae000000e33-db-51ad7003b85e
Date: Tue, 4 Jun 2013 13:41:39 +0900
From: Minchan Kim <minchan@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, tim.c.chen@linux.intel.com
Subject: Re: [v4][PATCH 1/6] mm: swap: defer clearing of page_private() for
 swap cache pages
Message-ID: <20130604044139.GB14719@blaptop>
References: <20130531183855.44DDF928@viggo.jf.intel.com>
 <20130531183856.1D7D75AD@viggo.jf.intel.com>
 <20130603054048.GA27858@blaptop>
 <51ACADCD.70904@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ACADCD.70904@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 07:53:01AM -0700, Dave Hansen wrote:
> On 06/02/2013 10:40 PM, Minchan Kim wrote:
> >> > diff -puN mm/vmscan.c~__delete_from_swap_cache-dont-clear-page-private mm/vmscan.c
> >> > --- linux.git/mm/vmscan.c~__delete_from_swap_cache-dont-clear-page-private	2013-05-30 16:07:50.632079492 -0700
> >> > +++ linux.git-davehans/mm/vmscan.c	2013-05-30 16:07:50.637079712 -0700
> >> > @@ -494,6 +494,8 @@ static int __remove_mapping(struct addre
> >> >  		__delete_from_swap_cache(page);
> >> >  		spin_unlock_irq(&mapping->tree_lock);
> >> >  		swapcache_free(swap, page);
> >> > +		set_page_private(page, 0);
> >> > +		ClearPageSwapCache(page);
> > It it worth to support non-atomic version of ClearPageSwapCache?
> 
> Just for this, probably not.
> 
> It does look like a site where it would be theoretically safe to use
> non-atomic flag operations since the page is on a one-way trip to the
> allocator at this point and the __clear_page_locked() now happens _just_
> after this code.

True.

> 
> But, personally, I'm happy to leave it as-is.  The atomic vs. non-atomic
> flags look to me like a micro-optimization that we should use when we
> _know_ there will be some tangible benefit.  Otherwise, they're just
> something extra for developers to trip over and cause very subtle bugs.

I just asked it because when I read the description of patchset, I felt
you were very sensitive to the atomic operation on many CPU system with
several sockets. Anyway, if you don't want it, I don't mind it, either.

-- 
Kind regards,
Minchan Kim
