Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbaE2IJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:09:46 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:50958 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbaE2IJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:09:43 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <5386EB3E.5090007@lge.com>
Date: Thu, 29 May 2014 17:09:34 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] CMA: aggressively allocate the pages on cma reserved
 memory when not used
References: <1401260672-28339-1-git-send-email-iamjoonsoo.kim@lge.com> <1401260672-28339-3-git-send-email-iamjoonsoo.kim@lge.com> <5386E0CA.5040201@lge.com> <20140529074847.GA7554@js1304-P5Q-DELUXE>
In-Reply-To: <20140529074847.GA7554@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> +
>>>    /*
>>>     * Do the hard work of removing an element from the buddy allocator.
>>>     * Call me with the zone->lock already held.
>>> @@ -1143,10 +1223,15 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
>>>    static struct page *__rmqueue(struct zone *zone, unsigned int order,
>>>    						int migratetype)
>>>    {
>>> -	struct page *page;
>>> +	struct page *page = NULL;
>>> +
>>> +	if (IS_ENABLED(CONFIG_CMA) &&
>>
>> You might know that CONFIG_CMA is enabled and there is no CMA memory, because CONFIG_CMA_SIZE_MBYTES can be zero.
>> Is IS_ENABLED(CONFIG_CMA) alright in that case?
>
> next line checks whether zone->managed_cma_pages is positive or not.
> If there is no CMA memory, zone->managed_cma_pages will be zero and
> we will skip to call __rmqueue_cma().

Is IS_ENABLED(CONFIG_CMA) necessary?
What about if (migratetype == MIGRATE_MOVABLE && zone->managed_cma_pages) ?

>
> Thanks for review!!!
>
> Thanks.
>
>
