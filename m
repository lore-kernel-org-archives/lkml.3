Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbaJaUE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:04:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351AbaJaUE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:04:26 -0400
Message-ID: <1414785851.27420.334.camel@ul30vt.home>
Subject: Re: [PATCH v2 1/6] vfio: implement iommu driver capabilities with
 an enum
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Fri, 31 Oct 2014 14:04:11 -0600
In-Reply-To: <1414433155-31600-2-git-send-email-a.motakis@virtualopensystems.com>
References: <1414433155-31600-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1414433155-31600-2-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 19:05 +0100, Antonios Motakis wrote:
> Currently a VFIO driver's IOMMU capabilities are encoded as a series of
> numerical defines. Replace this with an enum for future maintainability.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  include/uapi/linux/vfio.h | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 6612974..1e39842 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -19,19 +19,18 @@
>  
>  /* Kernel & User level defines for VFIO IOCTLs. */
>  
> -/* Extensions */
> -
> -#define VFIO_TYPE1_IOMMU		1
> -#define VFIO_SPAPR_TCE_IOMMU		2
> -#define VFIO_TYPE1v2_IOMMU		3
>  /*
> - * IOMMU enforces DMA cache coherence (ex. PCIe NoSnoop stripping).  This
> - * capability is subject to change as groups are added or removed.
> + * Capabilities exposed by the VFIO IOMMU driver. Some capabilities are subject
> + * to change as groups are added or removed.
>   */
> -#define VFIO_DMA_CC_IOMMU		4
> -
> -/* Check if EEH is supported */
> -#define VFIO_EEH			5
> +enum vfio_iommu_cap {
> +	VFIO_TYPE1_IOMMU	= 1,
> +	VFIO_SPAPR_TCE_IOMMU	= 2,
> +	VFIO_TYPE1v2_IOMMU	= 3,
> +	VFIO_DMA_CC_IOMMU	= 4, /* IOMMU enforces DMA cache coherence
> +					(ex. PCIe NoSnoop stripping) */
> +	VFIO_EEH		= 5, /* Check if EEH is supported */
> +};

Your code base is a little out of date, you're missing:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/include/uapi/linux/vfio.h?id=f5c9ecebaf2a2c9381973798e389cc019dd983e0

I think the logic looks ok in the rest, but you'll need to use index 7
and the above commit touched the type1 c file as well so you may need to
adjustment there too.  Thanks,

Alex
>  
>  /*
>   * The IOCTL interface is designed for extensibility by embedding the



