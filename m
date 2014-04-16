Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161855AbaDPPrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:47:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161580AbaDPPrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:47:36 -0400
Message-ID: <534EA601.8040104@redhat.com>
Date: Wed, 16 Apr 2014 11:47:13 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Heesub Shin <heesub.shin@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dongjun Shin <d.j.shin@samsung.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 1/2] mm/compaction: make isolate_freepages start at pageblock
 boundary
References: <5342BA34.8050006@suse.cz> <1397553507-15330-1-git-send-email-vbabka@suse.cz>
In-Reply-To: <1397553507-15330-1-git-send-email-vbabka@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 05:18 AM, Vlastimil Babka wrote:
> The compaction freepage scanner implementation in isolate_freepages() starts
> by taking the current cc->free_pfn value as the first pfn. In a for loop, it
> scans from this first pfn to the end of the pageblock, and then subtracts
> pageblock_nr_pages from the first pfn to obtain the first pfn for the next
> for loop iteration.
>
> This means that when cc->free_pfn starts at offset X rather than being aligned
> on pageblock boundary, the scanner will start at offset X in all scanned
> pageblock, ignoring potentially many free pages. Currently this can happen when
> a) zone's end pfn is not pageblock aligned, or
> b) through zone->compact_cached_free_pfn with CONFIG_HOLES_IN_ZONE enabled and
>     a hole spanning the beginning of a pageblock
>
> This patch fixes the problem by aligning the initial pfn in isolate_freepages()
> to pageblock boundary. This also allows to replace the end-of-pageblock
> alignment within the for loop with a simple pageblock_nr_pages increment.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reported-by: Heesub Shin <heesub.shin@samsung.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

