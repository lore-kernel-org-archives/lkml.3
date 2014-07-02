Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaGBLXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:23:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60626 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbaGBLXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:23:31 -0400
Message-ID: <53B3EBAC.3010800@ti.com>
Date: Wed, 2 Jul 2014 14:23:24 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <tony@atomide.com>, <paul@pwsan.com>, <rnayak@ti.com>
CC: <nm@ti.com>, <kishon@ti.com>, <george.cherian@ti.com>, <balbi@ti.com>,
        <balajitk@ti.com>, <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ARM: DRA7: hwmod: Add OCP2SCP3 module
References: <1403093816-10960-2-git-send-email-rogerq@ti.com> <1403121040-22523-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1403121040-22523-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rajendra,

On 06/18/2014 10:50 PM, Roger Quadros wrote:
> This module is needed for the SATA and PCIe PHYs.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Tested-by: Roger Quadros <rogerq@ti.com>

could you please Ack this one? Thanks.

cheers,
-roger

> ---
> v2:
> - added .main_clk to hwmod.
> - moved interface structure to the right place.
> 
>  arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> index 20b4398..c9daee4 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> @@ -1215,6 +1215,21 @@ static struct omap_hwmod dra7xx_ocp2scp1_hwmod = {
>  	},
>  };
>  
> +/* ocp2scp3 */
> +static struct omap_hwmod dra7xx_ocp2scp3_hwmod = {
> +	.name		= "ocp2scp3",
> +	.class		= &dra7xx_ocp2scp_hwmod_class,
> +	.clkdm_name	= "l3init_clkdm",
> +	.main_clk	= "l4_root_clk_div",
> +	.prcm = {
> +		.omap4 = {
> +			.clkctrl_offs = DRA7XX_CM_L3INIT_OCP2SCP3_CLKCTRL_OFFSET,
> +			.context_offs = DRA7XX_RM_L3INIT_OCP2SCP3_CONTEXT_OFFSET,
> +			.modulemode   = MODULEMODE_HWCTRL,
> +		},
> +	},
> +};
> +
>  /*
>   * 'qspi' class
>   *
> @@ -2326,6 +2341,14 @@ static struct omap_hwmod_ocp_if dra7xx_l4_cfg__ocp2scp1 = {
>  	.user		= OCP_USER_MPU | OCP_USER_SDMA,
>  };
>  
> +/* l4_cfg -> ocp2scp3 */
> +static struct omap_hwmod_ocp_if dra7xx_l4_cfg__ocp2scp3 = {
> +	.master		= &dra7xx_l4_cfg_hwmod,
> +	.slave		= &dra7xx_ocp2scp3_hwmod,
> +	.clk		= "l4_root_clk_div",
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
>  static struct omap_hwmod_addr_space dra7xx_qspi_addrs[] = {
>  	{
>  		.pa_start	= 0x4b300000,
> @@ -2672,6 +2695,7 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
>  	&dra7xx_l4_per1__mmc4,
>  	&dra7xx_l4_cfg__mpu,
>  	&dra7xx_l4_cfg__ocp2scp1,
> +	&dra7xx_l4_cfg__ocp2scp3,
>  	&dra7xx_l3_main_1__qspi,
>  	&dra7xx_l4_cfg__sata,
>  	&dra7xx_l4_cfg__smartreflex_core,
> 

