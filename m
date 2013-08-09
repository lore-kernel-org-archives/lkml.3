Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967955Ab3HIPhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:37:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34543 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934350Ab3HIPhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:37:10 -0400
Date: Fri, 9 Aug 2013 11:36:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com,
        will.deacon@arm.com, linux@arm.linux.org.uk
Subject: Re: [PATCH v3 04/10] arm: introduce a global dma_ops pointer
Message-ID: <20130809153622.GE5637@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1308051503190.4893@kaball.uk.xensource.com>
 <1375720256-8014-4-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375720256-8014-4-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 05:30:50PM +0100, Stefano Stabellini wrote:
> Initially set dma_ops to arm_dma_ops.

Looks OK to me.
> 
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: will.deacon@arm.com
> CC: linux@arm.linux.org.uk
> 
> 
> Changes in v3:
> -  keep using arm_dma_ops in dmabounce.
> ---
>  arch/arm/include/asm/dma-mapping.h |    3 ++-
>  arch/arm/mm/dma-mapping.c          |    3 +++
>  2 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index 5b8eef9..5c130bc 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -12,6 +12,7 @@
>  #include <asm/memory.h>
>  
>  #define DMA_ERROR_CODE	(~0)
> +extern struct dma_map_ops *dma_ops;
>  extern struct dma_map_ops arm_dma_ops;
>  extern struct dma_map_ops arm_coherent_dma_ops;
>  
> @@ -19,7 +20,7 @@ static inline struct dma_map_ops *get_dma_ops(struct device *dev)
>  {
>  	if (dev && dev->archdata.dma_ops)
>  		return dev->archdata.dma_ops;
> -	return &arm_dma_ops;
> +	return dma_ops;
>  }
>  
>  static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 7f9b179..870b12c 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -141,6 +141,9 @@ struct dma_map_ops arm_dma_ops = {
>  };
>  EXPORT_SYMBOL(arm_dma_ops);
>  
> +struct dma_map_ops *dma_ops = &arm_dma_ops;
> +EXPORT_SYMBOL(dma_ops);
> +
>  static void *arm_coherent_dma_alloc(struct device *dev, size_t size,
>  	dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs);
>  static void arm_coherent_dma_free(struct device *dev, size_t size, void *cpu_addr,
> -- 
> 1.7.2.5
> 
