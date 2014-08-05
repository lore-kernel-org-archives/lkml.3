Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbaHEHSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:18:42 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:9045
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756447AbaHEHSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:18:40 -0400
Date: Tue, 5 Aug 2014 15:18:10 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <Guangyu.Chen@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 2/3] ARM: clk-imx6q: Add missing lvds2 clock to the
 clock tree
Message-ID: <20140805071807.GH2167@dragon>
References: <cover.1407148853.git.shengjiu.wang@freescale.com>
 <59d4ee1c6ea8eee9d104f0ae2dfcce3ae00a8ad4.1407148853.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <59d4ee1c6ea8eee9d104f0ae2dfcce3ae00a8ad4.1407148853.git.shengjiu.wang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(24454002)(51704005)(83506001)(102836001)(97736001)(33716001)(69596002)(84676001)(97756001)(33656002)(74662001)(47776003)(74502001)(50466002)(64706001)(20776003)(46406003)(68736004)(76482001)(46102001)(79102001)(81542001)(81342001)(26826002)(86362001)(77982001)(80022001)(4396001)(21056001)(57986006)(19580395003)(19580405001)(44976005)(6806004)(87936001)(83322001)(95666004)(31966008)(23726002)(105606002)(106466001)(81156004)(104016003)(76176999)(85306004)(107046002)(54356999)(99396002)(110136001)(83072002)(85852003)(50986999)(92726001)(92566001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB333;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 07:11:14PM +0800, Shengjiu Wang wrote:
> We actually have lvds2 (analog clock2), an I/O clock like lvds1, in the SoC.
> And this lvds2, along with lvds1, can be used to provide external clock source
> to the internal pll, such as pll4_audio and pll5_video.
> 
> So This patch mainly adds the lvds2 to the clock tree and fix its relationship
> with pll4 accordingly.

The patch subject and commit log are slightly different from what code
does.  The code adds both lvds/anaclk clocks as input to SoC.

> 
> [ To reduce the risk from code changing. This patch only takes care of pll4
>   related part. We might later need to add the relationship with pll5 too. ]

I prefer to handles pll5 in the same patch, as they are logically the
same thing.

Shawn

> 
> Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> ---
>  arch/arm/mach-imx/clk-imx6q.c             |    9 ++++++++-
>  include/dt-bindings/clock/imx6qdl-clock.h |    7 ++++++-
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
> index 1d6dd59..927a062 100644
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
> @@ -136,7 +140,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  	clk[IMX6QDL_CLK_PLL1_SYS]      = imx_clk_pllv3(IMX_PLLV3_SYS,	"pll1_sys",	"osc", base,        0x7f);
>  	clk[IMX6QDL_CLK_PLL2_BUS]      = imx_clk_pllv3(IMX_PLLV3_GENERIC,	"pll2_bus",	"osc", base + 0x30, 0x1);
>  	clk[IMX6QDL_CLK_PLL3_USB_OTG]  = imx_clk_pllv3(IMX_PLLV3_USB,	"pll3_usb_otg",	"osc", base + 0x10, 0x3);
> -	clk[IMX6QDL_CLK_PLL4_AUDIO]    = imx_clk_pllv3(IMX_PLLV3_AV,	"pll4_audio",	"osc", base + 0x70, 0x7f);
> +	clk[IMX6QDL_CLK_PLL4_AUDIO]    = imx_clk_pllv3(IMX_PLLV3_AV,	"pll4_audio",	"pll4_sel", base + 0x70, 0x7f);
>  	clk[IMX6QDL_CLK_PLL5_VIDEO]    = imx_clk_pllv3(IMX_PLLV3_AV,	"pll5_video",	"osc", base + 0xa0, 0x7f);
>  	clk[IMX6QDL_CLK_PLL6_ENET]     = imx_clk_pllv3(IMX_PLLV3_ENET,	"pll6_enet",	"osc", base + 0xe0, 0x3);
>  	clk[IMX6QDL_CLK_PLL7_USB_HOST] = imx_clk_pllv3(IMX_PLLV3_USB,	"pll7_usb_host","osc", base + 0x20, 0x3);
> @@ -169,6 +173,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  
>  	clk[IMX6QDL_CLK_LVDS1_SEL] = imx_clk_mux("lvds1_sel", base + 0x160, 0, 5, lvds_sels, ARRAY_SIZE(lvds_sels));
>  	clk[IMX6QDL_CLK_LVDS2_SEL] = imx_clk_mux("lvds2_sel", base + 0x160, 5, 5, lvds_sels, ARRAY_SIZE(lvds_sels));
> +	clk[IMX6QDL_CLK_PLL4_SEL]  = imx_clk_mux("pll4_sel",  base + 0x70, 14, 2, pll_av_sels, ARRAY_SIZE(pll_av_sels));
>  
>  	/*
>  	 * lvds1_gate and lvds2_gate are pseudo-gates.  Both can be
> @@ -178,6 +183,8 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  	 */
>  	clk[IMX6QDL_CLK_LVDS1_GATE] = imx_clk_gate("lvds1_gate", "lvds1_sel", base + 0x160, 10);
>  	clk[IMX6QDL_CLK_LVDS2_GATE] = imx_clk_gate("lvds2_gate", "lvds2_sel", base + 0x160, 11);
> +	clk[IMX6QDL_CLK_LVDS1_IN] = imx_clk_gate("lvds1_in", "anaclk1", base + 0x160, 12);
> +	clk[IMX6QDL_CLK_LVDS2_IN] = imx_clk_gate("lvds2_in", "anaclk2", base + 0x160, 13);
>  
>  	/*                                            name              parent_name        reg       idx */
>  	clk[IMX6QDL_CLK_PLL2_PFD0_352M] = imx_clk_pfd("pll2_pfd0_352m", "pll2_bus",     base + 0x100, 0);
> diff --git a/include/dt-bindings/clock/imx6qdl-clock.h b/include/dt-bindings/clock/imx6qdl-clock.h
> index 323e865..9530de8 100644
> --- a/include/dt-bindings/clock/imx6qdl-clock.h
> +++ b/include/dt-bindings/clock/imx6qdl-clock.h
> @@ -220,6 +220,11 @@
>  #define IMX6QDL_CLK_LVDS2_GATE			207
>  #define IMX6QDL_CLK_ESAI_IPG			208
>  #define IMX6QDL_CLK_ESAI_MEM			209
> -#define IMX6QDL_CLK_END				210
> +#define IMX6QDL_CLK_LVDS1_IN			210
> +#define IMX6QDL_CLK_LVDS2_IN			211
> +#define IMX6QDL_CLK_ANACLK1			212
> +#define IMX6QDL_CLK_ANACLK2			213
> +#define IMX6QDL_CLK_PLL4_SEL			214
> +#define IMX6QDL_CLK_END				215
>  
>  #endif /* __DT_BINDINGS_CLOCK_IMX6QDL_H */
> -- 
> 1.7.9.5
> 
