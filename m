Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaKJSfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:35:08 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55748 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaKJSfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:35:05 -0500
Date: Mon, 10 Nov 2014 18:34:54 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 10/13] xen/arm/arm64: introduce xen_arch_need_swiotlb
Message-ID: <20141110183453.GG25609@e104818-lin.cambridge.arm.com>
References: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com>
 <1415636045-24669-10-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415636045-24669-10-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 04:14:02PM +0000, Stefano Stabellini wrote:
> --- a/arch/arm/include/asm/xen/page.h
> +++ b/arch/arm/include/asm/xen/page.h
> @@ -107,4 +107,8 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
>  #define xen_remap(cookie, size) ioremap_cache((cookie), (size))
>  #define xen_unmap(cookie) iounmap((cookie))
>  
> +bool xen_arch_need_swiotlb(struct device *dev,
> +			   unsigned long pfn,
> +			   unsigned long mfn);
> +
>  #endif /* _ASM_ARM_XEN_PAGE_H */
> diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
> index 0e96023..1b087cd 100644
> --- a/arch/arm/xen/mm.c
> +++ b/arch/arm/xen/mm.c
> @@ -102,6 +102,13 @@ void __xen_dma_sync_single_for_device(struct device *hwdev,
>  	__xen_dma_page_cpu_to_dev(hwdev, handle, size, dir);
>  }
>  
> +bool xen_arch_need_swiotlb(struct device *dev,
> +			   unsigned long pfn,
> +			   unsigned long mfn)
> +{
> +	return ((pfn != mfn) && !is_device_dma_coherent(dev));
> +}

Why not a static inline? It doesn't look like a big function.

-- 
Catalin
