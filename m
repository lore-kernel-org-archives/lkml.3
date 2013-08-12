Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab3HLI02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:26:28 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:63200 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751639Ab3HLI0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:26:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1//sQcr+oICFHpVHeqw2mBh
Date: Mon, 12 Aug 2013 01:26:21 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@debian.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, Kevin Hilman <khilman@deeprootsystems.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Sebastian Reichel <sre@ring0.de>,
        paul@pwsan.com
Subject: Re: [PATCH 1/3] ARM: OMAP2+: hwmod-data: Add SSI information
Message-ID: <20130812082621.GJ7656@atomide.com>
References: <1376237628-1077-1-git-send-email-sre@debian.org>
 <1376237877-1740-1-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376237877-1740-1-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@debian.org> [130811 09:25]:
> From: Sebastian Reichel <sre@ring0.de>
> 
> This patch adds Synchronous Serial Interface (SSI) hwmod support for
> OMAP34xx SoCs.

This should be queued or acked by Paul.

Regards,

Tony

>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  104 ++++++++++++++++++++++++++++
>  1 file changed, 104 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> index 0c3a427..74006c4 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> @@ -3693,6 +3693,109 @@ static struct omap_hwmod_ocp_if omap3xxx_l4_core__aes = {
>  	.user		= OCP_USER_MPU | OCP_USER_SDMA,
>  };
>  
> +/*
> + * 'ssi' class
> + * synchronous serial interface (multichannel and full-duplex serial if)
> + */
> +
> +static struct omap_hwmod_class_sysconfig omap34xx_ssi_sysc = {
> +	.rev_offs	= 0x0000,
> +	.sysc_offs	= 0x0010,
> +	.syss_offs	= 0x0014,
> +	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_EMUFREE |
> +			   SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE |
> +			   SYSC_HAS_SOFTRESET | SYSS_HAS_RESET_STATUS),
> +	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
> +			   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
> +			   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
> +	.sysc_fields	= &omap_hwmod_sysc_type1,
> +};
> +
> +static struct omap_hwmod_class omap34xx_ssi_hwmod_class = {
> +	.name	= "ssi",
> +	.sysc	= &omap34xx_ssi_sysc,
> +};
> +
> +static struct omap_hwmod_irq_info omap34xx_ssi_irqs[] = {
> +	{ .name = "ssi_p1_mpu_irq0", .irq = 67 },
> +	{ .name = "ssi_p1_mpu_irq1", .irq = 68 },
> +	{ .name = "ssi_p2_mpu_irq0", .irq = 69 },
> +	{ .name = "ssi_p2_mpu_irq1", .irq = 70 },
> +	{ .name = "ssi_gdd_mpu",     .irq = 71 },
> +	{ .irq = -1 },
> +};
> +
> +static struct omap_hwmod_addr_space omap34xx_ssi_addrs[] = {
> +	{
> +		.name		= "sys",
> +		.pa_start	= 0x48058000,
> +		.pa_end		= 0x48058fff,
> +		.flags		= ADDR_TYPE_RT,
> +	},
> +	{
> +		/* generic distributed DMA */
> +		.name		= "gdd",
> +		.pa_start	= 0x48059000,
> +		.pa_end		= 0x48059fff,
> +		.flags		= ADDR_TYPE_RT,
> +	},
> +	{
> +		/* port 1: synchronous serial transmitter */
> +		.name		= "p1_sst",
> +		.pa_start	= 0x4805a000,
> +		.pa_end		= 0x4805a7ff,
> +		.flags		= ADDR_TYPE_RT,
> +	},
> +	{
> +		/* port 1: synchronous serial receiver */
> +		.name		= "p1_ssr",
> +		.pa_start	= 0x4805a800,
> +		.pa_end		= 0x4805afff,
> +		.flags		= ADDR_TYPE_RT,
> +	},
> +	{
> +		/* port 2: synchronous serial transmitter */
> +		.name		= "p2_sst",
> +		.pa_start	= 0x4805b000,
> +		.pa_end		= 0x4805b7ff,
> +		.flags		= ADDR_TYPE_RT,
> +	},
> +	{
> +		/* port 2: synchronous serial receiver */
> +		.name		= "p2_ssr",
> +		.pa_start	= 0x4805b800,
> +		.pa_end		= 0x4805bfff,
> +		.flags		= ADDR_TYPE_RT,
> +	},
> +	{}
> +};
> +
> +static struct omap_hwmod omap34xx_ssi_hwmod = {
> +	.name		= "ssi",
> +	.class		= &omap34xx_ssi_hwmod_class,
> +	.clkdm_name	= "l3_init_clkdm",
> +	.mpu_irqs	= omap34xx_ssi_irqs,
> +	.main_clk	= "ssi_ssr_fck",
> +	.prcm		= {
> +		.omap2 = {
> +			.prcm_reg_id		= 1,
> +			.module_bit		= OMAP3430_EN_SSI_SHIFT,
> +			.module_offs		= WKUP_MOD,
> +			.idlest_reg_id		= 1,
> +			.idlest_idle_bit	= OMAP3430ES2_ST_SSI_IDLE_SHIFT,
> +		},
> +	},
> +};
> +
> +/* SSI -> l3 */
> +static struct omap_hwmod_ocp_if omap34xx_l3__ssi = {
> +	.master		= &omap3xxx_l3_main_hwmod,
> +	.slave		= &omap34xx_ssi_hwmod,
> +	.clk		= "ssi_ick",
> +	.addr		= omap34xx_ssi_addrs,
> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
>  static struct omap_hwmod_ocp_if *omap3xxx_hwmod_ocp_ifs[] __initdata = {
>  	&omap3xxx_l3_main__l4_core,
>  	&omap3xxx_l3_main__l4_per,
> @@ -3818,6 +3921,7 @@ static struct omap_hwmod_ocp_if *omap34xx_hwmod_ocp_ifs[] __initdata = {
>  #ifdef CONFIG_OMAP_IOMMU_IVA2
>  	&omap3xxx_l3_main__mmu_iva,
>  #endif
> +	&omap34xx_l3__ssi,
>  	NULL
>  };
>  
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
