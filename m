Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaKCIWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:22:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:35514 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaKCIWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:22:15 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-16-54573b3493c2
Message-id: <54573B3B.4070500@samsung.com>
Date: Mon, 03 Nov 2014 17:22:19 +0900
From: Heesub Shin <heesub.shin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Gioh Kim <gioh.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5 2/4] mm/page_alloc: add freepage on isolate pageblock to
 correct buddy list
References: <1414740330-4086-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1414740330-4086-3-git-send-email-iamjoonsoo.kim@lge.com>
In-reply-to: <1414740330-4086-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0ySURje+W58WKwvSj3ZymLrhplmWqfZWr/qW61NV9rlj5J+oxYggbb6
	VYZrRosRtFKisszyGoktLFkB2iC7p65YySwbJVpky+ymxsU2/7x73vc87/M8Z3tpXGgnE+h9
	imJOpZDIRFQM8Wjcn5ycnrlje6q3YQEyWxop1D94kUDNFRYSDbiWIf+x7wA1WLci5/mrGKo7
	qaHQOX0y8n40E8h2ooKHuu6aKeRrnCBRU0cvDxm/+AGqcpeR6NpIkIe+NnUSyH3KgaGxbguB
	nJ3lPFTV/B6g0rYvFLKZBzF0vlQHkNc5iqOX7kp8w1z20+VbONs+FMTZCacBZ7t0pzD2jqmX
	x7bUilnPh5cUa60/ESrfDDxW+7kbYz0Vfwj24sNsts/VQrA3/gYwNnivh2J1t+pB1qzdMesK
	Odm+g5wqZX1+zN7St08ppW7eoQ81/cRRMBCvBXwaMulw+EoQj+I4+NxnobQghhYy1wDU3GnA
	/pPq7j8mog/nALRqLpPRZgjA49UjEZaAEcPXQXdEimAWwdOVnSESTVNMEnTd3hYexzI7oUPn
	J6P0mfCn0UeE8WwmB14or48Y4Mw3Ct40BSKas5hCeGO0edK5FMBRfXVkm89shM/e/oyY4Uwm
	rDPcBlGcCFsaP+PhBchc58PAj/HJRAz8YXQR4USQmQetjsk/z4HO2teEHsSZpoQyTZE1TZGt
	Ang9iOWUBUr1HqkqfYVaIleXKKQrCorkVhA9Kn0r8DkyXYChgWi6QGnL3S4kJQfVh+UukBFK
	cRpPiC0oCt2hojhv5arVaSgjPWNV2pq1q0XxgsGEX9uEjFRSzO3nOCWnylOVyDi1C2A0P+Eo
	ODm/TPdi97pND9LOavNaZSPZd6G1pkS+cPkBvH3JI/JvRb49VdDkOZDzri/HK0ua484tynoi
	PgT1ZkufYsf62rKx+26VwZaa0prdsajt8IyOzQF7f6J06NKxZP9wz3zNUqLN/nvXK1/KFn7w
	qydpyeIjb5RnFEZqYNpNamZu/rCIUO+VrBTjKrXkH4QXwppPAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA2VSe0hTYRTv2727u0aD69T6Wi+5FJU1c5u5z+whKHKjBKuZEsS6uYuvba5d
	leyftixLy+Uj0DYT04o0Hzkje0C6FazW24oUSizFXpY9MciyuVFInT8Ov3P4PeBwSExSREjJ
	TEMuZzKwOpqYjt/+NRgoi4xJUUdU34Wopq2ZQIPvanHUXt0mRG9cS9Hwvq8AnXMkIqf9lAA1
	Hi4kUFWZDPW9qsFRZ3G1CD26UkOg/uYJIWq58VyEKj8MA1Tn3i9EZ76NitDHFg+O3KXdAvTz
	cRuOnJ5DIlTX/hIgy9UPBOqseSdAdosVoD7nGIZ63Mex2DnM65MXMOb6yCjGTDgrMOaRtVTA
	XLY9FzEdZ8OYm0M9BONoKva2zxUipuT9YwFzs/oHztTe2sQMuDpwpnX8rYAZvfaEYKwXmkBS
	0DYzWJ3BsVrOFMoZ0nK0mYb0NfSGLZo4zcqoCLlMHo1UdKiB1XNr6PiNSbKETJ33PHRoPqvL
	866SWJ6nV6z93yFZnSBDf4SpskT15r8aRcQ/taMVZFie3SOM1nm7h04P4mbwZlYJCCAhFQkb
	u+7gfjwTPuhvI0rAdFJCVQHoKDwp9A8jABY1fBNMssRUGOwddWOTGKcWwfLjHi+JJAlqGXRd
	3DK5DqFSYbd1WOinB8Lvlf2+gGAqGZ441IRPemLUZwKet731eQZRWtg61o77wywAjpU1+NQB
	VAK8/+y7LwyjYmBjxUXgxwtgR/N7rAxQtikhtik02xRaHcCaQAhnTDPyO9P18nCe1fN5hvTw
	tBy9A/h+cFh6CTSakQtQJKBniI2dW9USIZvPF+hdAJIYHSw+sjxFLRFr2YI9nClHY8rTcbwL
	rPSeoByThqTleD/akKuRKyOjFNGKKGWkSqmkZ4m7D8RsklDpbC6XzXFGzvRHJyADpGZQmFWr
	apHlPw0aH++1bM9Otg98KbQT65T1VbuceSPTvoiHwrtU5pFih1HLMsvKJZVZ1lj3Es+vnffn
	bkMeMnNAd6mWPrpqdmu0fGBhcMHBuJ/zu2Z3jU/YVcFFfPsLTYmC7d6rYI+tDe2Uju2paF5P
	PsxffLW0LF7d9ylxqH4HjfMZrDwMM/HsbzdlvZGZAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/31/2014 04:25 PM, Joonsoo Kim wrote:
