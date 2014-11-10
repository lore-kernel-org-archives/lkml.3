Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaKJSYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:24:23 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55715 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaKJSYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:24:21 -0500
Date: Mon, 10 Nov 2014 18:24:12 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 07/13] xen: add a dma_addr_t dev_addr argument to
 xen_dma_map_page
Message-ID: <20141110182411.GD25609@e104818-lin.cambridge.arm.com>
References: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com>
 <1415636045-24669-7-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415636045-24669-7-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 04:13:59PM +0000, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: david.vrabel@citrix.com
> CC: konrad.wilk@oracle.com
> ---
>  arch/arm/include/asm/xen/page-coherent.h   |    4 ++--
>  arch/arm64/include/asm/xen/page-coherent.h |    4 ++--
>  arch/x86/include/asm/xen/page-coherent.h   |    4 ++--
>  drivers/xen/swiotlb-xen.c                  |    6 ++++--
>  4 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/include/asm/xen/page-coherent.h b/arch/arm/include/asm/xen/page-coherent.h
> index d97b0b4..25d450c 100644
> --- a/arch/arm/include/asm/xen/page-coherent.h
> +++ b/arch/arm/include/asm/xen/page-coherent.h
> @@ -29,8 +29,8 @@ static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
>  }
>  
>  static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
> -	     unsigned long offset, size_t size, enum dma_data_direction dir,
> -	     struct dma_attrs *attrs)
> +	     dma_addr_t dev_addr, unsigned long offset, size_t size,
> +	     enum dma_data_direction dir, struct dma_attrs *attrs)

It works for me as well. But it would be good to add a comment for this
patch to explain why a new argument is needed (like dev_addr being the
actual machine address and not dom0 physical address).

-- 
Catalin
