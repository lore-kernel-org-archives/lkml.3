Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbaGCIHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:07:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43966 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756935AbaGCIHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:07:37 -0400
Message-ID: <53B50E8F.7010604@ti.com>
Date: Thu, 3 Jul 2014 13:34:31 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: dra7xx: Add hwmod data for pcie1 phy and pcie2
 phy
References: <1403719366-9656-1-git-send-email-kishon@ti.com> <1403719366-9656-2-git-send-email-kishon@ti.com>
In-Reply-To: <1403719366-9656-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2014 11:32 PM, Kishon Vijay Abraham I wrote:
> Added hwmod data for pcie1 and pcie2 phy present in DRA7xx SOC.
> Also added the missing CLKCTRL OFFSET macro and CONTEXT OFFSET macro
> for pcie1 phy and pcie2 phy.
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Tested-by: Kishon Vijay Abraham I <kishon@ti.com>

Looks good to me, feel free to add
Reviewed-by: Rajendra Nayak <rnayak@ti.com>

> ---
> Please find the bootlog with these hwmod patches
> http://paste.ubuntu.com/7701601/
>  arch/arm/mach-omap2/cm2_7xx.h             |    4 ++
>  arch/arm/mach-omap2/omap_hwmod_7xx_data.c |   57 +++++++++++++++++++++++++++++
>  arch/arm/mach-omap2/prm7xx.h              |    4 ++
>  3 files changed, 65 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/cm2_7xx.h b/arch/arm/mach-omap2/cm2_7xx.h
> index 9ad7594..e966e3a 100644
> --- a/arch/arm/mach-omap2/cm2_7xx.h
> +++ b/arch/arm/mach-omap2/cm2_7xx.h
> @@ -357,6 +357,10 @@
>  #define DRA7XX_CM_L3INIT_SATA_CLKCTRL				DRA7XX_CM_CORE_REGADDR(DRA7XX_CM_CORE_L3INIT_INST, 0x0088)
>  #define DRA7XX_CM_PCIE_CLKSTCTRL_OFFSET				0x00a0
>  #define DRA7XX_CM_PCIE_STATICDEP_OFFSET				0x00a4
> +#define DRA7XX_CM_L3INIT_PCIESS1_CLKCTRL_OFFSET			0x00b0
> +#define DRA7XX_CM_L3INIT_PCIESS1_CLKCTRL			DRA7XX_CM_CORE_REGADDR(DRA7XX_CM_CORE_L3INIT_INST, 0x00b0)
> +#define DRA7XX_CM_L3INIT_PCIESS2_CLKCTRL_OFFSET			0x00b8
> +#define DRA7XX_CM_L3INIT_PCIESS2_CLKCTRL			DRA7XX_CM_CORE_REGADDR(DRA7XX_CM_CORE_L3INIT_INST, 0x00b8)
>  #define DRA7XX_CM_GMAC_CLKSTCTRL_OFFSET				0x00c0
>  #define DRA7XX_CM_GMAC_STATICDEP_OFFSET				0x00c4
>  #define DRA7XX_CM_GMAC_DYNAMICDEP_OFFSET			0x00c8
> diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> index 3deb76e..6ff40a6 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> @@ -1290,6 +1290,45 @@ static struct omap_hwmod dra7xx_ocp2scp3_hwmod = {
>  };
>  
>  /*
> + * 'PCIE PHY' class
> + *
> + */
> +
> +static struct omap_hwmod_class dra7xx_pcie_phy_hwmod_class = {
> +	.name	= "pcie-phy",
> +};
> +
> +/* pcie1 phy */
> +static struct omap_hwmod dra7xx_pcie1_phy_hwmod = {
> +	.name		= "pcie1-phy",
> +	.class		= &dra7xx_pcie_phy_hwmod_class,
> +	.clkdm_name	= "l3init_clkdm",
> +	.main_clk	= "l4_root_clk_div",
> +	.prcm = {
> +		.omap4 = {
> +			.clkctrl_offs = DRA7XX_CM_L3INIT_PCIESS1_CLKCTRL_OFFSET,
> +			.context_offs = DRA7XX_RM_L3INIT_PCIESS1_CONTEXT_OFFSET,
> +			.modulemode   = MODULEMODE_SWCTRL,
> +		},
> +	},
> +};
> +
> +/* pcie2 phy */
> +static struct omap_hwmod dra7xx_pcie2_phy_hwmod = {
> +	.name		= "pcie2-phy",
> +	.class		= &dra7xx_pcie_phy_hwmod_class,
> +	.clkdm_name	= "l3init_clkdm",
> +	.main_clk	= "l4_root_clk_div",
> +	.prcm = {
> +		.omap4 = {
> +			.clkctrl_offs = DRA7XX_CM_L3INIT_PCIESS2_CLKCTRL_OFFSET,
> +			.context_offs = DRA7XX_RM_L3INIT_PCIESS2_CONTEXT_OFFSET,
> +			.modulemode   = MODULEMODE_SWCTRL,
> +		},
> +	},
> +};
> +
> +/*
>   * 'qspi' class
>   *
>   */
> @@ -2409,6 +2448,22 @@ static struct omap_hwmod_ocp_if dra7xx_l4_cfg__ocp2scp1 = {
>  	.user		= OCP_USER_MPU | OCP_USER_SDMA,
>  };
>  
> +/* l4_cfg -> pcie1 phy */
> +static struct omap_hwmod_ocp_if dra7xx_l4_cfg__pcie1_phy = {
> +	.master		= &dra7xx_l4_cfg_hwmod,
> +	.slave		= &dra7xx_pcie1_phy_hwmod,
> +	.clk		= "l4_root_clk_div",
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +/* l4_cfg -> pcie2 phy */
> +static struct omap_hwmod_ocp_if dra7xx_l4_cfg__pcie2_phy = {
> +	.master		= &dra7xx_l4_cfg_hwmod,
> +	.slave		= &dra7xx_pcie2_phy_hwmod,
> +	.clk		= "l4_root_clk_div",
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
>  static struct omap_hwmod_addr_space dra7xx_qspi_addrs[] = {
>  	{
>  		.pa_start	= 0x4b300000,
> @@ -2758,6 +2813,8 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
>  	&dra7xx_l4_cfg__mpu,
>  	&dra7xx_l4_cfg__ocp2scp1,
>  	&dra7xx_l4_cfg__ocp2scp3,
> +	&dra7xx_l4_cfg__pcie1_phy,
> +	&dra7xx_l4_cfg__pcie2_phy,
>  	&dra7xx_l3_main_1__qspi,
>  	&dra7xx_l4_cfg__sata,
>  	&dra7xx_l4_cfg__smartreflex_core,
> diff --git a/arch/arm/mach-omap2/prm7xx.h b/arch/arm/mach-omap2/prm7xx.h
> index d92a840..4bb50fbf 100644
> --- a/arch/arm/mach-omap2/prm7xx.h
> +++ b/arch/arm/mach-omap2/prm7xx.h
> @@ -374,6 +374,10 @@
>  #define DRA7XX_RM_L3INIT_IEEE1500_2_OCP_CONTEXT_OFFSET		0x007c
>  #define DRA7XX_PM_L3INIT_SATA_WKDEP_OFFSET			0x0088
>  #define DRA7XX_RM_L3INIT_SATA_CONTEXT_OFFSET			0x008c
> +#define DRA7XX_PM_L3INIT_PCIESS1_WKDEP_OFFSET			0x00b0
> +#define DRA7XX_RM_L3INIT_PCIESS1_CONTEXT_OFFSET		0x00b4
> +#define DRA7XX_PM_L3INIT_PCIESS2_WKDEP_OFFSET			0x00b8
> +#define DRA7XX_RM_L3INIT_PCIESS2_CONTEXT_OFFSET		0x00bc
>  #define DRA7XX_RM_GMAC_GMAC_CONTEXT_OFFSET			0x00d4
>  #define DRA7XX_RM_L3INIT_OCP2SCP1_CONTEXT_OFFSET		0x00e4
>  #define DRA7XX_RM_L3INIT_OCP2SCP3_CONTEXT_OFFSET		0x00ec
> 

