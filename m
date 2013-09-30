Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3I3P6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:58:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44587 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab3I3P6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:58:43 -0400
Date: Mon, 30 Sep 2013 11:58:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v6 14/19] swiotlb: print a warning when the swiotlb is
 full
Message-ID: <20130930155808.GT3106@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
 <1380298207-29151-14-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380298207-29151-14-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 05:10:02PM +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/xen/swiotlb-xen.c |    1 +
>  lib/swiotlb.c             |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 96ad316..790c2eb 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -674,6 +674,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
>  								 sg->length,
>  								 dir);
>  			if (map == SWIOTLB_MAP_ERROR) {
> +				pr_warn("swiotlb buffer is full\n");

It would be beneficial to use dev_warn instead.

And perhaps even call debug_dma_dump_mappings to help in diagnosing
a problem?

>  				/* Don't panic here, we expect map_sg users
>  				   to do proper error handling. */
>  				xen_swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index eb45d17..f06da0d 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -502,6 +502,7 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
>  
>  not_found:
>  	spin_unlock_irqrestore(&io_tlb_lock, flags);
> +	pr_warn("swiotlb buffer is full\n");
>  	return SWIOTLB_MAP_ERROR;
>  found:
>  	spin_unlock_irqrestore(&io_tlb_lock, flags);
> -- 
> 1.7.2.5
> 
