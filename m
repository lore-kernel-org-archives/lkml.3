Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaHGDOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 23:14:05 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:9389
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754444AbaHGDOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 23:14:04 -0400
From: "shengjiu.wang@freescale.com" <shengjiu.wang@freescale.com>
To: Shawn Guo <Shawn.Guo@freescale.com>
CC: "kernel@pengutronix.de" <kernel@pengutronix.de>,
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
Subject: RE: [PATCH V2 3/3] ARM: imx6q: Add the clock route from external OSC
 to ESAI clock
Thread-Topic: [PATCH V2 3/3] ARM: imx6q: Add the clock route from external OSC
 to ESAI clock
Thread-Index: AQHPsVFghyWYt48/CUmf6AdQVMcv7ZvEd/UAgAAAesA=
Date: Thu, 7 Aug 2014 03:14:00 +0000
Message-ID: <b59e4fbce43a4c0c9964b13f1ad25c5e@BY2PR03MB332.namprd03.prod.outlook.com>
References: <cover.1407313676.git.shengjiu.wang@freescale.com>
 <309d5e2cb941aba7d81e2d87a8237c4ef677e45c.1407313676.git.shengjiu.wang@freescale.com>
 <20140807031135.GO2167@dragon>
In-Reply-To: <20140807031135.GO2167@dragon>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 029651C7A1
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(377454003)(189002)(199002)(24454002)(51704005)(33646002)(106356001)(105586002)(106116001)(21056001)(4396001)(110136001)(66066001)(76576001)(80022001)(76176999)(99286002)(95666004)(76482001)(74502001)(85306004)(86362001)(107046002)(74662001)(31966008)(74316001)(64706001)(83072002)(85852003)(20776003)(92566001)(81342001)(2656002)(87936001)(77982001)(19580405001)(101416001)(19580395003)(79102001)(99396002)(81542001)(46102001)(83322001)(54356999)(50986999)(32563001)(24736002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB347;H:BY2PR03MB332.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, thanks.

-----Original Message-----
From: Shawn Guo [mailto:shawn.guo@freescale.com] 
Sent: Thursday, August 07, 2014 11:12 AM
To: Wang Shengjiu-B02247
Cc: kernel@pengutronix.de; linux@arm.linux.org.uk; robh+dt@kernel.org; pawel.moll@arm.com; mark.rutland@arm.com; ijc+devicetree@hellion.org.uk; galak@codeaurora.org; Chen Guangyu-B42378; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/3] ARM: imx6q: Add the clock route from external OSC to ESAI clock

On Wed, Aug 06, 2014 at 04:35:15PM +0800, Shengjiu Wang wrote:
> This patch mainly adds the clock route from external 24.576MHz OSC to 
> internal ESAI clock via analog clock2 PADs on the SoC and pll4 so that 
> ESAI can get an entirely synchronous clock source against CS42888.
> 
> [ 1, We found if using pll4 to generate a 24.576MHz from inernal 24.0MHz OSC,
>   we would get noise during the audio playback via ESAI->CS42888 even though
>   this generated clock's rate is equal to the external one statistically. It
>   might be resulted from the tiny difference between two clock source, which
>   might be crucial to the sensitive CODEC we use -- CS42888.
> 
>   2, Ideally, we should use bypass mode for pll4 since we only need to get
>   the raw rate (24.576MHz) while currently bypass mode in clk-pllv3.c isn't
>   supported. After bypass mode implement, then we can refine this 
> patch.]

I meant we should implement bypass mode first.  I will give it a try.

Shawn

