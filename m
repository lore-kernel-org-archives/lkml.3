Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbaC0TLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 15:11:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009AbaC0TLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 15:11:10 -0400
Message-ID: <1395944407.23473.0.camel@ul30vt.home>
Subject: Re: [PATCH] vfio: always select ANON_INODES
From: Alex Williamson <alex.williamson@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 27 Mar 2014 12:20:07 -0600
In-Reply-To: <11162011.2nHj9XzrYt@wuerfel>
References: <11162011.2nHj9XzrYt@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-25 at 16:50 +0100, Arnd Bergmann wrote:
> The vfio code cannot be built when CONFIG_ANON_INODES is
> disabled, so this enforces the symbol to be enabled through
> Kconfig.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 26b3d9d..af7b204 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -13,6 +13,7 @@ menuconfig VFIO
>  	depends on IOMMU_API
>  	select VFIO_IOMMU_TYPE1 if X86
>  	select VFIO_IOMMU_SPAPR_TCE if (PPC_POWERNV || PPC_PSERIES)
> +	select ANON_INODES
>  	help
>  	  VFIO provides a framework for secure userspace device drivers.
>  	  See Documentation/vfio.txt for more details.
> 

Applied, thanks!

Alex

