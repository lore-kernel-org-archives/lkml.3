Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbaE2Hen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:34:43 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58694 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbaE2Hem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:34:42 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-e0-5386e30f1822
Message-id: <5386E313.6070705@samsung.com>
Date: Thu, 29 May 2014 09:34:43 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] CMA: correct unlock target
References: <1401344958-3790-1-git-send-email-iamjoonsoo.kim@lge.com>
In-reply-to: <1401344958-3790-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xa7r8j9uCDS49Z7VY2d3MZrG9cwa7
	xabH11gtLu+aw2Zx+zKvxYLjLawObB4tzT1sHpf7epk8ut5eYfLYvKTeY92fV0wenzfJBbBF
	cdmkpOZklqUW6dslcGV0T3jBUrCHo+Lw7D0sDYzP2boYOTkkBEwkHm3cyw5hi0lcuLceKM7F
	ISSwlFFizZNNLBDOJ0aJFcees4BU8QpoSbye8J4RxGYRUJXo7N4CNolNwFCi620XmC0qECOx
	+/NCRoh6QYkfk++B9YoIaEisXrWZGWQos8AZRokXq1tZQRLCAvoSP+7sAztDSMBVYuONxWDN
	nAJuEh8Od4DVMAuYSTxqWccMYctLbF7zlnkCo8AsJDtmISmbhaRsASPzKkbR1NLkguKk9FxD
	veLE3OLSvHS95PzcTYyQIP+yg3HxMatDjAIcjEo8vBGhbcFCrIllxZW5hxglOJiVRHg/XQIK
	8aYkVlalFuXHF5XmpBYfYmTi4JRqYJx5hGfCwd0LBUIXe/oaKUpGLNhj98OkIPjZ8s0S/7e3
	fDs/Lbra+wJ3rXB88BOt+VMYv5XFGnM8SfpazzZrtqZ2h2wz306fNc4LmYX1lzx7xdW1Tdr+
	xhaT9KpHSp2dO/c6frcOz5/neqL9YPHW+6cXXJbR/Z/EN/uwlO495Qjxom+6SguM5ymxFGck
	GmoxFxUnAgB8TAbQUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-05-29 08:29, Joonsoo Kim wrote:
> 'cma: Remove potential deadlock situation' introduces per cma area mutex
> for bitmap management. It is good, but there is one mistake. When we
> can't find appropriate area in bitmap, we release cma_mutex global lock
> rather than cma->lock and this is a bug. So fix it.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Thanks for spotting this issue. I've added it to my tree.

> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 6f6bffc..83969f8 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -331,7 +331,7 @@ struct page *dma_alloc_from_contiguous(struct device *dev, int count,
>   		pageno = bitmap_find_next_zero_area(cma->bitmap, cma->count,
>   						    start, count, mask);
>   		if (pageno >= cma->count) {
> -			mutex_unlock(&cma_mutex);
> +			mutex_unlock(&cma->lock);
>   			break;
>   		}
>   		bitmap_set(cma->bitmap, pageno, count);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

