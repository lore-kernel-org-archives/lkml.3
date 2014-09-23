Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbaIWPDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:03:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51694 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756214AbaIWO6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:58:15 -0400
Date: Tue, 23 Sep 2014 15:58:16 +0100
From: Will Deacon <will.deacon@arm.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "kim.phillips@freescale.com" <kim.phillips@freescale.com>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <shuah.kh@samsung.com>, Thierry Reding <treding@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        "Upinder Malhi (umalhi)" <umalhi@cisco.com>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv7 01/26] iommu/arm-smmu: change IOMMU_EXEC to IOMMU_NOEXEC
Message-ID: <20140923145816.GE28608@arm.com>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
 <1411483586-29304-2-git-send-email-a.motakis@virtualopensystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411483586-29304-2-git-send-email-a.motakis@virtualopensystems.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonios,

On Tue, Sep 23, 2014 at 03:46:00PM +0100, Antonios Motakis wrote:
> Exposing the XN flag of the SMMU driver as IOMMU_NOEXEC instead of
> IOMMU_EXEC makes it enforceable, since for IOMMUs that don't support
> the XN flag pages will always be executable.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/iommu/arm-smmu.c | 9 +++++----
>  include/linux/iommu.h    | 2 +-
>  2 files changed, 6 insertions(+), 5 deletions(-)

[...]

> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 20f9a52..e1a644c 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -27,7 +27,7 @@
>  #define IOMMU_READ	(1 << 0)
>  #define IOMMU_WRITE	(1 << 1)
>  #define IOMMU_CACHE	(1 << 2) /* DMA cache coherency */
> -#define IOMMU_EXEC	(1 << 3)
> +#define IOMMU_NOEXEC	(1 << 3)

This hunk needs to be a separate patch merged by Joerg before I can take the
arm-smmu part (which looks fine).

Will
