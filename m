Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab3CUAxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 20:53:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab3CUAxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 20:53:21 -0400
Message-ID: <514A5997.3030802@redhat.com>
Date: Wed, 20 Mar 2013 20:51:35 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd reclaims
 at each priority
References: <1363525456-10448-1-git-send-email-mgorman@suse.de> <1363525456-10448-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1363525456-10448-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2013 09:04 AM, Mel Gorman wrote:
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
> watermark. Reclaim will will overshoot due to it not being a hard limit as
> shrink_lruvec() will ignore the sc.nr_to_reclaim at DEF_PRIORITY but it
> prevents kswapd reclaiming the world at higher priorities. The number of
> pages it reclaims is not adjusted for high-order allocations as kswapd will
> reclaim excessively if it is to balance zones for high-order allocations.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
