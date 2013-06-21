Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423240Ab3FUQUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:20:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423007Ab3FUQUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:20:54 -0400
Message-ID: <1371831653.30572.126.camel@ul30vt.home>
Subject: Re: [PATCH] vfio: fix documentation
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Fri, 21 Jun 2013 10:20:53 -0600
In-Reply-To: <1371783114-22516-1-git-send-email-aik@ozlabs.ru>
References: <1371783114-22516-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 12:51 +1000, Alexey Kardashevskiy wrote:
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  Documentation/vfio.txt |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/vfio.txt b/Documentation/vfio.txt
> index c55533c..d7993dc 100644
> --- a/Documentation/vfio.txt
> +++ b/Documentation/vfio.txt
> @@ -172,12 +172,12 @@ group and can access them as follows:
>  	struct vfio_device_info device_info = { .argsz = sizeof(device_info) };
>  
>  	/* Create a new container */
> -	container = open("/dev/vfio/vfio, O_RDWR);
> +	container = open("/dev/vfio/vfio", O_RDWR);
>  
>  	if (ioctl(container, VFIO_GET_API_VERSION) != VFIO_API_VERSION)
>  		/* Unknown API version */
>  
> -	if (!ioctl(container, VFIO_CHECK_EXTENSION, VFIO_X86_IOMMU))
> +	if (!ioctl(container, VFIO_CHECK_EXTENSION, VFIO_TYPE1_IOMMU))
>  		/* Doesn't support the IOMMU driver we want. */
>  
>  	/* Open the group */
> @@ -193,7 +193,7 @@ group and can access them as follows:
>  	ioctl(group, VFIO_GROUP_SET_CONTAINER, &container);
>  
>  	/* Enable the IOMMU model we want */
> -	ioctl(container, VFIO_SET_IOMMU, VFIO_X86_IOMMU)
> +	ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_IOMMU)
>  
>  	/* Get addition IOMMU info */
>  	ioctl(container, VFIO_IOMMU_GET_INFO, &iommu_info);


Applied.  Thanks,

Alex

