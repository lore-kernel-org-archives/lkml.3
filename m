Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaGDJ30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:29:26 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:36635 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaGDJ3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:29:25 -0400
Message-ID: <53B673F4.1050205@huawei.com>
Date: Fri, 4 Jul 2014 17:29:24 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: David Woodhouse <dwmw2@infradead.org>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] trivial cleanup for iommu/vt-d
References: <1400589472-8544-1-git-send-email-wangyijing@huawei.com> <20140704092209.GA13434@8bytes.org>
In-Reply-To: <20140704092209.GA13434@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/4 17:22, Joerg Roedel wrote:
> On Tue, May 20, 2014 at 08:37:46PM +0800, Yijing Wang wrote:
>>
>> Yijing Wang (6):
>>   iommu/vt-d: Use list_for_each_safe() to simplify code
>>   iommu/vt-d: move up no_iommu and dmar_disabled check
>>   iommu/vt-d: clear the redundant assignment in dmar_enable_qi
>>   iommu/vt-d: clear the redundant assignment for domain->nid
>>   iommu/vt-d: use inline function dma_pte_superpage instead of macros
>>   iommu/vt-d: fix reference count in iommu_prepare_isa
> 
> Applied patches 1, 3, 4, 5 and 6, thanks. Also added another patch
> on-top, see below.

Thanks a lot!

Yijing.

> 
>>From 77c704bebc5d023ece7af32ea18bc3508cdb0007 Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <jroedel@suse.de>
> Date: Fri, 4 Jul 2014 11:19:10 +0200
> Subject: [PATCH] iommu/vt-d: Don't use magic number in dma_pte_superpage
> 
> Use the already defined DMA_PTE_LARGE_PAGE for testing
> instead of hardcoding the value again.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/iommu/intel-iommu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 9b9f28e..5d86e93 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -304,7 +304,7 @@ static inline bool dma_pte_present(struct dma_pte *pte)
>  
>  static inline bool dma_pte_superpage(struct dma_pte *pte)
>  {
> -	return (pte->val & (1 << 7));
> +	return (pte->val & DMA_PTE_LARGE_PAGE);
>  }
>  
>  static inline int first_pte_in_page(struct dma_pte *pte)
> 


-- 
Thanks!
Yijing

