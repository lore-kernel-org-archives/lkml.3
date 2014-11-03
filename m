Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaKCKzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:55:43 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:30459 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaKCKzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:55:38 -0500
X-IronPort-AV: E=Sophos;i="5.07,307,1413244800"; 
   d="scan'208";a="188843297"
Date: Mon, 3 Nov 2014 10:55:32 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>, <david.vrabel@citrix.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>, <linux@arm.linux.org.uk>,
        <will.deacon@arm.com>
Subject: Re: [PATCH v7 4/8] arm: introduce is_device_dma_coherent
In-Reply-To: <1414422568-19103-4-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.DEB.2.02.1411031054400.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410261621200.22875@kaball.uk.xensource.com> <1414422568-19103-4-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Stefano Stabellini wrote:
> Introduce a boolean flag and an accessor function to check whether a
> device is dma_coherent. Set the flag from set_arch_dma_coherent_ops.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> CC: linux@arm.linux.org.uk
> CC: will.deacon@arm.com

Any opinions on this?
FYI I have just submitted the patch to Russell's patch tracking system.


>  arch/arm/include/asm/device.h      |    1 +
>  arch/arm/include/asm/dma-mapping.h |    6 ++++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/arch/arm/include/asm/device.h b/arch/arm/include/asm/device.h
> index dc662fc..4111592 100644
> --- a/arch/arm/include/asm/device.h
> +++ b/arch/arm/include/asm/device.h
> @@ -17,6 +17,7 @@ struct dev_archdata {
>  #ifdef CONFIG_ARM_DMA_USE_IOMMU
>  	struct dma_iommu_mapping	*mapping;
>  #endif
> +	bool dma_coherent;
>  };
>  
>  struct omap_device;
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index 85738b2..8c3b616 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -123,11 +123,17 @@ static inline unsigned long dma_max_pfn(struct device *dev)
>  
>  static inline int set_arch_dma_coherent_ops(struct device *dev)
>  {
> +	dev->archdata.dma_coherent = true;
>  	set_dma_ops(dev, &arm_coherent_dma_ops);
>  	return 0;
>  }
>  #define set_arch_dma_coherent_ops(dev)	set_arch_dma_coherent_ops(dev)
>  
> +static inline bool is_device_dma_coherent(struct device *dev)
> +{
> +	return dev->archdata.dma_coherent;
> +}
> +
>  static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
>  {
>  	unsigned int offset = paddr & ~PAGE_MASK;
> -- 
> 1.7.10.4
> 
