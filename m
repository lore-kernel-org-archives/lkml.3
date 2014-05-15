Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaEOCpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 22:45:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42066 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaEOCpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 22:45:17 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-d3-53742a3addd1
Message-id: <53742A4B.4090901@samsung.com>
Date: Thu, 15 May 2014 11:45:31 +0900
From: Heesub Shin <heesub.shin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Minchan Kim <minchan.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Laura Abbott <lauraa@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC PATCH 2/3] CMA: aggressively allocate the pages on cma
 reserved memory when not used
References: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1399509144-8898-3-git-send-email-iamjoonsoo.kim@lge.com>
 <20140513030057.GC32092@bbox> <20140515015301.GA10116@js1304-P5Q-DELUXE>
In-reply-to: <20140515015301.GA10116@js1304-P5Q-DELUXE>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t8zLV0rrZJgg55jahZz1q9hs3h5SNNi
	9SZfi4OzlzBZrOxuZrPY3jmD3eLyrjlsFvfW/Ge1WHvkLrvF5HfPGC0WHG9htbi//wGbxd8r
	61kceD0Ov3nP7HG5r5fJY9OnSeweXW+vMHmcmPGbxWPdn1dMHu/3XWXz6NuyitFj8+lqj8+b
	5AK4orhsUlJzMstSi/TtErgyrmxpYCmYqFvxc+V/xgbGrSpdjBwcEgImEnsPy3UxcgKZYhIX
	7q1n62Lk4hASWMYoce77bSaIhInE5hU3WSAS0xklrrw5yQjhvGGUmNv/mhWkildAS+Lpv2Ns
	IDaLgKrE1qn9TCAb2AS0JQ5tCwYJiwpESNxrPAxVLijxY/I9FhBbRMBb4vazn2CbmQWOMkm8
	Pr4LbLOwQIbEzON/oTafYZR4fPAJWAengLnEi+2tYEXMAtYSKydtY4Sw5SU2r3nLDNIgIbCQ
	Q2LDgVvMEBcJSHybfIgF4mdZiU0HmCFek5Q4uOIGywRGsVlIjpqFZOwsJGMXMDKvYhRNLUgu
	KE5KLzLUK07MLS7NS9dLzs/dxAiJ8N4djLcPWB9iTAZaOZFZSjQ5H5gg8kriDY3NjCxMTUyN
	jcwtzUgTVhLnTXqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBkdHQ0m75+/cMrp9Df7xY
	6Fcid8Q06aPHBrcpisbuH7w+eb3viTMKKpn7/uvBK3tzOrhF7S4eFJgtq2P6ZF3T3WNc4mdn
	bL6pOEtm3fclVbxSjTvM7Zb2pfdlSS+L/jf7TknDoaimlcbM65aL5975NMG4UPnNrrDuBgMW
	zk7BxTmT7/JkcZv/VmIpzkg01GIuKk4EAC+WeM0GAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsVy+t9jQV0rrZJgg2Mn5S3mrF/DZvHykKbF
	6k2+FgdnL2GyWNndzGaxvXMGu8XlXXPYLO6t+c9qsfbIXXaLye+eMVosON7CanF//wM2i79X
	1rM48HocfvOe2eNyXy+Tx6ZPk9g9ut5eYfI4MeM3i8e6P6+YPN7vu8rm0bdlFaPH5tPVHp83
	yQVwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA
	3a6kUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzLiypYGlYKJuxc+V/xkb
	GLeqdDFyckgImEhsXnGTBcIWk7hwbz1bFyMXh5DAdEaJK29OMkI4bxgl5va/ZgWp4hXQknj6
	7xgbiM0ioCqxdWo/UxcjBwebgLbEoW3BIGFRgQiJe42HocoFJX5Mvge2QETAW+L2s59gC5gF
	jjJJvD6+iwkkISyQITHz+F8WiGVnGCUeH3wC1sEpYC7xYnsrWBGzgLXEyknbGCFseYnNa94y
	T2AUmIVkySwkZbOQlC1gZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZxAnkntYFzZYHGI
	UYCDUYmHl2FycbAQa2JZcWXuIUYJDmYlEV4TxpJgId6UxMqq1KL8+KLSnNTiQ4zJwCCYyCwl
	mpwPTG55JfGGxiZmRpZGZsYm5sbGpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cB4lFn1
	zu99x18uUZpdcudTgVXmqt2JnFVXJqybUK8xZ4qXeW/+jF5r3fXl0luvRR+J+vjqZidHDZNk
	fdqrgzotIi+Xb9Da/mnfokfrMlbkbTNJjjs3XVblX335pfiw1FL3eZsm8BTwTQxv/F/TXXf7
	mVn9spbFSxrTmtRuKelfSYw6zbiyiD9FiaU4I9FQi7moOBEAwVJoVmQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/15/2014 10:53 AM, Joonsoo Kim wrote:
