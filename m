Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbaHFKUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:20:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57290 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768AbaHFKUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:20:22 -0400
Date: Wed, 6 Aug 2014 11:20:25 +0100
From: Will Deacon <will.deacon@arm.com>
To: Hans Wennborg <hans@hanshq.net>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/15] iommu/arm-smmu: fix decimal printf format
 specifiers prefixed with 0x
Message-ID: <20140806102025.GE23882@arm.com>
References: <1407300121-32432-1-git-send-email-hans@hanshq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407300121-32432-1-git-send-email-hans@hanshq.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 05:42:01AM +0100, Hans Wennborg wrote:
> The prefix suggests the number should be printed in hex, so use
> the %x specifier to do that.
> 
> Found by using regex suggested by Joe Perches.
> 
> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  drivers/iommu/arm-smmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index ca18d6d..d84f983 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -623,7 +623,7 @@ static irqreturn_t arm_smmu_context_fault(int irq, void *dev)
>  
>  	if (fsr & FSR_IGN)
>  		dev_err_ratelimited(smmu->dev,
> -				    "Unexpected context fault (fsr 0x%u)\n",
> +				    "Unexpected context fault (fsr 0x%x)\n",
>  				    fsr);
>  
>  	fsynr = readl_relaxed(cb_base + ARM_SMMU_CB_FSYNR0);

Thanks, applied.

Will
