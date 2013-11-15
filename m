Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab3KOOQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:16:29 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37478 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3KOOQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:16:24 -0500
Date: Fri, 15 Nov 2013 09:15:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] swiotlb-xen: add missing xen_dma_map_page call
Message-ID: <20131115141518.GD27991@phenom.dumpdata.com>
References: <1384516653-28165-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384516653-28165-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 11:57:33AM +0000, Stefano Stabellini wrote:
> swiotlb-xen is missing a xen_dma_map_page call in
> xen_swiotlb_map_sg_attrs, in the bounce buffer path.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
Thank you!

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> Changes in v2:
> - reworked commit message.
> ---
>  drivers/xen/swiotlb-xen.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index a224bc7..1eac073 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -555,6 +555,11 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
>  				sg_dma_len(sgl) = 0;
>  				return 0;
>  			}
> +			xen_dma_map_page(hwdev, pfn_to_page(map >> PAGE_SHIFT),
> +						map & ~PAGE_MASK,
> +						sg->length,
> +						dir,
> +						attrs);
>  			sg->dma_address = xen_phys_to_bus(map);
>  		} else {
>  			/* we are not interested in the dma_addr returned by
> -- 
> 1.7.2.5
> 
