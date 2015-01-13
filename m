Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbbAMLUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:20:51 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27632 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbbAMLUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:20:48 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-35-54b4ff8f6f7d
Message-id: <54B4FF8C.50805@samsung.com>
Date: Tue, 13 Jan 2015 12:20:44 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] ARM: DMA: Fix kzalloc flags in __iommu_alloc_buffer()
References: <1418027967-12923-1-git-send-email-acourbot@nvidia.com>
 <54897C14.3040702@samsung.com>
 <CAAVeFuL-x1-vmaViYou6ViRR+ipCnz5WdwbmKC4Cu5ViD+pVNA@mail.gmail.com>
In-reply-to: <CAAVeFuL-x1-vmaViYou6ViRR+ipCnz5WdwbmKC4Cu5ViD+pVNA@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xy7r9/7eEGPQfF7H4/vAUq8XfScfY
	Lc69esRisWzxU0aLTY+vsVpc3jWHzeL2ZV6L27/5HDg8Wpp72Dx+/5rE6LFz1l12j81L6j16
	m9+xeXx8eovF4/MmuQD2KC6blNSczLLUIn27BK6MZ2/3MhdMFaj4fGYnewPjJ54uRk4OCQET
	iReXVzFB2GISF+6tZ+ti5OIQEljKKPH95WkWCOcTo8Thr9uBqjg4eAU0JO7+9QVpYBFQldi/
	aTEjiM0mYCjR9baLDcQWFYiRWLxwNTOIzSsgKPFj8j2wOSICBxklPr2/xwziMAscYJT49fUW
	WLewgJfE9u2zGCG2rWaU+H+yiQUkwSkQLPGw9xg7iM0sYCbx5eVhVghbXmLzmrfMExgFZiHZ
	MgtJ2SwkZQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihMTA1x2MS49ZHWIU4GBU4uHd
	kb0lRIg1say4MvcQowQHs5IIb/p3oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGE/tFRiw7N/OK
	aO5KsJ5+NnLjgq6mt9+kWnWdWF933tawyNbfzVRsXuVUK3cpIO2db88unlvXJvxalVWndNLS
	1XTN/e/X77JY3jtg5zh9p8LTHbqJ3soi2/PN/loY7Nt/cp3429m7Tsmc8V/hHd4scfai/Jtu
	vVNMFtcklz965PlO+bNx5sR1SizFGYmGWsxFxYkApL/GN18CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2015-01-13 09:45, Alexandre Courbot wrote:
> Ping? This patch still seems to be needed as of today...

Arnd, could you take this patch together with your other pending 
dma-mapping.h changes?

> On Thu, Dec 11, 2014 at 8:12 PM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> On 2014-12-08 09:39, Alexandre Courbot wrote:
>>> There doesn't seem to be any valid reason to allocate the pages array
>>> with the same flags as the buffer itself. Doing so can eventually lead
>>> to the following safeguard in mm/slab.c to be hit:
>>>
>>> BUG_ON(flags & GFP_SLAB_BUG_MASK);
>>>
>>> This happens when buffers are allocated with __GFP_DMA32 or
>>> __GFP_HIGHMEM.
>>>
>>> Fix this by allocating the pages array with GFP_KERNEL to follow what is
>>> done elsewhere in this file. Using GFP_KERNEL in __iommu_alloc_buffer()
>>> is safe because atomic allocations are handled by __iommu_alloc_atomic().
>>>
>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>> Cc: Thierry Reding <treding@nvidia.com>
>>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>
>>> ---
>>>    arch/arm/mm/dma-mapping.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
>>> index e8907117861e..bc495354c802 100644
>>> --- a/arch/arm/mm/dma-mapping.c
>>> +++ b/arch/arm/mm/dma-mapping.c
>>> @@ -1106,7 +1106,7 @@ static struct page **__iommu_alloc_buffer(struct
>>> device *dev, size_t size,
>>>          int i = 0;
>>>          if (array_size <= PAGE_SIZE)
>>> -               pages = kzalloc(array_size, gfp);
>>> +               pages = kzalloc(array_size, GFP_KERNEL);
>>>          else
>>>                  pages = vzalloc(array_size);
>>>          if (!pages)
>>>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

