Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab3ILWal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:30:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44553 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab3ILWaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:30:39 -0400
Message-ID: <52324073.8090101@ti.com>
Date: Thu, 12 Sep 2013 17:30:11 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Joerg Roedel'" <joro@8bytes.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH] iommu/omap: Remove casting the return value which is
 a void pointer
References: <005601cead1e$ffe78470$ffb68d50$%han@samsung.com>
In-Reply-To: <005601cead1e$ffe78470$ffb68d50$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 12:39 AM, Jingoo Han wrote:
> Casting the return value which is a void pointer is redundant.
> The conversion from void pointer to any other pointer type is
> guaranteed by the C programming language.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Thanks, LGTM.

> ---
>  drivers/iommu/omap-iopgtable.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/omap-iopgtable.h b/drivers/iommu/omap-iopgtable.h
> index f4003d5..b6f9a51 100644
> --- a/drivers/iommu/omap-iopgtable.h
> +++ b/drivers/iommu/omap-iopgtable.h
> @@ -95,4 +95,4 @@ static inline phys_addr_t omap_iommu_translate(u32 d, u32 va, u32 mask)
>  #define iopte_offset(iopgd, da)	(iopgd_page_vaddr(iopgd) + iopte_index(da))
>  
>  #define to_iommu(dev)							\
> -	((struct omap_iommu *)platform_get_drvdata(to_platform_device(dev)))
> +	(platform_get_drvdata(to_platform_device(dev)))
> 

