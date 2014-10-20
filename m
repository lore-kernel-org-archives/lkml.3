Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaJTPTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:19:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbaJTPTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:19:04 -0400
Message-ID: <544527CE.8090607@redhat.com>
Date: Mon, 20 Oct 2014 11:18:38 -0400
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
Subject: Re: [PATCH 3/5] mm, compaction: defer only on COMPACT_COMPLETE
References: <1412696019-21761-1-git-send-email-vbabka@suse.cz> <1412696019-21761-4-git-send-email-vbabka@suse.cz>
In-Reply-To: <1412696019-21761-4-git-send-email-vbabka@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 11:33 AM, Vlastimil Babka wrote:
> Deferred compaction is employed to avoid compacting zone where sync direct
> compaction has recently failed. As such, it makes sense to only defer when
> a full zone was scanned, which is when compact_zone returns with
> COMPACT_COMPLETE. It's less useful to defer when compact_zone returns with
> apparent success (COMPACT_PARTIAL), followed by a watermark check failure,
> which can happen due to parallel allocation activity. It also does not make
> much sense to defer compaction which was completely skipped (COMPACT_SKIP) for
> being unsuitable in the first place.
>
> This patch therefore makes deferred compaction trigger only when
> COMPACT_COMPLETE is returned from compact_zone(). Results of stress-highalloc
> becnmark show the difference is within measurement error, so the issue is
> rather cosmetic.
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