> 
>   Expected result:
> 
>   anaclk2                 0           1            24576000
>    lvds2_in               0           1            24576000
>     pll4_sel              0           1            24576000
>      pll4_audio           0           1            786432000
>       pll4_post_div       0           1            786432000
>        pll4_audio_div     0           1            786432000
>         esai_sel          0           1            786432000
>          esai_pred        0           1            98304000
>           esai_podf       0           1            24576000
>            esai_extal     0           1            24576000
> 
> Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> ---
>  arch/arm/mach-imx/clk-imx6q.c  |    5 +++++
>  arch/arm/mach-imx/mach-imx6q.c |   28 ++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/arch/arm/mach-imx/clk-imx6q.c 
> b/arch/arm/mach-imx/clk-imx6q.c index 330aad3..29151cb 100644
> --- a/arch/arm/mach-imx/clk-imx6q.c
> +++ b/arch/arm/mach-imx/clk-imx6q.c
> @@ -414,6 +414,10 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
>  
>  	clk_register_clkdev(clk[IMX6QDL_CLK_ENET_REF], "enet_ref", NULL);
> +	clk_register_clkdev(clk[IMX6QDL_CLK_PLL4_AUDIO_DIV], "pll4_audio_div", NULL);
> +	clk_register_clkdev(clk[IMX6QDL_CLK_PLL4_SEL], "pll4_sel", NULL);
> +	clk_register_clkdev(clk[IMX6QDL_CLK_LVDS2_IN], "lvds2_in", NULL);
> +	clk_register_clkdev(clk[IMX6QDL_CLK_ESAI_EXTAL], "esai_extal", 
> +NULL);
>  
>  	if ((imx_get_soc_revision() != IMX_CHIP_REVISION_1_0) ||
>  	    cpu_is_imx6dl()) {
> @@ -457,6 +461,7 @@ static void __init imx6q_clocks_init(struct 
> device_node *ccm_node)
>  
>  	/* Audio-related clocks configuration */
>  	clk_set_parent(clk[IMX6QDL_CLK_SPDIF_SEL], 
> clk[IMX6QDL_CLK_PLL3_PFD3_454M]);
> +	clk_set_parent(clk[IMX6QDL_CLK_ESAI_SEL], 
> +clk[IMX6QDL_CLK_PLL4_AUDIO_DIV]);
>  
>  	/* All existing boards with PCIe use LVDS1 */
>  	if (IS_ENABLED(CONFIG_PCI_IMX6))
> diff --git a/arch/arm/mach-imx/mach-imx6q.c 
> b/arch/arm/mach-imx/mach-imx6q.c index d51c6e9..ea24a96 100644
> --- a/arch/arm/mach-imx/mach-imx6q.c
> +++ b/arch/arm/mach-imx/mach-imx6q.c
> @@ -362,6 +362,28 @@ put_node:
>  	of_node_put(np);
>  }
>  
> +#define ESAI_AUDIO_MCLK 24576000
> +
> +static void __init imx6q_audio_lvds2_init(void) {
> +        struct clk *pll4_sel, *lvds2_in, *pll4_audio_div, 
> +*esai_extal;
> +
> +        pll4_audio_div = clk_get_sys(NULL, "pll4_audio_div");
> +        pll4_sel = clk_get_sys(NULL, "pll4_sel");
> +        lvds2_in = clk_get_sys(NULL, "lvds2_in");
> +        esai_extal = clk_get_sys(NULL, "esai_extal");
> +        if (IS_ERR(pll4_audio_div) || IS_ERR(pll4_sel) ||
> +            IS_ERR(lvds2_in) || IS_ERR(esai_extal))
> +                return;
> +
> +        if (clk_get_rate(lvds2_in) != ESAI_AUDIO_MCLK)
> +                return;
> +
> +        clk_set_parent(pll4_sel, lvds2_in);
> +        clk_set_rate(pll4_audio_div, 786432000);
> +        clk_set_rate(esai_extal, ESAI_AUDIO_MCLK); }
> +
>  static struct platform_device imx6q_cpufreq_pdev = {
>  	.name = "imx6q-cpufreq",
>  };
> @@ -379,6 +401,12 @@ static void __init imx6q_init_late(void)
>  		imx6q_opp_init();
>  		platform_device_register(&imx6q_cpufreq_pdev);
>  	}
> +
> +	if (of_machine_is_compatible("fsl,imx6q-sabreauto")
> +		|| of_machine_is_compatible("fsl,imx6dl-sabreauto")) {
> +		imx6q_audio_lvds2_init();
> +	}
> +
>  }
>  
>  static void __init imx6q_map_io(void)
> --
> 1.7.9.5
> 
