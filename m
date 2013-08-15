Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab3HONmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:42:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821Ab3HONmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:42:14 -0400
Date: Thu, 15 Aug 2013 14:42:09 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan@kernel.org>
Cc: Xishi Qiu <qiuxishi@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        riel@redhat.com, aquini@redhat.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: skip the page buddy block instead of one page
Message-ID: <20130815134209.GW2296@suse.de>
References: <20130814155205.GA2706@gmail.com>
 <20130814161642.GM2296@suse.de>
 <20130814163921.GC2706@gmail.com>
 <20130814180012.GO2296@suse.de>
 <520C3DD2.8010905@huawei.com>
 <20130815024427.GA2718@gmail.com>
 <520C4EFF.8040305@huawei.com>
 <20130815041736.GA2592@gmail.com>
 <20130815113019.GV2296@suse.de>
 <20130815131935.GA8437@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130815131935.GA8437@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 10:19:35PM +0900, Minchan Kim wrote:
> > 
> > Why? We're looking for pages to migrate. If the page is free and at the
> > maximum order then there is no point searching in the middle of a free
> > page.
> 
> isolate_migratepages_range API works with [low_pfn, end_pfn)
> and we can't guarantee page_order in normal compaction path
> so I'd like to limit the skipping by end_pfn conservatively.
> 

Fine

s/MAX_ORDER_NR_PAGES/pageblock_nr_pages/

and take the min of it and

low_pfn = min(low_pfn, end_pfn - 1)

-- 
Mel Gorman
SUSE Labs
