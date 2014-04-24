Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbaDXPp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:45:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37031 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758339AbaDXPp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:45:56 -0400
Date: Thu, 24 Apr 2014 16:45:19 +0100
From: Will Deacon <will.deacon@arm.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH v3 7/7] ARM: dma: use phys_addr_t in
 __dma_page_[cpu_to_dev/dev_to_cpu]
Message-ID: <20140424154519.GE14110@arm.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
 <1398353407-2345-8-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398353407-2345-8-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 04:30:07PM +0100, Santosh Shilimkar wrote:
> On a 32 bit ARM architecture with LPAE extension physical addresses
> cannot fit into unsigned long variable.
> 
> So fix it by using phys_addr_t instead of unsigned long.
> 
> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  arch/arm/mm/dma-mapping.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Will Deacon <will.deacon@arm.com>

Will

> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index f62aa06..5260f43 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -885,7 +885,7 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
>  static void __dma_page_cpu_to_dev(struct page *page, unsigned long off,
>  	size_t size, enum dma_data_direction dir)
>  {
> -	unsigned long paddr;
> +	phys_addr_t paddr;
>  
>  	dma_cache_maint_page(page, off, size, dir, dmac_map_area);
>  
> @@ -901,7 +901,7 @@ static void __dma_page_cpu_to_dev(struct page *page, unsigned long off,
>  static void __dma_page_dev_to_cpu(struct page *page, unsigned long off,
>  	size_t size, enum dma_data_direction dir)
>  {
> -	unsigned long paddr = page_to_phys(page) + off;
> +	phys_addr_t paddr = page_to_phys(page) + off;
>  
>  	/* FIXME: non-speculating: not required */
>  	/* don't bother invalidating if DMA to device */
> -- 
> 1.7.9.5
> 
> 
