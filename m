Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3DLCrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 22:47:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab3DLCrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 22:47:47 -0400
Message-ID: <51677599.6030000@redhat.com>
Date: Thu, 11 Apr 2013 22:46:49 -0400
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
Subject: Re: [PATCH 04/10] mm: vmscan: Decide whether to compact the pgdat
 based on reclaim progress
References: <1365505625-9460-1-git-send-email-mgorman@suse.de> <1365505625-9460-5-git-send-email-mgorman@suse.de>
In-Reply-To: <1365505625-9460-5-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 07:06 AM, Mel Gorman wrote:
> In the past, kswapd makes a decision on whether to compact memory after the
> pgdat was considered balanced. This more or less worked but it is late to
> make such a decision and does not fit well now that kswapd makes a decision
> whether to exit the zone scanning loop depending on reclaim progress.
>
> This patch will compact a pgdat if at least the requested number of pages
> were reclaimed from unbalanced zones for a given priority. If any zone is
> currently balanced, kswapd will not call compaction as it is expected the
> necessary pages are already available.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

This has the potential to increase kswapd cpu use, but probably at
the benefit of making reclaim run a little more smoothly. It should
help that compaction is only called when enough pages have been
freed.

-- 
All rights reversed
