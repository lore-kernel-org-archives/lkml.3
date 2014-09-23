Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbaIWXLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 19:11:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050AbaIWXLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 19:11:36 -0400
Message-ID: <1411513877.24563.62.camel@ul30vt.home>
Subject: Re: [PATCHv7 13/26] vfio: amba: add the VFIO for AMBA devices
 module to Kconfig
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        tech@virtualopensystems.com, kvm@vger.kernel.org,
        christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, eric.auger@linaro.org,
        marc.zyngier@arm.com, open list <linux-kernel@vger.kernel.org>
Date: Tue, 23 Sep 2014 17:11:17 -0600
In-Reply-To: <1411483586-29304-14-git-send-email-a.motakis@virtualopensystems.com>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1411483586-29304-14-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 16:46 +0200, Antonios Motakis wrote:
> Enable building the VFIO AMBA driver. VFIO_AMBA depends on VFIO_PLATFORM,
> since it is sharing a portion of the code, and it is essentially implemented
> as a platform device whose resources are discovered via AMBA specific APIs
> in the kernel.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/vfio/platform/Kconfig  | 10 ++++++++++
>  drivers/vfio/platform/Makefile |  4 ++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
> index c51af17..8b97786 100644
> --- a/drivers/vfio/platform/Kconfig
> +++ b/drivers/vfio/platform/Kconfig
> @@ -7,3 +7,13 @@ config VFIO_PLATFORM
>  	  framework.
>  
>  	  If you don't know what to do here, say N.
> +
> +config VFIO_AMBA
> +	tristate "VFIO support for AMBA devices"
> +	depends on VFIO && VFIO_PLATFORM && EVENTFD && ARM_AMBA

nit, VFIO_PLATFORM already depends on VFIO && EVENTFD

> +	help
> +	  Support for ARM AMBA devices with VFIO. This is required to make
> +	  use of ARM AMBA devices present on the system using the VFIO
> +	  framework.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
> index 279862b..1957170 100644
> --- a/drivers/vfio/platform/Makefile
> +++ b/drivers/vfio/platform/Makefile
> @@ -2,3 +2,7 @@
>  vfio-platform-y := vfio_platform.o vfio_platform_common.o
>  
>  obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
> +
> +vfio-amba-y := vfio_amba.o
> +
> +obj-$(CONFIG_VFIO_AMBA) += vfio-amba.o



