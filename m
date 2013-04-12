Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab3DLCq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 22:46:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab3DLCqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 22:46:52 -0400
Message-ID: <5167752C.6010703@redhat.com>
Date: Thu, 11 Apr 2013 22:45:00 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] mm: vmscan: Flatten kswapd priority loop
References: <1365505625-9460-1-git-send-email-mgorman@suse.de> <1365505625-9460-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1365505625-9460-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 07:06 AM, Mel Gorman wrote:
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

Reviewed-by: Rik van Riel <riel@redhat.com>

It looks like this patch could lead to near-infinite reclaiming when
higher-order reclaim is being done, but patch 4/10 should fix that...

-- 
All rights reversed
