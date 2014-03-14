Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaCNNjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:39:40 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43573 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaCNNji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:39:38 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-31-53230696e2b7
Message-id: <53230695.9080606@samsung.com>
Date: Fri, 14 Mar 2014 14:39:33 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Cho KyongHo <pullip.cho@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 13/27] iommu/exynos: support for device tree
References: <20140314140935.e0652b58ce16591b54d0e10b@samsung.com>
In-reply-to: <20140314140935.e0652b58ce16591b54d0e10b@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e/4Fd1pbMrBBm0TrSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7Bb/eg8yWkxZdJjV4vCb
	dlaLk396GS1m3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGcdmkpOZklqUW6dslcGVc7TQtmCRasfn0ccYGxj8CXYycHBICJhIn/y9jgbDF
	JC7cW8/WxcjFISSwlFFi9v+XzBDOZ0aJD+u6gao4OHgFtCT2LfIEaWARUJX4/eEZE4jNJqAm
	8bnhERuIzQ9UsqbpOthQUYEIibkTN4PFeQUEJX5MvscCMlNEYB2TxLEjO8EcZoHfTBLP3j1m
	BqkSFnCReNB0E8wWEnCUeNNyBczmFHCSuHCjnxXEZhawllg5aRsjhC0vsXnNW+YJjIKzkCyZ
	haRsFpKyBYzMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCYu7LDsbFx6wOMQpwMCrx8J58
	rxgsxJpYVlyZe4hRgoNZSYT35GOlYCHelMTKqtSi/Pii0pzU4kOMTBycUg2MRZE7OFJc5bP5
	Inc8WpF7KGD6ocPsz9yX7jn3fl5h2fr0jzuMTDVYrjxXfWwgWh/jPYHjuICy2cQO88KrlwM/
	uK+9x6CxhuX491kW7dOVv+85YWqrPe+nuO0ax9h7ybv5T/fc0o6asvHas/i/HpaN/n5zTmba
	7brax2P1OPywdz6/WIP4r73pSizFGYmGWsxFxYkAZnDkz5cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On 14.03.2014 06:09, Cho KyongHo wrote:
> This commit adds device tree support for System MMU.
>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>   drivers/iommu/Kconfig        |    5 ++---
>   drivers/iommu/exynos-iommu.c |   21 +++++++++++++++++----
>   2 files changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index df56e4c..22af807 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -178,16 +178,15 @@ config TEGRA_IOMMU_SMMU
>
>   config EXYNOS_IOMMU
>   	bool "Exynos IOMMU Support"
> -	depends on ARCH_EXYNOS && EXYNOS_DEV_SYSMMU
> +	depends on ARCH_EXYNOS
>   	select IOMMU_API
> +	default n
>   	help
>   	  Support for the IOMMU(System MMU) of Samsung Exynos application

nit: There should be a white space before the opening parenthesis.

>   	  processor family. This enables H/W multimedia accellerators to see

typo: s/accellerators/accelerators/

>   	  non-linear physical memory chunks as a linear memory in their
>   	  address spaces
>
> -	  If unsure, say N here.
> -
>   config EXYNOS_IOMMU_DEBUG
>   	bool "Debugging log for Exynos IOMMU"
>   	depends on EXYNOS_IOMMU
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 33b424d..34feb04 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -26,6 +26,7 @@
>   #include <linux/list.h>
>   #include <linux/memblock.h>
>   #include <linux/export.h>
> +#include <linux/of.h>
>
>   #include <asm/cacheflush.h>
>   #include <asm/pgtable.h>
> @@ -497,7 +498,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
>   	read_unlock_irqrestore(&data->lock, flags);
>   }
>
> -static int exynos_sysmmu_probe(struct platform_device *pdev)
> +static int __init exynos_sysmmu_probe(struct platform_device *pdev)
>   {
>   	int irq, ret;
>   	struct device *dev = &pdev->dev;
> @@ -557,11 +558,23 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
>   	return 0;
>   }
>
> -static struct platform_driver exynos_sysmmu_driver = {
> -	.probe		= exynos_sysmmu_probe,
> -	.driver		= {
> +#ifdef CONFIG_OF
> +static struct of_device_id sysmmu_of_match[] __initconst = {
> +	{ .compatible	= "samsung,sysmmu-v1", },
> +	{ .compatible	= "samsung,sysmmu-v2", },
> +	{ .compatible	= "samsung,sysmmu-v3.1", },
> +	{ .compatible	= "samsung,sysmmu-v3.2", },
> +	{ .compatible	= "samsung,sysmmu-v3.3", },

Do you need all these compatible strings? I mean, are there any 
implementation differences that can't be identified by reading IP 
registers, such as REG_MMU_VERSION?

Best regards,
Tomasz
