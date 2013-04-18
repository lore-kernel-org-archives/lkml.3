Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967497Ab3DRPDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:03:00 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:43348 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966367Ab3DRPC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:02:58 -0400
Date: Thu, 18 Apr 2013 08:02:02 -0700
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        dormando <dormando@rydia.net>, Michal Hocko <mhocko@suse.cz>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] mm: vmscan: Flatten kswapd priority loop
Message-ID: <20130418150202.GE2018@cmpxchg.org>
References: <1365710278-6807-1-git-send-email-mgorman@suse.de>
 <1365710278-6807-4-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365710278-6807-4-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 08:57:51PM +0100, Mel Gorman wrote:
> kswapd stops raising the scanning priority when at least SWAP_CLUSTER_MAX
> pages have been reclaimed or the pgdat is considered balanced. It then
> rechecks if it needs to restart at DEF_PRIORITY and whether high-order
> reclaim needs to be reset. This is not wrong per-se but it is confusing
> to follow and forcing kswapd to stay at DEF_PRIORITY may require several
> restarts before it has scanned enough pages to meet the high watermark even
> at 100% efficiency. This patch irons out the logic a bit by controlling
> when priority is raised and removing the "goto loop_again".
> 
> This patch has kswapd raise the scanning priority until it is scanning
> enough pages that it could meet the high watermark in one shrink of the
> LRU lists if it is able to reclaim at 100% efficiency. It will not raise
> the scanning prioirty higher unless it is failing to reclaim any pages.
> 
> To avoid infinite looping for high-order allocation requests kswapd will
> not reclaim for high-order allocations when it has reclaimed at least
> twice the number of pages as the allocation request.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
