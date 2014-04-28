Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaD1Ki0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:38:26 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:63775 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbaD1KiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:38:22 -0400
Message-ID: <535E2F96.908@linaro.org>
Date: Mon, 28 Apr 2014 16:08:14 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
CC: kgene.kim@samsung.com, prathyush.k@samsung.com, grundler@chromium.org,
        joro@8bytes.org, tomasz.figa@gmail.com, joshi@samsung.com,
        sachin.kamat@linaro.org, s.nawrocki@samsung.com,
        Varun.Sethi@freescale.com, a.motakis@virtualopensystems.com,
        pullip.cho@samsung.com, t.figa@samsung.com, rahul.sharma@samsung.com
Subject: Re: [PATCH v12 18/31] iommu/exynos: allow having multiple System
 MMUs for a master H/W
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com> <1398584283-22846-19-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1398584283-22846-19-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2014 01:07 PM, Shaik Ameer Basha wrote:
> From: Cho KyongHo <pullip.cho@samsung.com>
> 
> Some master device descriptor like fimc-is which is an abstraction
> of very complex H/W may have multiple System MMUs. For those devices,
> the design of the link between System MMU and its master H/W is needed
> to be reconsidered.
> 
> A link structure, sysmmu_list_data is introduced that provides a link
> to master H/W and that has a pointer to the device descriptor of a
> System MMU. Given a device descriptor of a master H/W, it is possible
> to traverse all System MMUs that must be controlled along with the
> master H/W.
> 
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>

Since you are posting the patches, you should also add your
Signed-of-by.

> ---
>  drivers/iommu/exynos-iommu.c |  545 ++++++++++++++++++++++++++----------------
>  1 file changed, 335 insertions(+), 210 deletions(-)
> 
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index fefedec3..c2e6365 100755
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c

[ ... ]

>  static int sysmmu_pm_genpd_save_state(struct device *dev)
> @@ -1215,7 +1349,7 @@ static int sysmmu_pm_genpd_save_state(struct device *dev)
>  		ret = cb(dev);
>  
>  	if (ret == 0)
> -		sysmmu_save_state(client->sysmmu);
> +		sysmmu_save_state(dev);
>  

client is now unused, remove the variable.

>  	return ret;
>  }
> @@ -1238,13 +1372,13 @@ static int sysmmu_pm_genpd_restore_state(struct device *dev)
>  	if (!cb && dev->driver && dev->driver->pm)
>  		cb = dev->driver->pm->runtime_resume;
>  
> -	sysmmu_restore_state(client->sysmmu);
> +	sysmmu_restore_state(dev);
>  
>  	if (cb)
>  		ret = cb(dev);
>  
>  	if (ret)
> -		sysmmu_save_state(client->sysmmu);
> +		sysmmu_restore_state(dev);
>  

client is now unused, remove the variable.


-- 
Tushar Behera
