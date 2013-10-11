Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab3JKK1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:27:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47822 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757407Ab3JKK1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:27:14 -0400
Date: Fri, 11 Oct 2013 11:26:29 +0100
From: Will Deacon <will.deacon@arm.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH 33/34] iommu/arm-smmu: handle pgtable_page_ctor() fail
Message-ID: <20131011102629.GB14732@mudshark.cambridge.arm.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1381428359-14843-34-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381428359-14843-34-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 07:05:58PM +0100, Kirill A. Shutemov wrote:
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> ---
>  drivers/iommu/arm-smmu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index f417e89e1e..2b256a5075 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1211,7 +1211,10 @@ static int arm_smmu_alloc_init_pte(struct arm_smmu_device *smmu, pmd_t *pmd,
>  
>  		arm_smmu_flush_pgtable(smmu, page_address(table),
>  				       ARM_SMMU_PTE_HWTABLE_SIZE);
> -		pgtable_page_ctor(table);
> +		if (!pgtable_page_ctor(table)) {
> +			__free_page(table);
> +			return -ENOMEM;
> +		}
>  		pmd_populate(NULL, pmd, table);
>  		arm_smmu_flush_pgtable(smmu, pmd, sizeof(*pmd));
>  	}

  Acked-by: Will Deacon <will.deacon@arm.com>

I have quite a few changes queued for this driver, but it doesn't look like
you'll get a conflict with the iommu tree.

Will
