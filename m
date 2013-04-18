Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967086Ab3DRPMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:12:08 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:43368 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966458Ab3DRPMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:12:07 -0400
Date: Thu, 18 Apr 2013 08:11:06 -0700
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        dormando <dormando@rydia.net>, Michal Hocko <mhocko@suse.cz>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/10] mm: vmscan: Do not allow kswapd to scan at maximum
 priority
Message-ID: <20130418151106.GG2018@cmpxchg.org>
References: <1365710278-6807-1-git-send-email-mgorman@suse.de>
 <1365710278-6807-6-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365710278-6807-6-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 08:57:53PM +0100, Mel Gorman wrote:
> Page reclaim at priority 0 will scan the entire LRU as priority 0 is
> considered to be a near OOM condition. Kswapd can reach priority 0 quite
> easily if it is encountering a large number of pages it cannot reclaim
> such as pages under writeback. When this happens, kswapd reclaims very
> aggressively even though there may be no real risk of allocation failure
> or OOM.
> 
> This patch prevents kswapd reaching priority 0 and trying to reclaim
> the world. Direct reclaimers will still reach priority 0 in the event
> of an OOM situation.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
