Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbaC0UmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 16:42:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175AbaC0UmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 16:42:08 -0400
Message-ID: <53348D09.3060802@redhat.com>
Date: Thu, 27 Mar 2014 16:41:45 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>
CC: Suleiman Souhlal <suleiman@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rafael Aquini <aquini@redhat.com>,
        Michal Hocko <mhocko@suse.cz>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Seth Jennings <sjennings@variantweb.net>, Bob Liu <bob.liu@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Luigi Semenzato <semenzato@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Only force scan in reclaim when none of the LRUs
 are big enough.
References: <alpine.LSU.2.11.1403151957160.21388@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1403151957160.21388@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2014 11:36 PM, Hugh Dickins wrote:
> From: Suleiman Souhlal <suleiman@google.com>
>
> Prior to this change, we would decide whether to force scan a LRU
> during reclaim if that LRU itself was too small for the current
> priority. However, this can lead to the file LRU getting force
> scanned even if there are a lot of anonymous pages we can reclaim,
> leading to hot file pages getting needlessly reclaimed.
>
> To address this, we instead only force scan when none of the
> reclaimable LRUs are big enough.
>
> Gives huge improvements with zswap. For example, when doing -j20
> kernel build in a 500MB container with zswap enabled, runtime (in
> seconds) is greatly reduced:
>
> x without this change
> + with this change
>      N           Min           Max        Median           Avg        Stddev
> x   5       700.997       790.076       763.928        754.05      39.59493
> +   5       141.634       197.899       155.706         161.9     21.270224
> Difference at 95.0% confidence
>          -592.15 +/- 46.3521
>          -78.5293% +/- 6.14709%
>          (Student's t, pooled s = 31.7819)
>
> Should also give some improvements in regular (non-zswap) swap cases.
>
> Yes, hughd found significant speedup using regular swap, with several
> memcgs under pressure; and it should also be effective in the non-memcg
> case, whenever one or another zone LRU is forced too small.
>
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Rik van Riel <riel@redhat.com>

