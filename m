Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbbA1ULv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:11:51 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59202 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbbA1ULR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:11:17 -0500
Date: Wed, 28 Jan 2015 13:32:47 -0600
From: Benoit Parrot <bparrot@ti.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Darren Etheridge <detheridge@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v3] ARM: AM43xx: hwmod: add VPFE hwmod entries
Message-ID: <20150128193247.GH2570@ti.com>
References: <1422260488-380-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1422260488-380-1-git-send-email-prabhakar.csengg@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend/resume is functional with this patch.

Tested-by: Benoit Parrot <bparrot@ti.com>

Lad, Prabhakar <prabhakar.csengg@gmail.com> wrote on Mon [2015-Jan-26 08:21:28 +0000]:
> From: Benoit Parrot <bparrot@ti.com>
> 
> this patch adds VPFE HWMOD data for AM43xx.
> 
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> Signed-off-by: Darren Etheridge <detheridge@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  Changes for v3:
>  a: Dropped OCPIF_SWSUP_IDLE flag from l3 hwmods of vpfe.
>  
>  arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 70 ++++++++++++++++++++++++++++++
>  arch/arm/mach-omap2/prcm43xx.h             |  3 +-
>  2 files changed, 72 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
> index 5c6c841..8543f9f 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
> @@ -514,6 +514,44 @@ static struct omap_hwmod am43xx_dss_rfbi_hwmod = {
>  	},
>  };
>  
> +static struct omap_hwmod_class_sysconfig am43xx_vpfe_sysc = {
> +	.rev_offs       = 0x0,
> +	.sysc_offs      = 0x104,
> +	.sysc_flags     = SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE,
> +	.idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
> +				MSTANDBY_FORCE | MSTANDBY_SMART | MSTANDBY_NO),
> +	.sysc_fields    = &omap_hwmod_sysc_type2,
> +};
> +
> +static struct omap_hwmod_class am43xx_vpfe_hwmod_class = {
> +	.name           = "vpfe",
> +	.sysc           = &am43xx_vpfe_sysc,
> +};
> +
> +static struct omap_hwmod am43xx_vpfe0_hwmod = {
> +	.name           = "vpfe0",
> +	.class          = &am43xx_vpfe_hwmod_class,
> +	.clkdm_name     = "l3s_clkdm",
> +	.prcm           = {
> +		.omap4  = {
> +			.modulemode     = MODULEMODE_SWCTRL,
> +			.clkctrl_offs   = AM43XX_CM_PER_VPFE0_CLKCTRL_OFFSET,
> +		},
> +	},
> +};
> +
> +static struct omap_hwmod am43xx_vpfe1_hwmod = {
> +	.name           = "vpfe1",
> +	.class          = &am43xx_vpfe_hwmod_class,
> +	.clkdm_name     = "l3s_clkdm",
> +	.prcm           = {
> +		.omap4  = {
> +			.modulemode     = MODULEMODE_SWCTRL,
> +			.clkctrl_offs   = AM43XX_CM_PER_VPFE1_CLKCTRL_OFFSET,
> +		},
> +	},
> +};
> +
>  /* Interfaces */
>  static struct omap_hwmod_ocp_if am43xx_l3_main__l4_hs = {
>  	.master		= &am33xx_l3_main_hwmod,
> @@ -788,6 +826,34 @@ static struct omap_hwmod_ocp_if am43xx_l4_ls__dss_rfbi = {
>  	.user		= OCP_USER_MPU | OCP_USER_SDMA,
>  };
>  
> +static struct omap_hwmod_ocp_if am43xx_l3__vpfe0 = {
> +	.master         = &am43xx_vpfe0_hwmod,
> +	.slave          = &am33xx_l3_main_hwmod,
> +	.clk            = "l3_gclk",
> +	.user           = OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +static struct omap_hwmod_ocp_if am43xx_l3__vpfe1 = {
> +	.master         = &am43xx_vpfe1_hwmod,
> +	.slave          = &am33xx_l3_main_hwmod,
> +	.clk            = "l3_gclk",
> +	.user           = OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +static struct omap_hwmod_ocp_if am43xx_l4_ls__vpfe0 = {
> +	.master         = &am33xx_l4_ls_hwmod,
> +	.slave          = &am43xx_vpfe0_hwmod,
> +	.clk            = "l4ls_gclk",
> +	.user           = OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +static struct omap_hwmod_ocp_if am43xx_l4_ls__vpfe1 = {
> +	.master         = &am33xx_l4_ls_hwmod,
> +	.slave          = &am43xx_vpfe1_hwmod,
> +	.clk            = "l4ls_gclk",
> +	.user           = OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
>  static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_ifs[] __initdata = {
>  	&am33xx_l4_wkup__synctimer,
>  	&am43xx_l4_ls__timer8,
> @@ -887,6 +953,10 @@ static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_ifs[] __initdata = {
>  	&am43xx_l4_ls__dss,
>  	&am43xx_l4_ls__dss_dispc,
>  	&am43xx_l4_ls__dss_rfbi,
> +	&am43xx_l3__vpfe0,
> +	&am43xx_l3__vpfe1,
> +	&am43xx_l4_ls__vpfe0,
> +	&am43xx_l4_ls__vpfe1,
>  	NULL,
>  };
>  
> diff --git a/arch/arm/mach-omap2/prcm43xx.h b/arch/arm/mach-omap2/prcm43xx.h
> index ad7b3e9..8aa4c2c 100644
> --- a/arch/arm/mach-omap2/prcm43xx.h
> +++ b/arch/arm/mach-omap2/prcm43xx.h
> @@ -143,5 +143,6 @@
>  #define AM43XX_CM_PER_USB_OTG_SS1_CLKCTRL_OFFSET        0x0268
>  #define AM43XX_CM_PER_USBPHYOCP2SCP1_CLKCTRL_OFFSET	0x05C0
>  #define AM43XX_CM_PER_DSS_CLKCTRL_OFFSET		0x0a20
> -
> +#define AM43XX_CM_PER_VPFE0_CLKCTRL_OFFSET		0x0068
> +#define AM43XX_CM_PER_VPFE1_CLKCTRL_OFFSET		0x0070
>  #endif
> -- 
> 2.1.0
> 
