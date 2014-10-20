Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaJTP1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:27:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbaJTP1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:27:18 -0400
Message-ID: <544529C0.5080205@redhat.com>
Date: Mon, 20 Oct 2014 11:26:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 4/5] mm, compaction: always update cached scanner positions
References: <1412696019-21761-1-git-send-email-vbabka@suse.cz> <1412696019-21761-5-git-send-email-vbabka@suse.cz>
In-Reply-To: <1412696019-21761-5-git-send-email-vbabka@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 11:33 AM, Vlastimil Babka wrote:
> Compaction caches the migration and free scanner positions between compaction
> invocations, so that the whole zone gets eventually scanned and there is no
> bias towards the initial scanner positions at the beginning/end of the zone.
>
> The cached positions are continuously updated as scanners progress and the
> updating stops as soon as a page is successfully isolated. The reasoning
> behind this is that a pageblock where isolation succeeded is likely to succeed
> again in near future and it should be worth revisiting it.
>
> However, the downside is that potentially many pages are rescanned without
> successful isolation. At worst, there might be a page where isolation from LRU
> succeeds but migration fails (potentially always). So upon encountering this
> page, cached position would always stop being updated for no good reason.
> It might have been useful to let such page be rescanned with sync compaction
> after async one failed, but this is now handled by caching scanner position
> for async and sync mode separately since commit 35979ef33931 ("mm, compaction:
> add per-zone migration pfn cache for async compaction").
>
> After this patch, cached positions are updated unconditionally. In
> stress-highalloc benchmark, this has decreased the numbers of scanned pages
> by few percent, without affecting allocation success rates.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: Rik van Riel <riel@redhat.com>

