Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935760Ab3DJGsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:48:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37081 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3DJGse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:48:34 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <51650B1F.1060607@jp.fujitsu.com>
Date: Wed, 10 Apr 2013 15:47:59 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd reclaims
 at each priority
References: <1365505625-9460-1-git-send-email-mgorman@suse.de> <1365505625-9460-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1365505625-9460-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/09 20:06), Mel Gorman wrote:
> The number of pages kswapd can reclaim is bound by the number of pages it
> scans which is related to the size of the zone and the scanning priority. In
> many cases the priority remains low because it's reset every SWAP_CLUSTER_MAX
> reclaimed pages but in the event kswapd scans a large number of pages it
> cannot reclaim, it will raise the priority and potentially discard a large
> percentage of the zone as sc->nr_to_reclaim is ULONG_MAX. The user-visible
> effect is a reclaim "spike" where a large percentage of memory is suddenly
> freed. It would be bad enough if this was just unused memory but because
> of how anon/file pages are balanced it is possible that applications get
> pushed to swap unnecessarily.
> 
> This patch limits the number of pages kswapd will reclaim to the high
> watermark. Reclaim will still overshoot due to it not being a hard limit as
> shrink_lruvec() will ignore the sc.nr_to_reclaim at DEF_PRIORITY but it
> prevents kswapd reclaiming the world at higher priorities. The number of
> pages it reclaims is not adjusted for high-order allocations as kswapd will
> reclaim excessively if it is to balance zones for high-order allocations.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



