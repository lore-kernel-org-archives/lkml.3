Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbaIHXO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:14:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbaIHXO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:14:56 -0400
Message-ID: <1410218088.2982.186.camel@ul30vt.home>
Subject: Re: [PATCH 10/12] vfio: Convert to use new iommu_capable() API
 function
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>
Date: Mon, 08 Sep 2014 17:14:48 -0600
In-Reply-To: <1409914384-21191-11-git-send-email-joro@8bytes.org>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
	 <1409914384-21191-11-git-send-email-joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-05 at 12:53 +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Nice, we can do some further simplifications if I no longer need to
create a domain and add properties to it in order to test capabilities,
but that can all be done later.

Acked-by: Alex Williamson <alex.williamson@redhat.com>

> ---
>  drivers/vfio/vfio_iommu_type1.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0734fbe..562f686 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -713,14 +713,14 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	list_add(&group->next, &domain->group_list);
>  
>  	if (!allow_unsafe_interrupts &&
> -	    !iommu_domain_has_cap(domain->domain, IOMMU_CAP_INTR_REMAP)) {
> +	    !iommu_capable(bus, IOMMU_CAP_INTR_REMAP)) {
>  		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
>  		       __func__);
>  		ret = -EPERM;
>  		goto out_detach;
>  	}
>  
> -	if (iommu_domain_has_cap(domain->domain, IOMMU_CAP_CACHE_COHERENCY))
> +	if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
>  		domain->prot |= IOMMU_CACHE;
>  
>  	/*



