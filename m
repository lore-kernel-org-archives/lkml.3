Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaFHKbg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 06:31:36 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:52788 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbaFHKbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 06:31:34 -0400
Date: Sun, 8 Jun 2014 12:31:29 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org, tech@virtualopensystems.com,
        a.rigo@virtualopensystems.com, kvm@vger.kernel.org,
        will.deacon@arm.com, kim.phillips@freescale.com,
        stuart.yoder@freescale.com, eric.auger@linaro.org,
        Joerg Roedel <joro@8bytes.org>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability
 IOMMU_CAP_INTR_REMAP
Message-ID: <20140608103129.GC3279@lvm>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
 <1401987808-23596-5-git-send-email-a.motakis@virtualopensystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401987808-23596-5-git-send-email-a.motakis@virtualopensystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 07:03:12PM +0200, Antonios Motakis wrote:
> With an ARM SMMU, interrupt remapping should always be safe from the
> SMMU's point of view, as it is properly handled by the GIC.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/iommu/arm-smmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index 15ab2af..ff29402 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1544,7 +1544,7 @@ static int arm_smmu_domain_has_cap(struct iommu_domain *domain,
>  	if (smmu_domain->root_cfg.smmu->features & ARM_SMMU_FEAT_COHERENT_WALK)
>  		caps |= IOMMU_CAP_CACHE_COHERENCY;
>  
> -	caps |= IOMMU_CAP_NOEXEC;
> +	caps |= IOMMU_CAP_NOEXEC | IOMMU_CAP_INTR_REMAP;
>  
>  	return !!(cap & caps);
>  }
> -- 
> 1.8.3.2
> 
What does IOMMU_CAP_INTR_REMAP signify exactly?  Is there docs/examples
somewhere I can look at?  (A quick scan of the Linux souce code doesn't
reveal much, and I'm not sure if this is purely MSI related or what...)

Thanks,
-Christoffer
