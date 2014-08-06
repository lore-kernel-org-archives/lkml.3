Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaHFOpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:45:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50510 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaHFOpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:45:21 -0400
Message-ID: <1407336147.5208.11.camel@weser.hi.pengutronix.de>
Subject: Re: [PATCH V2 2/3] ARM: clk-imx6q: Add missing lvds and anaclk
 clock to the clock tree
From: Lucas Stach <l.stach@pengutronix.de>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de, linux@arm.linux.org.uk,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Guangyu.Chen@freescale.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2014 16:42:27 +0200
In-Reply-To: <f98c6ea35ef4fa382d8aaf4ff370530aeb5b107f.1407313676.git.shengjiu.wang@freescale.com>
References: <cover.1407313676.git.shengjiu.wang@freescale.com>
	 <f98c6ea35ef4fa382d8aaf4ff370530aeb5b107f.1407313676.git.shengjiu.wang@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 06.08.2014, 16:35 +0800 schrieb Shengjiu Wang:
> anaclk1 and anaclk2 is the clock source for lvds1_in and lvds2_in. lvds1_in
> and lvds2_in can be used to provide external clock source to the internal
> pll, such as pll4_audio and pll5_video.
> pll4_audio and pll5_video can have multiple source, not only "osc", so
> add them.
> 
> Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> ---
>  arch/arm/mach-imx/clk-imx6q.c             |   12 ++++++++++--
>  include/dt-bindings/clock/imx6qdl-clock.h |    8 +++++++-
>  2 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
> index 1d6dd59..330aad3 100644
> --- a/arch/arm/mach-imx/clk-imx6q.c
> +++ b/arch/arm/mach-imx/clk-imx6q.c
> @@ -73,6 +73,7 @@ static const char *lvds_sels[] = {
>  	"pll4_audio", "pll5_video", "pll8_mlb", "enet_ref",
>  	"pcie_ref_125m", "sata_ref_100m",
>  };
> +static const char *pll_av_sels[] = { "osc", "lvds1_in", "lvds2_in", "dummy", };
>  
>  static struct clk *clk[IMX6QDL_CLK_END];
>  static struct clk_onecell_data clk_data;
> @@ -119,6 +120,9 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  	clk[IMX6QDL_CLK_CKIL] = imx_obtain_fixed_clock("ckil", 0);
>  	clk[IMX6QDL_CLK_CKIH] = imx_obtain_fixed_clock("ckih1", 0);
>  	clk[IMX6QDL_CLK_OSC] = imx_obtain_fixed_clock("osc", 0);
> +	/* Clock source from external clock via ANACLK1/2 PADs */
> +	clk[IMX6QDL_CLK_ANACLK1] = imx_obtain_fixed_clock("anaclk1", 0);
> +	clk[IMX6QDL_CLK_ANACLK2] = imx_obtain_fixed_clock("anaclk2", 0);
>  
>  	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-anatop");
>  	base = of_iomap(np, 0);
> @@ -136,8 +140,8 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  	clk[IMX6QDL_CLK_PLL1_SYS]      = imx_clk_pllv3(IMX_PLLV3_SYS,	"pll1_sys",	"osc", base,        0x7f);
>  	clk[IMX6QDL_CLK_PLL2_BUS]      = imx_clk_pllv3(IMX_PLLV3_GENERIC,	"pll2_bus",	"osc", base + 0x30, 0x1);
>  	clk[IMX6QDL_CLK_PLL3_USB_OTG]  = imx_clk_pllv3(IMX_PLLV3_USB,	"pll3_usb_otg",	"osc", base + 0x10, 0x3);
> -	clk[IMX6QDL_CLK_PLL4_AUDIO]    = imx_clk_pllv3(IMX_PLLV3_AV,	"pll4_audio",	"osc", base + 0x70, 0x7f);
> -	clk[IMX6QDL_CLK_PLL5_VIDEO]    = imx_clk_pllv3(IMX_PLLV3_AV,	"pll5_video",	"osc", base + 0xa0, 0x7f);
> +	clk[IMX6QDL_CLK_PLL4_AUDIO]    = imx_clk_pllv3(IMX_PLLV3_AV,	"pll4_audio",	"pll4_sel", base + 0x70, 0x7f);
> +	clk[IMX6QDL_CLK_PLL5_VIDEO]    = imx_clk_pllv3(IMX_PLLV3_AV,	"pll5_video",	"pll5_sel", base + 0xa0, 0x7f);
>  	clk[IMX6QDL_CLK_PLL6_ENET]     = imx_clk_pllv3(IMX_PLLV3_ENET,	"pll6_enet",	"osc", base + 0xe0, 0x3);
>  	clk[IMX6QDL_CLK_PLL7_USB_HOST] = imx_clk_pllv3(IMX_PLLV3_USB,	"pll7_usb_host","osc", base + 0x20, 0x3);
>  
> @@ -169,6 +173,8 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  
>  	clk[IMX6QDL_CLK_LVDS1_SEL] = imx_clk_mux("lvds1_sel", base + 0x160, 0, 5, lvds_sels, ARRAY_SIZE(lvds_sels));
>  	clk[IMX6QDL_CLK_LVDS2_SEL] = imx_clk_mux("lvds2_sel", base + 0x160, 5, 5, lvds_sels, ARRAY_SIZE(lvds_sels));
> +	clk[IMX6QDL_CLK_PLL4_SEL]  = imx_clk_mux("pll4_sel",  base + 0x70, 14, 2, pll_av_sels, ARRAY_SIZE(pll_av_sels));
> +	clk[IMX6QDL_CLK_PLL5_SEL]  = imx_clk_mux("pll5_sel",  base + 0xa0, 14, 2, pll_av_sels, ARRAY_SIZE(pll_av_sels));
>  
>  	/*
>  	 * lvds1_gate and lvds2_gate are pseudo-gates.  Both can be
> @@ -178,6 +184,8 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  	 */
>  	clk[IMX6QDL_CLK_LVDS1_GATE] = imx_clk_gate("lvds1_gate", "lvds1_sel", base + 0x160, 10);
>  	clk[IMX6QDL_CLK_LVDS2_GATE] = imx_clk_gate("lvds2_gate", "lvds2_sel", base + 0x160, 11);
> +	clk[IMX6QDL_CLK_LVDS1_IN] = imx_clk_gate("lvds1_in", "anaclk1", base + 0x160, 12);
> +	clk[IMX6QDL_CLK_LVDS2_IN] = imx_clk_gate("lvds2_in", "anaclk2", base + 0x160, 13);
>  
I think we need something more clever here. With both lvds in and out
modeled as a clock gate it is possible for the user to enable both at
the same time. The reference manual on the contrary states that both
states are mutually exclusive: "Do not enable input and output buffers
simultaneously".

Regards,
Lucas
-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

