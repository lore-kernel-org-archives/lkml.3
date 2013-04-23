Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3DWMin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 08:38:43 -0400
Received: from 8bytes.org ([85.214.48.195]:54237 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966Ab3DWMim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 08:38:42 -0400
Date: Tue, 23 Apr 2013 14:38:40 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] iommu/amd: fix error return code in
 early_amd_iommu_init()
Message-ID: <20130423123839.GB2589@8bytes.org>
References: <CAPgLHd9shRmpq__avgWPupFvcY2LNuEtPs9bG=AVpBx7BpLZTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd9shRmpq__avgWPupFvcY2LNuEtPs9bG=AVpBx7BpLZTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr 23 14:38:41 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 517680d123678700874704
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 10:47:44AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -ENOMEM int the memory alloc error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/iommu/amd_iommu_init.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index 9110c1c..a55ec50 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -1860,6 +1860,7 @@ static int __init early_amd_iommu_init(void)
>  		 * Interrupt remapping enabled, create kmem_cache for the
>  		 * remapping tables.
>  		 */
> +		ret = -ENOMEM;
>  		amd_iommu_irq_cache = kmem_cache_create("irq_remap_cache",
>  				MAX_IRQS_PER_TABLE * sizeof(u32),
>  				IRQ_TABLE_ALIGNMENT,
>

Applied to x86/amd, thanks.

