Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbaGCILE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:11:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55325 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702AbaGCIK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:10:59 -0400
Message-ID: <53B50F5B.7010505@ti.com>
Date: Thu, 3 Jul 2014 13:37:55 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm: dra7xx: Add hwmod data for pcie1 and pcie2 subsystems
References: <1403719366-9656-1-git-send-email-kishon@ti.com> <1403719366-9656-3-git-send-email-kishon@ti.com>
In-Reply-To: <1403719366-9656-3-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2014 11:32 PM, Kishon Vijay Abraham I wrote:
> Added hwmod data for pcie1 and pcie2 subsystem present in DRA7xx SOC.
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Tested-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
> Please find the bootlog with these hwmod patches
> http://paste.ubuntu.com/7701601/
>  arch/arm/mach-omap2/omap_hwmod_7xx_data.c |   55 +++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> index 6ff40a6..934aa9d 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> @@ -1290,6 +1290,43 @@ static struct omap_hwmod dra7xx_ocp2scp3_hwmod = {
>  };
>  
>  /*
> + * 'PCIE' class
> + *
> + */
> +
> +static struct omap_hwmod_class dra7xx_pcie_hwmod_class = {
> +	.name	= "pcie",
> +};
> +
> +/* pcie1 */
> +static struct omap_hwmod dra7xx_pcie1_hwmod = {
> +	.name		= "pcie1",
> +	.class		= &dra7xx_pcie_hwmod_class,
> +	.clkdm_name	= "l3init_clkdm",

The TRM tells me it belongs to 'pcie_clkdm' instead. Can you please recheck?

> +	.main_clk	= "l4_root_clk_div",
> +	.prcm = {
> +		.omap4 = {
> +			.clkctrl_offs	= DRA7XX_CM_PCIE_CLKSTCTRL_OFFSET,
> +			.modulemode	= MODULEMODE_SWCTRL,
> +		},
> +	},
> +};
> +
> +/* pcie2 */
> +static struct omap_hwmod dra7xx_pcie2_hwmod = {
> +	.name		= "pcie2",
> +	.class		= &dra7xx_pcie_hwmod_class,
> +	.clkdm_name	= "l3init_clkdm",
> +	.main_clk	= "l4_root_clk_div",
> +	.prcm = {
> +		.omap4 = {
> +			.clkctrl_offs = DRA7XX_CM_PCIE_CLKSTCTRL_OFFSET,
> +			.modulemode   = MODULEMODE_SWCTRL,
> +		},
> +	},
> +};
> +
> +/*
>   * 'PCIE PHY' class
>   *
>   */
> @@ -2448,6 +2485,22 @@ static struct omap_hwmod_ocp_if dra7xx_l4_cfg__ocp2scp1 = {
>  	.user		= OCP_USER_MPU | OCP_USER_SDMA,
>  };
>  
> +/* l4_cfg -> pcie1 */

There seems to be a slave port on l3_init as well which seems to be missing?

Refer to 'Figure 24-157. PCIe Controllers Integration' of TRM version P.

regards,
Rajendra

> +static struct omap_hwmod_ocp_if dra7xx_l4_cfg__pcie1 = {
> +	.master		= &dra7xx_l4_cfg_hwmod,
> +	.slave		= &dra7xx_pcie1_hwmod,
> +	.clk		= "l4_root_clk_div",
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +/* l4_cfg -> pcie2 */
> +static struct omap_hwmod_ocp_if dra7xx_l4_cfg__pcie2 = {
> +	.master		= &dra7xx_l4_cfg_hwmod,
> +	.slave		= &dra7xx_pcie2_hwmod,
> +	.clk		= "l4_root_clk_div",
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
>  /* l4_cfg -> pcie1 phy */
>  static struct omap_hwmod_ocp_if dra7xx_l4_cfg__pcie1_phy = {
>  	.master		= &dra7xx_l4_cfg_hwmod,
> @@ -2813,6 +2866,8 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
>  	&dra7xx_l4_cfg__mpu,
>  	&dra7xx_l4_cfg__ocp2scp1,
>  	&dra7xx_l4_cfg__ocp2scp3,
> +	&dra7xx_l4_cfg__pcie1,
> +	&dra7xx_l4_cfg__pcie2,
>  	&dra7xx_l4_cfg__pcie1_phy,
>  	&dra7xx_l4_cfg__pcie2_phy,
>  	&dra7xx_l3_main_1__qspi,
> 

