Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaJTV35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:29:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbaJTV3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:29:55 -0400
Message-ID: <1413840583.4202.111.camel@ul30vt.home>
Subject: Re: [PATCH 2/5] vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 20 Oct 2014 15:29:43 -0600
In-Reply-To: <1413205748-6300-3-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205748-6300-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1413205748-6300-3-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 15:09 +0200, Antonios Motakis wrote:
> We introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag to the VFIO dma map call,
> and expose its availability via the capability VFIO_DMA_NOEXEC_IOMMU.
> This way the user can control whether the XN flag will be set on the
> requested mappings. The IOMMU_NOEXEC flag needs to be available for all
> the IOMMUs of the container used.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  include/uapi/linux/vfio.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 6612974..111b5e8 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -29,6 +29,7 @@
>   * capability is subject to change as groups are added or removed.
>   */
>  #define VFIO_DMA_CC_IOMMU		4
> +#define VFIO_DMA_NOEXEC_IOMMU		5
>  
>  /* Check if EEH is supported */
>  #define VFIO_EEH			5
                                    ^^
5 is still already used.  Feel free to convert to enum so we stop making
this mistake.

> @@ -401,6 +402,7 @@ struct vfio_iommu_type1_dma_map {
>  	__u32	flags;
>  #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
>  #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
> +#define VFIO_DMA_MAP_FLAG_NOEXEC (1 << 2)	/* not executable from device */
>  	__u64	vaddr;				/* Process virtual address */
>  	__u64	iova;				/* IO virtual address */
>  	__u64	size;				/* Size of mapping (bytes) */



