Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaETC1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 22:27:00 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:35545 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaETC07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 22:26:59 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <537ABD6F.9090608@lge.com>
Date: Tue, 20 May 2014 11:26:55 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Minchan Kim <minchan.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Laura Abbott <lauraa@codeaurora.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Heesub Shin <heesub.shin@samsung.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>, gurugio@gmail.com
Subject: Re: [RFC][PATCH] CMA: drivers/base/Kconfig: restrict CMA size to
 non-zero value
References: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com> <1399509144-8898-3-git-send-email-iamjoonsoo.kim@lge.com> <20140513030057.GC32092@bbox> <20140515015301.GA10116@js1304-P5Q-DELUXE> <5375C619.8010501@lge.com> <xa1tppjdfwif.fsf@mina86.com> <537962A0.4090600@lge.com> <20140519055527.GA24099@js1304-P5Q-DELUXE> <xa1td2f91qw5.fsf@mina86.com> <537AA6C7.1040506@lge.com> <xa1tzjiddyrr.fsf@mina86.com>
In-Reply-To: <xa1tzjiddyrr.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2014-05-20 오전 10:28, Michal Nazarewicz 쓴 글:
> On Mon, May 19 2014, Gioh Kim wrote:
>> If CMA option is not selected, __alloc_from_contiguous would not be
>> called.  We don't need to the fallback allocation.
>>
>> And if CMA option is selected and initialized correctly,
>> the cma allocation can fail in case of no-CMA-memory situation.
>> I thinks in that case we don't need to the fallback allocation also,
>> because it is normal case.
>>
>> Therefore I think the restriction of CMA size option and make CMA work
>> can cover every cases.
>
> Wait, you just wrote that if CMA is not initialised correctly, it's fine
> for atomic pool initialisation to fail, but if CMA size is initialised
> correctly but too small, this is somehow worse situation?  I'm a bit
> confused to be honest.

I'm sorry to confuse you.
Please forgive my poor English.
My point is atomic_pool should be able to work with/without CMA.


>
> IMO, cma=0 command line argument should be supported, as should having
> the default CMA size zero.  If CMA size is set to zero, kernel should
> behave as if CMA was not enabled at compile time.

It's also good if atomic_pool can work well with zero CMA size.

I can give up my patch.
But Joonsoo's patch should be applied.

Joonsoo, can you please send the full patch to maintainers?

>
>
>
