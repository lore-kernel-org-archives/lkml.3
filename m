Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161079Ab3FTQlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:41:45 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54816 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161031Ab3FTQln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:41:43 -0400
Date: Thu, 20 Jun 2013 09:41:42 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH/RESEND 06/12] msm: iommu: Use clk_set_rate() instead of
 clk_set_min_rate()
Message-ID: <20130620164142.GD6300@codeaurora.org>
References: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
 <1371490999-15501-7-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371490999-15501-7-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sending to correct Joerg address.

On 06/17, Stephen Boyd wrote:
> Calling clk_set_min_rate() is no better than just calling
> clk_set_rate() because MSM clock code already takes care of
> calling the min_rate ops if the clock really needs
> clk_set_min_rate() called on it.
> 
> Cc: Joerg Roedel <joerg.roedel@amd.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/iommu/msm_iommu_dev.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/msm_iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
> index d344f6a..9144a6b 100644
> --- a/drivers/iommu/msm_iommu_dev.c
> +++ b/drivers/iommu/msm_iommu_dev.c
> @@ -29,7 +29,6 @@
>  
>  #include <mach/iommu_hw-8xxx.h>
>  #include <mach/iommu.h>
> -#include <mach/clk.h>
>  
>  struct iommu_ctx_iter_data {
>  	/* input */
> @@ -168,7 +167,7 @@ static int msm_iommu_probe(struct platform_device *pdev)
>  
>  	if (!IS_ERR(iommu_clk))	{
>  		if (clk_get_rate(iommu_clk) == 0)
> -			clk_set_min_rate(iommu_clk, 1);
> +			clk_set_rate(iommu_clk, 1);
>  
>  		ret = clk_prepare_enable(iommu_clk);
>  		if (ret) {
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
