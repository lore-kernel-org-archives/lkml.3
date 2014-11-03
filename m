Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbaKCKyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:54:35 -0500
Received: from smtp.citrix.com ([66.165.176.89]:29735 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbaKCKyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:54:32 -0500
X-IronPort-AV: E=Sophos;i="5.07,307,1413244800"; 
   d="scan'208";a="187465322"
Date: Mon, 3 Nov 2014 10:46:03 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>, <david.vrabel@citrix.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>, <will.deacon@arm.com>
Subject: Re: [PATCH v7 3/8] arm64: introduce is_device_dma_coherent
In-Reply-To: <1414422568-19103-3-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.DEB.2.02.1411031045340.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410261621200.22875@kaball.uk.xensource.com> <1414422568-19103-3-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Stefano Stabellini wrote:
> Introduce a boolean flag and an accessor function to check whether a
> device is dma_coherent. Set the flag from set_arch_dma_coherent_ops.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> CC: will.deacon@arm.com

Will, Catalin,
are you OK with this patch?


>  arch/arm64/include/asm/device.h      |    1 +
>  arch/arm64/include/asm/dma-mapping.h |    6 ++++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/device.h b/arch/arm64/include/asm/device.h
> index cf98b36..243ef25 100644
> --- a/arch/arm64/include/asm/device.h
> +++ b/arch/arm64/include/asm/device.h
> @@ -21,6 +21,7 @@ struct dev_archdata {
>  #ifdef CONFIG_IOMMU_API
>  	void *iommu;			/* private IOMMU data */
>  #endif
> +	bool dma_coherent;
>  };
>  
>  struct pdev_archdata {
> diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
> index adeae3f..e213dc4 100644
> --- a/arch/arm64/include/asm/dma-mapping.h
> +++ b/arch/arm64/include/asm/dma-mapping.h
> @@ -54,11 +54,17 @@ static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
>  
>  static inline int set_arch_dma_coherent_ops(struct device *dev)
>  {
> +	dev->archdata.dma_coherent = true;
>  	set_dma_ops(dev, &coherent_swiotlb_dma_ops);
>  	return 0;
>  }
>  #define set_arch_dma_coherent_ops	set_arch_dma_coherent_ops
>  
> +static inline bool is_device_dma_coherent(struct device *dev)
> +{
> +	return dev->archdata.dma_coherent;
> +}
> +
>  #include <asm-generic/dma-mapping-common.h>
>  
>  static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
> -- 
> 1.7.10.4
> 
