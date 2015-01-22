Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbbAVElz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 23:41:55 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:54428 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbbAVElr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:41:47 -0500
MIME-Version: 1.0
In-Reply-To: <54B4FF8C.50805@samsung.com>
References: <1418027967-12923-1-git-send-email-acourbot@nvidia.com>
 <54897C14.3040702@samsung.com> <CAAVeFuL-x1-vmaViYou6ViRR+ipCnz5WdwbmKC4Cu5ViD+pVNA@mail.gmail.com>
 <54B4FF8C.50805@samsung.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 22 Jan 2015 13:41:25 +0900
Message-ID: <CAAVeFuKn6nE+KOSexGSK_=r5iv8bYBEheVU7=HyODGszEz+NAw@mail.gmail.com>
Subject: Re: [PATCH] ARM: DMA: Fix kzalloc flags in __iommu_alloc_buffer()
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 8:20 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
> On 2015-01-13 09:45, Alexandre Courbot wrote:
>>
>> Ping? This patch still seems to be needed as of today...
>
>
> Arnd, could you take this patch together with your other pending
> dma-mapping.h changes?

Arnd, gentle ping on this?

>
>
>> On Thu, Dec 11, 2014 at 8:12 PM, Marek Szyprowski
>> <m.szyprowski@samsung.com> wrote:
>>>
>>> On 2014-12-08 09:39, Alexandre Courbot wrote:
>>>>
>>>> There doesn't seem to be any valid reason to allocate the pages array
>>>> with the same flags as the buffer itself. Doing so can eventually lead
>>>> to the following safeguard in mm/slab.c to be hit:
>>>>
>>>> BUG_ON(flags & GFP_SLAB_BUG_MASK);
>>>>
>>>> This happens when buffers are allocated with __GFP_DMA32 or
>>>> __GFP_HIGHMEM.
>>>>
>>>> Fix this by allocating the pages array with GFP_KERNEL to follow what is
>>>> done elsewhere in this file. Using GFP_KERNEL in __iommu_alloc_buffer()
>>>> is safe because atomic allocations are handled by
>>>> __iommu_alloc_atomic().
>>>>
>>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>>> Cc: Russell King <linux@arm.linux.org.uk>
>>>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
>>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>>> Cc: Thierry Reding <treding@nvidia.com>
>>>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>>
>>> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>>
>>>> ---
>>>>    arch/arm/mm/dma-mapping.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
>>>> index e8907117861e..bc495354c802 100644
>>>> --- a/arch/arm/mm/dma-mapping.c
>>>> +++ b/arch/arm/mm/dma-mapping.c
>>>> @@ -1106,7 +1106,7 @@ static struct page **__iommu_alloc_buffer(struct
>>>> device *dev, size_t size,
>>>>          int i = 0;
>>>>          if (array_size <= PAGE_SIZE)
>>>> -               pages = kzalloc(array_size, gfp);
>>>> +               pages = kzalloc(array_size, GFP_KERNEL);
>>>>          else
>>>>                  pages = vzalloc(array_size);
>>>>          if (!pages)
>>>>
>
> Best regards
> --
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
>
