Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3JNMtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:49:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45093 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756028Ab3JNMtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:49:12 -0400
Date: Mon, 14 Oct 2013 13:48:37 +0100
From: Will Deacon <will.deacon@arm.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: Joerg Roedel <joro@8bytes.org>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        "B08248@freescale.com" <B08248@freescale.com>
Subject: Re: [PATCH 2/2] ARM: SMMU: return NULL on error in
 arm_smmu_iova_to_phys
Message-ID: <20131014124837.GD10491@mudshark.cambridge.arm.com>
References: <1381497887-14586-1-git-send-email-a.motakis@virtualopensystems.com>
 <1381497887-14586-2-git-send-email-a.motakis@virtualopensystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381497887-14586-2-git-send-email-a.motakis@virtualopensystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 02:24:47PM +0100, Antonios Motakis wrote:
> The return value of arm_smmu_iova_to_phys is directly passed to the
> user of the IOMMU API via iommu_iova_to_phys; however the ARM SMMU
> driver returns -EINVAL on error, which is not consistent with the
> rest of the drivers implementing the IOMMU API. VFIO also relies on
> the call returning NULL when a page has not been mapped already.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/iommu/arm-smmu.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index 8b71332..fe81b20 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1480,10 +1480,7 @@ static phys_addr_t arm_smmu_iova_to_phys(struct iommu_domain *domain,
>  
>  err_unlock:
>  	spin_unlock(&smmu_domain->lock);
> -	dev_warn(smmu->dev,
> -		 "invalid (corrupt?) page tables detected for iova 0x%llx\n",
> -		 (unsigned long long)iova);
> -	return -EINVAL;
> +	return NULL;

Why are you removing the warning message?

Will
