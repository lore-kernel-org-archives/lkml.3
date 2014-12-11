Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871AbaLKLM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 06:12:27 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30687 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbaLKLMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 06:12:25 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-78-54897c16c518
Message-id: <54897C14.3040702@samsung.com>
Date: Thu, 11 Dec 2014 12:12:20 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com, Arnd Bergmann <arnd@arndb.de>,
        Thierry Reding <treding@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] ARM: DMA: Fix kzalloc flags in __iommu_alloc_buffer()
References: <1418027967-12923-1-git-send-email-acourbot@nvidia.com>
In-reply-to: <1418027967-12923-1-git-send-email-acourbot@nvidia.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xK7piNZ0hBhe3SVt8f3iK1eLvpGPs
	FudePWKxWLb4KaPFpsfXWC0u75rDZnH7Mq/F7d98DhweLc09bB6/f01i9Ng56y67x+Yl9R69
	ze/YPD4+vcXi8XmTXAB7FJdNSmpOZllqkb5dAlfGi7PHGQuu8VQsXbKdrYFxPVcXIyeHhICJ
	xPw/O9ghbDGJC/fWs3UxcnEICSxllLj+4z8LhPOJUWJ3/1kWkCpeAS2JKbe3s4LYLAKqEpu6
	ToHF2QQMJbredrGB2KICMRKLF65mhqgXlPgx+R5YjYhAiET78d3MIEOZBS4xSqzY+58RJCEs
	4CWxffssMFtIwFliVet+sAWcAi4SuyacBmtmFjCT+PLyMCuELS+xec1b5gmMArOQ7JiFpGwW
	krIFjMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUIi4OsOxqXHrA4xCnAwKvHwZsR3hgix
	JpYVV+YeYpTgYFYS4bWKAArxpiRWVqUW5ccXleakFh9iZOLglGpg1Ij4kSlSvoprVrqkzeav
	Vl43Du/5q/xFVCI9J9Xix8SHb1kO5DnUn7fLcOGoe3HXMXTFiz8f29ff+pp6T09Z7/2cUOZC
	q40bFVycbS9eWebw+2WwpMBP3q2/6w5qTViYMe/8xtNyqsF8vkZeVxff4eBqFaiYLjaXhdVC
	csZNJS5exa3eAlOUlViKMxINtZiLihMBX2NaYF4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014-12-08 09:39, Alexandre Courbot wrote:
> There doesn't seem to be any valid reason to allocate the pages array
> with the same flags as the buffer itself. Doing so can eventually lead
> to the following safeguard in mm/slab.c to be hit:
>
> BUG_ON(flags & GFP_SLAB_BUG_MASK);
>
> This happens when buffers are allocated with __GFP_DMA32 or
> __GFP_HIGHMEM.
>
> Fix this by allocating the pages array with GFP_KERNEL to follow what is
> done elsewhere in this file. Using GFP_KERNEL in __iommu_alloc_buffer()
> is safe because atomic allocations are handled by __iommu_alloc_atomic().
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Thierry Reding <treding@nvidia.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   arch/arm/mm/dma-mapping.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index e8907117861e..bc495354c802 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -1106,7 +1106,7 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t size,
>   	int i = 0;
>   
>   	if (array_size <= PAGE_SIZE)
> -		pages = kzalloc(array_size, gfp);
> +		pages = kzalloc(array_size, GFP_KERNEL);
>   	else
>   		pages = vzalloc(array_size);
>   	if (!pages)

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

