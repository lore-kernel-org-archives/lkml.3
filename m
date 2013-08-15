Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161Ab3HOTqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:46:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38473 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab3HOTqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:46:17 -0400
Date: Thu, 15 Aug 2013 15:45:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com,
        EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: [PATCH v4 01/10] swiotlb: replace dma_length with sg_dma_len()
 macro
Message-ID: <20130815194532.GA5337@konrad-lan.dumpdata.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
 <1376565054-24153-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376565054-24153-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 12:10:45PM +0100, Stefano Stabellini wrote:
> From: EUNBONG SONG <eunb.song@samsung.com>
> 
> This patch replace dma_length in "lib/swiotlb.c" to sg_dma_len() macro,
> because the build error can occur if CONFIG_NEED_SG_DMA_LENGTH is not
> set, and CONFIG_SWIOTLB is set.
> 
> Singed-off-by: EunBong Song <eunb.song@samsung.com>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

I already took that patch, so you can drop it here.
> ---
>  lib/swiotlb.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index d23762e..4e8686c 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -870,13 +870,13 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
>  				swiotlb_full(hwdev, sg->length, dir, 0);
>  				swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
>  						       attrs);
> -				sgl[0].dma_length = 0;
> +				sg_dma_len(sgl) = 0;
>  				return 0;
>  			}
>  			sg->dma_address = phys_to_dma(hwdev, map);
>  		} else
>  			sg->dma_address = dev_addr;
> -		sg->dma_length = sg->length;
> +		sg_dma_len(sg) = sg->length;
>  	}
>  	return nelems;
>  }
> @@ -904,7 +904,7 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
>  	BUG_ON(dir == DMA_NONE);
>  
>  	for_each_sg(sgl, sg, nelems, i)
> -		unmap_single(hwdev, sg->dma_address, sg->dma_length, dir);
> +		unmap_single(hwdev, sg->dma_address, sg_dma_len(sg), dir);
>  
>  }
>  EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
> @@ -934,7 +934,7 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
>  
>  	for_each_sg(sgl, sg, nelems, i)
>  		swiotlb_sync_single(hwdev, sg->dma_address,
> -				    sg->dma_length, dir, target);
> +				    sg_dma_len(sg), dir, target);
>  }
>  
>  void
> -- 
> 1.7.2.5
> 
