Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbaABANN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 19:13:13 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:56612 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbaABANJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 19:13:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Joerg Roedel <joro@8bytes.org>, Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, iommu@lists.linux-foundation.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/7] iommu/omap: Convert to devicetree
Date: Thu, 02 Jan 2014 01:13:42 +0100
Message-ID: <1764051.JiGg1d3s1L@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1387284818-28739-4-git-send-email-florian.vaussard@epfl.ch>
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch> <1387284818-28739-4-git-send-email-florian.vaussard@epfl.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

Thank you for the patch.

On Tuesday 17 December 2013 13:53:34 Florian Vaussard wrote:
> As OMAP2+ is moving to a full DT boot for 3.14, commit 7ce93f3
> "ARM: OMAP2+: Fix more missing data for omap3.dtsi file" adds
> basic DT bits. But the driver is not yet converted, so this will
> not work and driver will not be probed. Convert it!
> 
> Apart from standard bindings, this patch uses 'dma-window' (already
> used by Tegra SMMU) and adds a custom 'ti,#tlb-entries' binding.
> 
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> ---
>  .../devicetree/bindings/iommu/ti,omap-iommu.txt    | 19 ++++++++++++
>  arch/arm/mach-omap2/omap-iommu.c                   |  5 +++
>  drivers/iommu/omap-iommu.c                         | 36 ++++++++++++++++---
>  3 files changed, 55 insertions(+), 5 deletions(-)
>  create mode 100644
> Documentation/devicetree/bindings/iommu/ti,omap-iommu.txt

[snip]

> diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
> index 385bf5e..51efcc4 100644
> --- a/drivers/iommu/omap-iommu.c
> +++ b/drivers/iommu/omap-iommu.c

[snip]

> @@ -1260,11 +1277,20 @@ static int omap_iommu_remove(struct platform_device
> *pdev) return 0;
>  }
> 
> +#if defined(CONFIG_OF)
> +static struct of_device_id omap_iommu_of_match[] = {
> +	{ .compatible = "ti,omap3-mmu-isp" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, omap_iommu_of_match);
> +#endif
> +
>  static struct platform_driver omap_iommu_driver = {
>  	.probe	= omap_iommu_probe,
>  	.remove	= omap_iommu_remove,
>  	.driver	= {
>  		.name	= "omap-iommu",
> +		.of_match_table = omap_iommu_of_match,

If CONFIG_OF isn't defined (pretty unlikely I agree, but a possibility you 
seem to be prepared for nonetheless given the above #if), this will fail to 
compile.

>  	},
>  };

-- 
Regards,

Laurent Pinchart

