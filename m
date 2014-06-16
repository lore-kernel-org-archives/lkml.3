Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaFPPEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:04:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52155 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbaFPPEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:04:10 -0400
Date: Mon, 16 Jun 2014 16:04:03 +0100
From: Will Deacon <will.deacon@arm.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "a.rigo@virtualopensystems.com" <a.rigo@virtualopensystems.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "kim.phillips@freescale.com" <kim.phillips@freescale.com>,
        "stuart.yoder@freescale.com" <stuart.yoder@freescale.com>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        Joerg Roedel <joro@8bytes.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Shuah Khan <shuah.kh@samsung.com>,
        "Upinder Malhi (umalhi)" <umalhi@cisco.com>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v6 01/20] iommu/arm-smmu: change IOMMU_EXEC to
 IOMMU_NOEXEC
Message-ID: <20140616150403.GO16758@arm.com>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
 <1401987808-23596-2-git-send-email-a.motakis@virtualopensystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401987808-23596-2-git-send-email-a.motakis@virtualopensystems.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 06:03:09PM +0100, Antonios Motakis wrote:
> Exposing the XN flag of the SMMU driver as IOMMU_NOEXEC instead of
> IOMMU_EXEC makes it enforceable, since for IOMMUs that don't support
> the XN flag pages will always be executable.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/iommu/arm-smmu.c | 2 +-
>  include/linux/iommu.h    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index 647c3c7..d5a2200 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1294,7 +1294,7 @@ static int arm_smmu_alloc_init_pte(struct arm_smmu_device *smmu, pmd_t *pmd,
>  	}
>  
>  	/* If no access, create a faulting entry to avoid TLB fills */
> -	if (prot & IOMMU_EXEC)
> +	if (!(prot & IOMMU_NOEXEC))
>  		pteval &= ~ARM_SMMU_PTE_XN;

It's probably simpler to change the logic so that we initialise pteval
without XN set, then set it if IOMMU_NOEXEC is set (rather than set it
by default, then clear it if NOEXEC is not set).

Will
