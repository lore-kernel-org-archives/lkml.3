Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbaIWWVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:21:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756038AbaIWWVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:21:30 -0400
Message-ID: <1411510876.24563.47.camel@ul30vt.home>
Subject: Re: [PATCHv7 05/26] vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC
 flag
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        tech@virtualopensystems.com, kvm@vger.kernel.org,
        christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, eric.auger@linaro.org,
        marc.zyngier@arm.com, "open list:ABI/API" <linux-api@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 23 Sep 2014 16:21:16 -0600
In-Reply-To: <1411483586-29304-6-git-send-email-a.motakis@virtualopensystems.com>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1411483586-29304-6-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 16:46 +0200, Antonios Motakis wrote:
> We introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag to the VFIO dma map call,
> and expose its availability via the capability VFIO_IOMMU_PROT_NOEXEC.
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
> index 6612974..30f630c 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -29,6 +29,7 @@
>   * capability is subject to change as groups are added or removed.
>   */
>  #define VFIO_DMA_CC_IOMMU		4
> +#define VFIO_IOMMU_PROT_NOEXEC		5

Can't we advertise this as a flag bit in vfio_iommu_type1_info instead?
Also, EEH already took 5 as seen immediately below.

>  
>  /* Check if EEH is supported */
>  #define VFIO_EEH			5
> @@ -401,6 +402,7 @@ struct vfio_iommu_type1_dma_map {
>  	__u32	flags;
>  #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
>  #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
> +#define VFIO_DMA_MAP_FLAG_NOEXEC (1 << 2)	/* not executable from device */
>  	__u64	vaddr;				/* Process virtual address */
>  	__u64	iova;				/* IO virtual address */
>  	__u64	size;				/* Size of mapping (bytes) */



