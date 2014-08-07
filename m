Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaHGDTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 23:19:34 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:12100
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754563AbaHGDTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 23:19:33 -0400
From: "shengjiu.wang@freescale.com" <shengjiu.wang@freescale.com>
To: Lucas Stach <l.stach@pengutronix.de>
CC: Shawn Guo <Shawn.Guo@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 2/3] ARM: clk-imx6q: Add missing lvds and anaclk clock
 to the clock tree
Thread-Topic: [PATCH V2 2/3] ARM: clk-imx6q: Add missing lvds and anaclk clock
 to the clock tree
Thread-Index: AQHPsVFewEgGxvdxXU62HLItfh9QrJvDpqaAgADS26A=
Date: Thu, 7 Aug 2014 03:19:28 +0000
Message-ID: <577ff1cbd3e045179422336b49f8408a@BY2PR03MB332.namprd03.prod.outlook.com>
References: <cover.1407313676.git.shengjiu.wang@freescale.com>
	 <f98c6ea35ef4fa382d8aaf4ff370530aeb5b107f.1407313676.git.shengjiu.wang@freescale.com>
 <1407336147.5208.11.camel@weser.hi.pengutronix.de>
In-Reply-To: <1407336147.5208.11.camel@weser.hi.pengutronix.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 029651C7A1
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(51704005)(189002)(199002)(377454003)(54356999)(76576001)(81342001)(77982001)(15202345003)(76176999)(81542001)(99396002)(21056001)(15975445006)(101416001)(83322001)(76482001)(19580405001)(19580395003)(79102001)(92566001)(66066001)(46102001)(83072002)(86362001)(80022001)(20776003)(85852003)(107046002)(64706001)(2656002)(99286002)(95666004)(85306004)(106116001)(4396001)(50986999)(33646002)(105586002)(74316001)(31966008)(106356001)(74502001)(74662001)(87936001)(110136001)(24736002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB444;H:BY2PR03MB332.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s773JsIl015376

Hi Stash, Shawn

  Do we have such API for exclusive clock? Or Do you have example for these exclusive clocks?

Best regards
Wang shengjiu

-----Original Message-----
From: Lucas Stach [mailto:l.stach@pengutronix.de] 
Sent: Wednesday, August 06, 2014 10:42 PM
To: Wang Shengjiu-B02247
Cc: Guo Shawn-R65073; kernel@pengutronix.de; linux@arm.linux.org.uk; robh+dt@kernel.org; pawel.moll@arm.com; mark.rutland@arm.com; ijc+devicetree@hellion.org.uk; galak@codeaurora.org; Chen Guangyu-B42378; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/3] ARM: clk-imx6q: Add missing lvds and anaclk clock to the clock tree

Am Mittwoch, den 06.08.2014, 16:35 +0800 schrieb Shengjiu Wang:
> anaclk1 and anaclk2 is the clock source for lvds1_in and lvds2_in. 
> lvds1_in and lvds2_in can be used to provide external clock source to 
> the internal pll, such as pll4_audio and pll5_video.
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
> diff --git a/arch/arm/mach-imx/clk-imx6q.c 
> b/arch/arm/mach-imx/clk-imx6q.c index 1d6dd59..330aad3 100644
> --- a/arch/arm/mach-imx/clk-imx6q.c
> +++ b/arch/arm/mach-imx/clk-imx6q.c
> @@ -73,6 +73,7 @@ static const char *lvds_sels[] = {
>  	"pll4_audio", "pll5_video", "pll8_mlb", "enet_ref",
>  	"pcie_ref_125m", "sata_ref_100m",
>  };
> +static const char *pll_av_sels[] = { "osc", "lvds1_in", "lvds2_in", 
> +"dummy", };
>  
>  static struct clk *clk[IMX6QDL_CLK_END];  static struct 
> clk_onecell_data clk_data; @@ -119,6 +120,9 @@ static void __init 
> imx6q_clocks_init(struct device_node *ccm_node)
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
> @@ -169,6 +173,8 @@ static void __init imx6q_clocks_init(struct 
> device_node *ccm_node)
>  
>  	clk[IMX6QDL_CLK_LVDS1_SEL] = imx_clk_mux("lvds1_sel", base + 0x160, 0, 5, lvds_sels, ARRAY_SIZE(lvds_sels));
>  	clk[IMX6QDL_CLK_LVDS2_SEL] = imx_clk_mux("lvds2_sel", base + 0x160, 
> 5, 5, lvds_sels, ARRAY_SIZE(lvds_sels));
> +	clk[IMX6QDL_CLK_PLL4_SEL]  = imx_clk_mux("pll4_sel",  base + 0x70, 14, 2, pll_av_sels, ARRAY_SIZE(pll_av_sels));
> +	clk[IMX6QDL_CLK_PLL5_SEL]  = imx_clk_mux("pll5_sel",  base + 0xa0, 
> +14, 2, pll_av_sels, ARRAY_SIZE(pll_av_sels));
>  
>  	/*
>  	 * lvds1_gate and lvds2_gate are pseudo-gates.  Both can be @@ 
> -178,6 +184,8 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  	 */
>  	clk[IMX6QDL_CLK_LVDS1_GATE] = imx_clk_gate("lvds1_gate", "lvds1_sel", base + 0x160, 10);
>  	clk[IMX6QDL_CLK_LVDS2_GATE] = imx_clk_gate("lvds2_gate", 
> "lvds2_sel", base + 0x160, 11);
> +	clk[IMX6QDL_CLK_LVDS1_IN] = imx_clk_gate("lvds1_in", "anaclk1", base + 0x160, 12);
> +	clk[IMX6QDL_CLK_LVDS2_IN] = imx_clk_gate("lvds2_in", "anaclk2", base 
> ++ 0x160, 13);
>  
I think we need something more clever here. With both lvds in and out modeled as a clock gate it is possible for the user to enable both at the same time. The reference manual on the contrary states that both states are mutually exclusive: "Do not enable input and output buffers simultaneously".

Regards,
Lucas
-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
