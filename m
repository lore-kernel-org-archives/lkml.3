Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbaCLHGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 03:06:07 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:47692 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560AbaCLHGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 03:06:04 -0400
X-AuditID: 9c93017e-b7cf9ae000004b4b-45-5320075aa062
Date: Wed, 12 Mar 2014 16:06:21 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jungsoo Son <jungsoo.son@lge.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH] page owners: correct page->order when to free page
Message-ID: <20140312070621.GI17828@bbox>
References: <1394607486-31493-1-git-send-email-jungsoo.son@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394607486-31493-1-git-send-email-jungsoo.son@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 03:58:06PM +0900, Jungsoo Son wrote:
> When I use PAGE_OWNER in mmotm tree, I found a problem that mismatches
> the number of allocated pages. When I investigate, the problem is that
> set_page_order is called for only a head page if freed page is merged to
> a higher order page in the buddy allocator so tail pages of the higher
> order page couldn't be reset to page->order = -1.
> 
> It means when we do 'cat /proc/page-owner', it could show wrong
> information.

We could make read_page_owner more smart so that it could check
PageBuddy at head page of high order page and skip tail pages but
it needs zone->lock which is already heavy contention lock.
Additionally, it could make wrong information on pcp pages, too.
So, I like this simple approach.

> 
> So page->order should be set to -1 for all the tail pages as well as the
> first page before buddy allocator merges them.
> 
> This patch is for clearing page->order of all the tail pages in
> free_pages_prepare() when to free page.
> 
> Signed-off-by: Jungsoo Son <jungsoo.son@lge.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Minchan Kim <minchan@kernel.org>

Thanks.

-- 
Kind regards,
Minchan Kim
