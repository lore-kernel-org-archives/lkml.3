Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaKFRjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:39:21 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:57158 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaKFRjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:39:19 -0500
X-IronPort-AV: E=Sophos;i="5.07,327,1413244800"; 
   d="scan'208";a="190270188"
Date: Thu, 6 Nov 2014 17:30:59 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Frediano Ziglio <frediano.ziglio@huawei.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/arm: Return correct code error for
 xen_swiotlb_map_page
In-Reply-To: <1415293651-13917-1-git-send-email-frediano.ziglio@huawei.com>
Message-ID: <alpine.DEB.2.02.1411061730240.22875@kaball.uk.xensource.com>
References: <1415293651-13917-1-git-send-email-frediano.ziglio@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2014, Frediano Ziglio wrote:
> On ARM error code is not 0 so avoid to return it as error.
> 
> Signed-off-by: Frediano Ziglio <frediano.ziglio@huawei.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


Could you please fix the same error in lib/swiotlb.c too please?

>  drivers/xen/swiotlb-xen.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index ebd8f21..3b8d628 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -425,7 +425,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
>  	 */
>  	if (!dma_capable(dev, dev_addr, size)) {
>  		swiotlb_tbl_unmap_single(dev, map, size, dir);
> -		dev_addr = 0;
> +		dev_addr = DMA_ERROR_CODE;
>  	}
>  	return dev_addr;
>  }
> -- 
> 1.9.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://secure-web.cisco.com/1cvjROyUxV6SnA0uBTMRubqrQWsaXGhps-FWjY3vly9AxaKKlt2DPY7GjL0FCHeP4rsbjKsc-P4zH2_7-kpcxwEH-udGrGCCqkCLlH1-fLOo1X6Nlui6EwEVHUpB2r7gt-Gsgxbep9QWPnIdypDPNf8Hf5clxCMXYcvWsOK5s3qg/http%3A%2F%2Fwww.tux.org%2Flkml%2F
> 
