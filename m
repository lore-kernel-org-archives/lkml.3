Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaFEUEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:04:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaFEUEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:04:14 -0400
Message-ID: <1401998627.9207.227.camel@ul30vt.home>
Subject: Re: [RFC PATCH v6 02/20] iommu: add capability IOMMU_CAP_NOEXEC
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        eric.auger@linaro.org, Joerg Roedel <joro@8bytes.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Shuah Khan <shuah.kh@samsung.com>,
        "Upinder Malhi (umalhi)" <umalhi@cisco.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Thu, 05 Jun 2014 14:03:47 -0600
In-Reply-To: <1401987808-23596-3-git-send-email-a.motakis@virtualopensystems.com>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1401987808-23596-3-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-05 at 19:03 +0200, Antonios Motakis wrote:
> Some IOMMUs accept an IOMMU_NOEXEC protection flag in addition to
> IOMMU_READ and IOMMU_WRITE. Expose this as an IOMMU capability.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  include/linux/iommu.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index fc464d2..7e152fb 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -57,8 +57,9 @@ struct iommu_domain {
>  	struct iommu_domain_geometry geometry;
>  };
>  
> -#define IOMMU_CAP_CACHE_COHERENCY	0x1
> -#define IOMMU_CAP_INTR_REMAP		0x2	/* isolates device intrs */
> +#define IOMMU_CAP_CACHE_COHERENCY	(1 << 0)
> +#define IOMMU_CAP_INTR_REMAP		(1 << 1) /* isolates device intrs */
> +#define IOMMU_CAP_NOEXEC		(1 << 2) /* IOMMU_NOEXEC flag */
>  
>  /*
>   * Following constraints are specifc to FSL_PAMUV1:

Hmm, was this really intended to be a bitmap?  Why?  Thanks,

Alex

