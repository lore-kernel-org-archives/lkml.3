Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaETLiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:38:18 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17351 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaETLiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:38:16 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfec7f4-b7fac6d000006cfe-d1-537b3ea6544b
Content-transfer-encoding: 8BIT
Message-id: <537B3EA5.2040302@samsung.com>
Date: Tue, 20 May 2014 13:38:13 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
To: Gioh Kim <gioh.kim@lge.com>, Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Laura Abbott <lauraa@codeaurora.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Heesub Shin <heesub.shin@samsung.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>, gurugio@gmail.com
Subject: Re: [RFC][PATCH] CMA: drivers/base/Kconfig: restrict CMA size to
 non-zero value
References: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1399509144-8898-3-git-send-email-iamjoonsoo.kim@lge.com>
 <20140513030057.GC32092@bbox> <20140515015301.GA10116@js1304-P5Q-DELUXE>
 <5375C619.8010501@lge.com> <xa1tppjdfwif.fsf@mina86.com>
 <537962A0.4090600@lge.com> <20140519055527.GA24099@js1304-P5Q-DELUXE>
 <xa1td2f91qw5.fsf@mina86.com> <537AA6C7.1040506@lge.com>
In-reply-to: <537AA6C7.1040506@lge.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsVy+t/xy7rL7KqDDe7cELGYs34Nm8Wzpi+M
	FhemLWS2mHz4I5PF6k2+FgdnL2GyWNndzGaxvXMGu8XlXXPYLO6t+c9qMfndM0aLBcdbWC3u
	73/AZvH3ynoWBz6Pw2/eM3tc7utl8tg56y67x6ZPk9g9ut5eYfI4MeM3i8e6P6+YPN7vu8rm
	0bdlFaPH5tPVHp83yQVwR3HZpKTmZJalFunbJXBlLPlsXvBHqKLj4G/mBsYvfF2MnBwSAiYS
	s/t+MEPYYhIX7q1n62Lk4hASWMoo8XTOURaQBK+AoMSPyfeAbA4OZgF5iSOXskHCzAJmEo9a
	1jFD1H9ilLj8rosNpIZXQEti/7lMkBoWAVWJjX0TWUFsNgFDia63ICWcHKICMRK7Py9kBLFF
	BPIktszYADaHWeAfk8StuSvAGoQFoiSebW9ihFjQxSyxbNJ5sASngLrEjPMbmScwCsxCct8s
	hPtmIblvASPzKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQCPuyg3HxMatDjAIcjEo8vA62
	VcFCrIllxZW5hxglOJiVRHi1bauDhXhTEiurUovy44tKc1KLDzEycXBKNTD2GkYor+ybtELm
	VJ/Thp5nBqp6D8NZVMuTri2a3THPduexC1sWu9xtCIvKaXZ/pv/v8WPpR9LTWOuyvv89fncR
	n9Hh7x/9ws2+ytpUXd3hbqDwPUnk+lmnZ8U/d+iIf29+cWzyTed3XgufqKcd681pVVwYOUuS
	076tbftMjq19U1/WLbptLRujxFKckWioxVxUnAgAdkhZio4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-05-20 02:50, Gioh Kim wrote:
>
>
> 2014-05-20 오전 4:59, Michal Nazarewicz 쓴 글:
>> On Sun, May 18 2014, Joonsoo Kim wrote:
>>> I think that this problem is originated from atomic_pool_init().
>>> If configured coherent_pool size is larger than default cma size,
>>> it can be failed even if this patch is applied.
>
> The coherent_pool size (atomic_pool.size) should be restricted smaller 
> than cma size.
>
> This is another issue, however I think the default atomic pool size is 
> too small.
> Only one port of USB host needs at most 256Kbytes coherent memory 
> (according to the USB host spec).

This pool is used only for allocation done in atomic context (allocations
done with GFP_ATOMIC flag), otherwise the standard allocation path is used.
Are you sure that each usb host port really needs so much memory allocated
in atomic context?

> If a platform has several ports, it needs more than 1MB.
> Therefore the default atomic pool size should be at least 1MB.
>
>>>
>>> How about below patch?
>>> It uses fallback allocation if CMA is failed.
>>
>> Yes, I thought about it, but __dma_alloc uses similar code:
>>
>>     else if (!IS_ENABLED(CONFIG_DMA_CMA))
>>         addr = __alloc_remap_buffer(dev, size, gfp, prot, &page, 
>> caller);
>>     else
>>         addr = __alloc_from_contiguous(dev, size, prot, &page, caller);
>>
>> so it probably needs to be changed as well.
>
> If CMA option is not selected, __alloc_from_contiguous would not be 
> called.
> We don't need to the fallback allocation.
>
> And if CMA option is selected and initialized correctly,
> the cma allocation can fail in case of no-CMA-memory situation.
> I thinks in that case we don't need to the fallback allocation also,
> because it is normal case.
>
> Therefore I think the restriction of CMA size option and make CMA work 
> can cover every cases.
>
> I think below patch is also good choice.
> If both of you, Michal and Joonsoo, do not agree with me, please 
> inform me.
> I will make a patch including option restriction and fallback allocation.

I'm not sure if we need a fallback for failed CMA allocation. The only 
issue that
have been mentioned here and needs to be resolved is support for 
disabling cma by
kernel command line. Right now it will fails completely.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

