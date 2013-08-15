Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735Ab3HOTq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:46:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38522 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759347Ab3HOTq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:46:27 -0400
Date: Thu, 15 Aug 2013 15:45:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v4 02/10] swiotlb-xen: replace dma_length with
 sg_dma_len() macro
Message-ID: <20130815194557.GB5337@konrad-lan.dumpdata.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
 <1376565054-24153-2-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376565054-24153-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 12:10:46PM +0100, Stefano Stabellini wrote:
> swiotlb-xen has an implicit dependency on CONFIG_NEED_SG_DMA_LENGTH.
> Remove it by replacing dma_length with sg_dma_len.
> 

Ditto. Already took that one.
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/xen/swiotlb-xen.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index aadffcf..1b2277c 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -506,13 +506,13 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
>  				   to do proper error handling. */
>  				xen_swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
>  							   attrs);
> -				sgl[0].dma_length = 0;
> +				sg_dma_len(sgl) = 0;
>  				return DMA_ERROR_CODE;
>  			}
>  			sg->dma_address = xen_phys_to_bus(map);
>  		} else
>  			sg->dma_address = dev_addr;
> -		sg->dma_length = sg->length;
> +		sg_dma_len(sg) = sg->length;
>  	}
>  	return nelems;
>  }
> @@ -533,7 +533,7 @@ xen_swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
>  	BUG_ON(dir == DMA_NONE);
>  
>  	for_each_sg(sgl, sg, nelems, i)
> -		xen_unmap_single(hwdev, sg->dma_address, sg->dma_length, dir);
> +		xen_unmap_single(hwdev, sg->dma_address, sg_dma_len(sg), dir);
>  
>  }
>  EXPORT_SYMBOL_GPL(xen_swiotlb_unmap_sg_attrs);
> @@ -555,7 +555,7 @@ xen_swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
>  
>  	for_each_sg(sgl, sg, nelems, i)
>  		xen_swiotlb_sync_single(hwdev, sg->dma_address,
> -					sg->dma_length, dir, target);
> +					sg_dma_len(sg), dir, target);
>  }
>  
>  void
> -- 
> 1.7.2.5
> 
