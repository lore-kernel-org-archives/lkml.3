Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab3FDXcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:32:33 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:45806 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3FDXcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 19:32:31 -0400
X-AuditID: 9c93017e-b7bd9ae000006882-db-51ae790dad6f
Date: Wed, 5 Jun 2013 08:32:29 +0900
From: Minchan Kim <minchan@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, tim.c.chen@linux.intel.com
Subject: Re: [v5][PATCH 5/6] mm: vmscan: batch shrink_page_list() locking
 operations
Message-ID: <20130604233229.GB31006@blaptop>
References: <20130603200202.7F5FDE07@viggo.jf.intel.com>
 <20130603200208.6F71D31F@viggo.jf.intel.com>
 <20130604050103.GC14719@blaptop>
 <20130604060224.GE14719@blaptop>
 <51AE07CE.9040304@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AE07CE.9040304@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 08:29:18AM -0700, Dave Hansen wrote:
> On 06/03/2013 11:02 PM, Minchan Kim wrote:
> >> > Why do we need new lru list instead of using @free_pages?
> > I got your point that @free_pages could have freed page by
> > put_page_testzero of shrink_page_list and they don't have
> > valid mapping so __remove_mapping_batch's mapping_release_page
> > would access NULL pointer.
> > 
> > I think it would be better to mention it in comment. :(
> > Otherwise, I suggest we can declare another new LIST_HEAD to
> > accumulate pages freed by put_page_testzero in shrink_page_list
> > so __remove_mapping_batch don't have to declare temporal LRU list
> > and can remove unnecessary list_move operation.
> 
> If I respin them again, I'll add a comment.

Thanks. it's enough for me.

> 
> I guess we could splice the whole list over at once instead of moving
> the pages individually.  But, what are we trying to optimize here?
> Saving a list_head worth of space on the stack?

Never mind. At first, I thought we can simply use @free_pages instead of
redundant new LRU list and it's *minor*. That's why I already gave
my Reviewed-by. But you woke up my brain so I realized it so I don't have
a concern any more about your patch.

Thanks.
-- 
Kind regards,
Minchan Kim