> In free_pcppages_bulk(), we use cached migratetype of freepage
> to determine type of buddy list where freepage will be added.
> This information is stored when freepage is added to pcp list, so
> if isolation of pageblock of this freepage begins after storing,
> this cached information could be stale. In other words, it has
> original migratetype rather than MIGRATE_ISOLATE.
>
> There are two problems caused by this stale information. One is that
> we can't keep these freepages from being allocated. Although this
> pageblock is isolated, freepage will be added to normal buddy list
> so that it could be allocated without any restriction. And the other
> problem is incorrect freepage accounting. Freepages on isolate pageblock
> should not be counted for number of freepage.
>
> Following is the code snippet in free_pcppages_bulk().
>
> /* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
> __free_one_page(page, page_to_pfn(page), zone, 0, mt);
> trace_mm_page_pcpu_drain(page, 0, mt);
> if (likely(!is_migrate_isolate_page(page))) {
> 	__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
> 	if (is_migrate_cma(mt))
> 		__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
> }
>
> As you can see above snippet, current code already handle second problem,
> incorrect freepage accounting, by re-fetching pageblock migratetype
> through is_migrate_isolate_page(page). But, because this re-fetched
> information isn't used for __free_one_page(), first problem would not be
> solved. This patch try to solve this situation to re-fetch pageblock
> migratetype before __free_one_page() and to use it for __free_one_page().
>
> In addition to move up position of this re-fetch, this patch use
> optimization technique, re-fetching migratetype only if there is
> isolate pageblock. Pageblock isolation is rare event, so we can
> avoid re-fetching in common case with this optimization.
>
> This patch also correct migratetype of the tracepoint output.
>
> Cc: <stable@vger.kernel.org>
> Acked-by: Minchan Kim <minchan@kernel.org>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>   mm/page_alloc.c |   13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f7a867e..6df23fe 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -725,14 +725,17 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>   			/* must delete as __free_one_page list manipulates */
>   			list_del(&page->lru);
>   			mt = get_freepage_migratetype(page);
> +			if (unlikely(has_isolate_pageblock(zone))) {

How about adding an additional check for 'mt == MIGRATE_MOVABLE' here? 
Then, most of get_pageblock_migratetype() calls could be avoided while 
the isolation is in progress. I am not sure this is the case on memory 
offlining. How do you think?

> +				mt = get_pageblock_migratetype(page);
> +				if (is_migrate_isolate(mt))
> +					goto skip_counting;
> +			}
> +			__mod_zone_freepage_state(zone, 1, mt);
> +
> +skip_counting:
>   			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
>   			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
>   			trace_mm_page_pcpu_drain(page, 0, mt);
> -			if (likely(!is_migrate_isolate_page(page))) {
> -				__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
> -				if (is_migrate_cma(mt))
> -					__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
> -			}
>   		} while (--to_free && --batch_free && !list_empty(list));
>   	}
>   	spin_unlock(&zone->lock);
>
