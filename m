Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab3BLG6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 01:58:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42245 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949Ab3BLG6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 01:58:46 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Paul Walmsley <paul@pwsan.com>
CC: "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Subject: RE: [PATCH 1/7] ARM: OMAP: AM33xx hwmod: Corrects PWM subsystem
 HWMOD entries
Thread-Topic: [PATCH 1/7] ARM: OMAP: AM33xx hwmod: Corrects PWM subsystem
 HWMOD entries
Thread-Index: AQHN6Oyo/Xhgm7VidUSkA2V/5IJ8Ephv7sIAgAYbI9A=
Date: Tue, 12 Feb 2013 06:57:37 +0000
Deferred-Delivery: Tue, 12 Feb 2013 06:57:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA73548@DBDE01.ent.ti.com>
References: <1357133094-30806-1-git-send-email-avinashphilip@ti.com>
 <1357133094-30806-2-git-send-email-avinashphilip@ti.com>
 <alpine.DEB.2.00.1302081507480.28008@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1302081507480.28008@utopia.booyaka.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 20:40:18, Paul Walmsley wrote:
> Hi
> 
> On Wed, 2 Jan 2013, Philip Avinash wrote:
> 
> > EQEP entry is HWMOD entry is not present in HWMOD entry.
> 
> Patch descriptions need to make sense.  This one does not.  I've fixed it 
> for you this time, but please take more care in the future.
> 

Thanks for applying this patch & I will take care of the patch description
details.

Thanks
Avinash