> On Tue, May 13, 2014 at 12:00:57PM +0900, Minchan Kim wrote:
>> Hey Joonsoo,
>>
>> On Thu, May 08, 2014 at 09:32:23AM +0900, Joonsoo Kim wrote:
>>> CMA is introduced to provide physically contiguous pages at runtime.
>>> For this purpose, it reserves memory at boot time. Although it reserve
>>> memory, this reserved memory can be used for movable memory allocation
>>> request. This usecase is beneficial to the system that needs this CMA
>>> reserved memory infrequently and it is one of main purpose of
>>> introducing CMA.
>>>
>>> But, there is a problem in current implementation. The problem is that
>>> it works like as just reserved memory approach. The pages on cma reserved
>>> memory are hardly used for movable memory allocation. This is caused by
>>> combination of allocation and reclaim policy.
>>>
>>> The pages on cma reserved memory are allocated if there is no movable
>>> memory, that is, as fallback allocation. So the time this fallback
>>> allocation is started is under heavy memory pressure. Although it is under
>>> memory pressure, movable allocation easily succeed, since there would be
>>> many pages on cma reserved memory. But this is not the case for unmovable
>>> and reclaimable allocation, because they can't use the pages on cma
>>> reserved memory. These allocations regard system's free memory as
>>> (free pages - free cma pages) on watermark checking, that is, free
>>> unmovable pages + free reclaimable pages + free movable pages. Because
>>> we already exhausted movable pages, only free pages we have are unmovable
>>> and reclaimable types and this would be really small amount. So watermark
>>> checking would be failed. It will wake up kswapd to make enough free
>>> memory for unmovable and reclaimable allocation and kswapd will do.
>>> So before we fully utilize pages on cma reserved memory, kswapd start to
>>> reclaim memory and try to make free memory over the high watermark. This
>>> watermark checking by kswapd doesn't take care free cma pages so many
>>> movable pages would be reclaimed. After then, we have a lot of movable
>>> pages again, so fallback allocation doesn't happen again. To conclude,
>>> amount of free memory on meminfo which includes free CMA pages is moving
>>> around 512 MB if I reserve 512 MB memory for CMA.
>>>
>>> I found this problem on following experiment.
>>>
>>> 4 CPUs, 1024 MB, VIRTUAL MACHINE
>>> make -j24
>>>
>>> CMA reserve:		0 MB		512 MB
>>> Elapsed-time:		234.8		361.8
>>> Average-MemFree:	283880 KB	530851 KB
>>>
>>> To solve this problem, I can think following 2 possible solutions.
>>> 1. allocate the pages on cma reserved memory first, and if they are
>>>     exhausted, allocate movable pages.
>>> 2. interleaved allocation: try to allocate specific amounts of memory
>>>     from cma reserved memory and then allocate from free movable memory.
>>
>> I love this idea but when I see the code, I don't like that.
>> In allocation path, just try to allocate pages by round-robin so it's role
>> of allocator. If one of migratetype is full, just pass mission to reclaimer
>> with hint(ie, Hey reclaimer, it's non-movable allocation fail
>> so there is pointless if you reclaim MIGRATE_CMA pages) so that
>> reclaimer can filter it out during page scanning.
>> We already have an tool to achieve it(ie, isolate_mode_t).
>
> Hello,
>
> I agree with leaving fast allocation path as simple as possible.
> I will remove runtime computation for determining ratio in
> __rmqueue_cma() and, instead, will use pre-computed value calculated
> on the other path.
>
> I am not sure that whether your second suggestion(Hey relaimer part)
> is good or not. In my quick thought, that could be helpful in the
> situation that many free cma pages remained. But, it would be not helpful
> when there are neither free movable and cma pages. In generally, most
> workloads mainly uses movable pages for page cache or anonymous mapping.
> Although reclaim is triggered by non-movable allocation failure, reclaimed
> pages are used mostly by movable allocation. We can handle these allocation
> request even if we reclaim the pages just in lru order. If we rotate
> the lru list for finding movable pages, it could cause more useful
> pages to be evicted.
>
> This is just my quick thought, so please let me correct if I am wrong.

We have an out of tree implementation that is completely the same with 
the approach Minchan said and it works, but it has definitely some 
side-effects as you pointed, distorting the LRU and evicting hot pages. 
I do not attach code fragments in this thread for some reasons, but it 
must be easy for yourself. I am wondering if it could help also in your 
case.

Thanks,
Heesub

>
>>
>> And we couldn't do it in zone_watermark_ok with set/reset ALLOC_CMA?
>> If possible, it would be better becauser it's generic function to check
>> free pages and cause trigger reclaim/compaction logic.
>
> I guess, your *it* means ratio computation. Right?
> I don't like putting it on zone_watermark_ok(). Although it need to
> refer to free cma pages value which are also referred in zone_watermark_ok(),
> this computation is for determining ratio, not for triggering
> reclaim/compaction. And this zone_watermark_ok() is on more hot-path, so
> putting this logic into zone_watermark_ok() looks not better to me.
>
> I will think better place to do it.
>
> Thanks.
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
