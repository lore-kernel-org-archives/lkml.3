Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab3HVCFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:05:13 -0400
Received: from [119.145.14.64] ([119.145.14.64]:55518 "EHLO
	szxga01-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab3HVCFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:05:11 -0400
Message-ID: <5215718F.4060204@huawei.com>
Date: Thu, 22 Aug 2013 10:03:59 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        "'David Brown'" <davidb@codeaurora.org>,
        "'Stephen Boyd'" <sboyd@codeaurora.org>,
        "'Joerg Roedel'" <joro@8bytes.org>, "'Suman Anna'" <s-anna@ti.com>
Subject: Re: [PATCH] iommu: remove unnecessary platform_set_drvdata()
References: <001501ce9eda$5660b2c0$03221840$%han@samsung.com>
In-Reply-To: <001501ce9eda$5660b2c0$03221840$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/22 9:53, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---

It looks good.

Acked-by: Libo Chen <libo.chen@huawei.com>


>  drivers/iommu/msm_iommu_dev.c |    2 --
>  drivers/iommu/omap-iommu.c    |    2 --
>  2 files changed, 4 deletions(-)
> 
> diff --git a/drivers/iommu/msm_iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
> index 0a1c962..08ba497 100644
> --- a/drivers/iommu/msm_iommu_dev.c
> +++ b/drivers/iommu/msm_iommu_dev.c
> @@ -282,7 +282,6 @@ static int msm_iommu_remove(struct platform_device *pdev)
>  		clk_put(drv->pclk);
>  		memset(drv, 0, sizeof(*drv));
>  		kfree(drv);
> -		platform_set_drvdata(pdev, NULL);
>  	}
>  	return 0;
>  }
> @@ -366,7 +365,6 @@ static int msm_iommu_ctx_remove(struct platform_device *pdev)
>  	if (drv) {
>  		memset(drv, 0, sizeof(struct msm_iommu_ctx_drvdata));
>  		kfree(drv);
> -		platform_set_drvdata(pdev, NULL);
>  	}
>  	return 0;
>  }
> diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
> index 0ba3766..bcd78a7 100644
> --- a/drivers/iommu/omap-iommu.c
> +++ b/drivers/iommu/omap-iommu.c
> @@ -1008,8 +1008,6 @@ static int omap_iommu_remove(struct platform_device *pdev)
>  	struct resource *res;
>  	struct omap_iommu *obj = platform_get_drvdata(pdev);
>  
> -	platform_set_drvdata(pdev, NULL);
> -
>  	iopgtable_clear_entry_all(obj);
>  
>  	irq = platform_get_irq(pdev, 0);
> 