> 
> - Paul
> 
> 
> From: Philip Avinash <avinashphilip@ti.com>
> Date: Wed, 2 Jan 2013 18:54:48 +0530
> Subject: [PATCH] ARM: OMAP: AM33xx hwmod: Corrects PWM subsystem HWMOD
>  entries
> 
> EQEP IP block integration data is not present in HWMOD data. Also
> address ranges specified for EACP & EHRPWM are not correct & HWMOD
> flags of ADDR_TYPE_RT are added to PWM subsystem register address
> space. This patch:
> 1. Corrects register address mapping for ECAP & EHRPWM
> 2. Removes  HWMOD flags in PWM submodule register address space.
> 3. Adds EQEP HWMOD entries.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> [paul@pwsan.com: tweaked patch description]
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> ---
>  arch/arm/mach-omap2/omap_hwmod_33xx_data.c |  158 +++++++++++++++++++++++++---
>  1 file changed, 145 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> index 9e34d4c..4b1cc4d 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> @@ -784,7 +784,7 @@ static struct omap_hwmod am33xx_elm_hwmod = {
>  };
>  
>  /*
> - * 'epwmss' class: ecap0,1,2,  ehrpwm0,1,2
> + * 'epwmss' class: ehrpwm0,1,2 eqep0,1,2 ecap0,1,2
>   */
>  static struct omap_hwmod_class_sysconfig am33xx_epwmss_sysc = {
>  	.rev_offs	= 0x0,
> @@ -864,6 +864,66 @@ static struct omap_hwmod am33xx_ehrpwm2_hwmod = {
>  	},
>  };
>  
> +/* eqep0 */
> +static struct omap_hwmod_irq_info am33xx_eqep0_irqs[] = {
> +	{ .irq = 79 + OMAP_INTC_START, },
> +	{ .irq = -1 },
> +};
> +
> +static struct omap_hwmod am33xx_eqep0_hwmod = {
> +	.name		= "eqep0",
> +	.class		= &am33xx_epwmss_hwmod_class,
> +	.clkdm_name	= "l4ls_clkdm",
> +	.mpu_irqs	= am33xx_eqep0_irqs,
> +	.main_clk	= "l4ls_gclk",
> +	.prcm		= {
> +		.omap4	= {
> +			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS0_CLKCTRL_OFFSET,
> +			.modulemode	= MODULEMODE_SWCTRL,
> +		},
> +	},
> +};
> +
> +/* eqep1 */
> +static struct omap_hwmod_irq_info am33xx_eqep1_irqs[] = {
> +	{ .irq = 88 + OMAP_INTC_START, },
> +	{ .irq = -1 },
> +};
> +
> +static struct omap_hwmod am33xx_eqep1_hwmod = {
> +	.name		= "eqep1",
> +	.class		= &am33xx_epwmss_hwmod_class,
> +	.clkdm_name	= "l4ls_clkdm",
> +	.mpu_irqs	= am33xx_eqep1_irqs,
> +	.main_clk	= "l4ls_gclk",
> +	.prcm		= {
> +		.omap4	= {
> +			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS1_CLKCTRL_OFFSET,
> +			.modulemode	= MODULEMODE_SWCTRL,
> +		},
> +	},
> +};
> +
> +/* eqep2 */
> +static struct omap_hwmod_irq_info am33xx_eqep2_irqs[] = {
> +	{ .irq = 89 + OMAP_INTC_START, },
> +	{ .irq = -1 },
> +};
> +
> +static struct omap_hwmod am33xx_eqep2_hwmod = {
> +	.name		= "eqep2",
> +	.class		= &am33xx_epwmss_hwmod_class,
> +	.clkdm_name	= "l4ls_clkdm",
> +	.mpu_irqs	= am33xx_eqep2_irqs,
> +	.main_clk	= "l4ls_gclk",
> +	.prcm		= {
> +		.omap4	= {
> +			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS2_CLKCTRL_OFFSET,
> +			.modulemode	= MODULEMODE_SWCTRL,
> +		},
> +	},
> +};
> +
>  /* ecap0 */
>  static struct omap_hwmod_irq_info am33xx_ecap0_irqs[] = {
>  	{ .irq = 31 + OMAP_INTC_START, },
> @@ -2559,8 +2619,7 @@ static struct omap_hwmod_addr_space am33xx_ehrpwm0_addr_space[] = {
>  	},
>  	{
>  		.pa_start	= 0x48300200,
> -		.pa_end		= 0x48300200 + SZ_256 - 1,
> -		.flags		= ADDR_TYPE_RT
> +		.pa_end		= 0x48300200 + SZ_128 - 1,
>  	},
>  	{ }
>  };
> @@ -2585,8 +2644,7 @@ static struct omap_hwmod_addr_space am33xx_ehrpwm1_addr_space[] = {
>  	},
>  	{
>  		.pa_start	= 0x48302200,
> -		.pa_end		= 0x48302200 + SZ_256 - 1,
> -		.flags		= ADDR_TYPE_RT
> +		.pa_end		= 0x48302200 + SZ_128 - 1,
>  	},
>  	{ }
>  };
> @@ -2611,8 +2669,7 @@ static struct omap_hwmod_addr_space am33xx_ehrpwm2_addr_space[] = {
>  	},
>  	{
>  		.pa_start	= 0x48304200,
> -		.pa_end		= 0x48304200 + SZ_256 - 1,
> -		.flags		= ADDR_TYPE_RT
> +		.pa_end		= 0x48304200 + SZ_128 - 1,
>  	},
>  	{ }
>  };
> @@ -2629,6 +2686,81 @@ static struct omap_hwmod_ocp_if am33xx_l4_ls__ehrpwm2 = {
>   * Splitting the resources to handle access of PWMSS config space
>   * and module specific part independently
>   */
> +static struct omap_hwmod_addr_space am33xx_eqep0_addr_space[] = {
> +	{
> +		.pa_start	= 0x48300000,
> +		.pa_end		= 0x48300000 + SZ_16 - 1,
> +		.flags		= ADDR_TYPE_RT
> +	},
> +	{
> +		.pa_start	= 0x48300180,
> +		.pa_end		= 0x48300180 + SZ_128 - 1,
> +	},
> +	{ }
> +};
> +
> +static struct omap_hwmod_ocp_if am33xx_l4_ls__eqep0 = {
> +	.master		= &am33xx_l4_ls_hwmod,
> +	.slave		= &am33xx_eqep0_hwmod,
> +	.clk		= "l4ls_gclk",
> +	.addr		= am33xx_eqep0_addr_space,
> +	.user		= OCP_USER_MPU,
> +};
> +
> +/*
> + * Splitting the resources to handle access of PWMSS config space
> + * and module specific part independently
> + */
> +static struct omap_hwmod_addr_space am33xx_eqep1_addr_space[] = {
> +	{
> +		.pa_start	= 0x48302000,
> +		.pa_end		= 0x48302000 + SZ_16 - 1,
> +		.flags		= ADDR_TYPE_RT
> +	},
> +	{
> +		.pa_start	= 0x48302180,
> +		.pa_end		= 0x48302180 + SZ_128 - 1,
> +	},
> +	{ }
> +};
> +
> +static struct omap_hwmod_ocp_if am33xx_l4_ls__eqep1 = {
> +	.master		= &am33xx_l4_ls_hwmod,
> +	.slave		= &am33xx_eqep1_hwmod,
> +	.clk		= "l4ls_gclk",
> +	.addr		= am33xx_eqep1_addr_space,
> +	.user		= OCP_USER_MPU,
> +};
> +
> +/*
> + * Splitting the resources to handle access of PWMSS config space
> + * and module specific part independently
> + */
> +static struct omap_hwmod_addr_space am33xx_eqep2_addr_space[] = {
> +	{
> +		.pa_start	= 0x48304000,
> +		.pa_end		= 0x48304000 + SZ_16 - 1,
> +		.flags		= ADDR_TYPE_RT
> +	},
> +	{
> +		.pa_start	= 0x48304180,
> +		.pa_end		= 0x48304180 + SZ_128 - 1,
> +	},
> +	{ }
> +};
> +
> +static struct omap_hwmod_ocp_if am33xx_l4_ls__eqep2 = {
> +	.master		= &am33xx_l4_ls_hwmod,
> +	.slave		= &am33xx_eqep2_hwmod,
> +	.clk		= "l4ls_gclk",
> +	.addr		= am33xx_eqep2_addr_space,
> +	.user		= OCP_USER_MPU,
> +};
> +
> +/*
> + * Splitting the resources to handle access of PWMSS config space
> + * and module specific part independently
> + */
>  static struct omap_hwmod_addr_space am33xx_ecap0_addr_space[] = {
>  	{
>  		.pa_start	= 0x48300000,
> @@ -2637,8 +2769,7 @@ static struct omap_hwmod_addr_space am33xx_ecap0_addr_space[] = {
>  	},
>  	{
>  		.pa_start	= 0x48300100,
> -		.pa_end		= 0x48300100 + SZ_256 - 1,
> -		.flags		= ADDR_TYPE_RT
> +		.pa_end		= 0x48300100 + SZ_128 - 1,
>  	},
>  	{ }
>  };
> @@ -2663,8 +2794,7 @@ static struct omap_hwmod_addr_space am33xx_ecap1_addr_space[] = {
>  	},
>  	{
>  		.pa_start	= 0x48302100,
> -		.pa_end		= 0x48302100 + SZ_256 - 1,
> -		.flags		= ADDR_TYPE_RT
> +		.pa_end		= 0x48302100 + SZ_128 - 1,
>  	},
>  	{ }
>  };
> @@ -2689,8 +2819,7 @@ static struct omap_hwmod_addr_space am33xx_ecap2_addr_space[] = {
>  	},
>  	{
>  		.pa_start	= 0x48304100,
> -		.pa_end		= 0x48304100 + SZ_256 - 1,
> -		.flags		= ADDR_TYPE_RT
> +		.pa_end		= 0x48304100 + SZ_128 - 1,
>  	},
>  	{ }
>  };
> @@ -3395,6 +3524,9 @@ static struct omap_hwmod_ocp_if *am33xx_hwmod_ocp_ifs[] __initdata = {
>  	&am33xx_l4_ls__ehrpwm0,
>  	&am33xx_l4_ls__ehrpwm1,
>  	&am33xx_l4_ls__ehrpwm2,
> +	&am33xx_l4_ls__eqep0,
> +	&am33xx_l4_ls__eqep1,
> +	&am33xx_l4_ls__eqep2,
>  	&am33xx_l4_ls__ecap0,
>  	&am33xx_l4_ls__ecap1,
>  	&am33xx_l4_ls__ecap2,
> -- 
> 1.7.10.4
> 
> 

