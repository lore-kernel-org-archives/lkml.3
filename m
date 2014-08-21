Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaHUV5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:57:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306AbaHUV5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:57:36 -0400
Message-ID: <1408658228.2906.21.camel@ul30vt.home>
Subject: Re: [PATCH 2/2] iommu/vt-d: Check return value of
 acpi_bus_get_device()
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <jroedel@suse.de>
Date: Thu, 21 Aug 2014 15:57:08 -0600
In-Reply-To: <1408657045-4979-3-git-send-email-joro@8bytes.org>
References: <1408657045-4979-1-git-send-email-joro@8bytes.org>
	 <1408657045-4979-3-git-send-email-joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-21 at 23:37 +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Checking adev == NULL is not sufficient as
> acpi_bus_get_device() might not touch the value of this
> parameter in an error case, so check the return value
> directly.
> 
> Fixes: ed40356b5fcf1ce28e026ab39c5b2b6939068b50
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/iommu/dmar.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index 60ab474..06d268a 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -678,8 +678,7 @@ static int __init dmar_acpi_dev_scope_init(void)
>  				       andd->device_name);
>  				continue;
>  			}
> -			acpi_bus_get_device(h, &adev);
> -			if (!adev) {
> +			if (acpi_bus_get_device(h, &adev)) {
>  				pr_err("Failed to get device for ACPI object %s\n",
>  				       andd->device_name);
>  				continue;

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

