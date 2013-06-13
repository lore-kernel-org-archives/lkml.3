Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab3FMAoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 20:44:20 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:23432 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927Ab3FMAoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 20:44:19 -0400
Message-ID: <51B91599.5070006@hp.com>
Date: Thu, 13 Jun 2013 08:43:05 +0800
From: ZhenHua <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130117 Thunderbird/19.0
MIME-Version: 1.0
To: "Li, Zhen-Hua" <zhen-hual@hp.com>, David Woodhouse <dwmw2@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/iommu: fix dma pte address size error
References: <1369355756-1030-1-git-send-email-zhen-hual@hp.com>
In-Reply-To: <1369355756-1030-1-git-send-email-zhen-hual@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,
     I think this patch is necessary. Please take a look at it.

Thanks
Zhen-Hua

On 05/24/2013 08:35 AM, Li, Zhen-Hua wrote:
> In Intel Vt-D specs, Chapter 9.3 Page-Table Entry,
> The size of ADDR(address) field is 12:51, but the function dma_pte_addr
>   treats it as 12:63.
>
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> ---
>   drivers/iommu/intel-iommu.c   |    4 ++--
>   include/linux/dma_remapping.h |    2 ++
>   2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index b4f0e28..c6d2847 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -311,10 +311,10 @@ static inline void dma_set_pte_prot(struct dma_pte *pte, unsigned long prot)
>   static inline u64 dma_pte_addr(struct dma_pte *pte)
>   {
>   #ifdef CONFIG_64BIT
> -	return pte->val & VTD_PAGE_MASK;
> +	return pte->val & DMA_PTE_MASK;
>   #else
>   	/* Must have a full atomic 64-bit read */
> -	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
> +	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & DMA_PTE_MASK;
>   #endif
>   }
>   
> diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
> index 57c9a8a..7a1e212 100644
> --- a/include/linux/dma_remapping.h
> +++ b/include/linux/dma_remapping.h
> @@ -16,6 +16,8 @@
>   #define DMA_PTE_WRITE (2)
>   #define DMA_PTE_LARGE_PAGE (1 << 7)
>   #define DMA_PTE_SNP (1 << 11)
> +#define DMA_PTE_ADD_LENGTH (40)
> +#define DMA_PTE_MASK	((((u64)1 << DMA_PTE_ADD_LENGTH) - 1) << VTD_PAGE_SHIFT)
>   
>   #define CONTEXT_TT_MULTI_LEVEL	0
>   #define CONTEXT_TT_DEV_IOTLB	1

