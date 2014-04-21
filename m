Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaDUNjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 09:39:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36241 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbaDUNjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 09:39:43 -0400
Message-ID: <53551F81.9040209@ti.com>
Date: Mon, 21 Apr 2014 09:39:13 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 7/7] ARM: mm: use phys_addr_t in __dma_page_[cpu_to_dev/dev_to_cpu]
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com> <1397917972-6293-8-git-send-email-santosh.shilimkar@ti.com>
In-Reply-To: <1397917972-6293-8-git-send-email-santosh.shilimkar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding few CC's)

On Saturday 19 April 2014 10:32 AM, Santosh Shilimkar wrote:
> On a 32 bit ARM architecture with LPAE extension physical addresses
> cannot fit into unsigned long variable.
> 
> So fix it by using phys_addr_t instead of unsigned long.
> 
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  arch/arm/mm/dma-mapping.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
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
> 

