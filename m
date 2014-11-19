Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbaKSVHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:07:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17425 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932793AbaKSVHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:07:04 -0500
Date: Wed, 19 Nov 2014 16:06:26 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, Ian.Campbell@citrix.com,
        david.vrabel@citrix.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com
Subject: Re: [PATCH v9 13/13] swiotlb-xen: remove BUG_ON in xen_bus_to_phys
Message-ID: <20141119210626.GD20440@laptop.dumpdata.com>
References: <alpine.DEB.2.02.1411121130020.26318@kaball.uk.xensource.com>
 <1415792454-23161-13-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415792454-23161-13-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 11:40:54AM +0000, Stefano Stabellini wrote:
> On x86 truncation cannot occur because config XEN depends on X86_64 ||
> (X86_32 && X86_PAE).
> 
> On ARM truncation can occur without CONFIG_ARM_LPAE, when the dma
> operation involves foreign grants. However in that case the physical
> address returned by xen_bus_to_phys is actually invalid (there is no mfn
> to pfn tracking for foreign grants on ARM) and it is not used.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/swiotlb-xen.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 498b654..153cf14 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -96,8 +96,6 @@ static inline phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
>  	dma_addr_t dma = (dma_addr_t)pfn << PAGE_SHIFT;
>  	phys_addr_t paddr = dma;
>  
> -	BUG_ON(paddr != dma); /* truncation has occurred, should never happen */
> -
>  	paddr |= baddr & ~PAGE_MASK;
>  
>  	return paddr;
> -- 
> 1.7.10.4
> 
