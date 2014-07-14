Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbaGNNjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:39:47 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:28302
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754483AbaGNNjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:39:41 -0400
Date: Mon, 14 Jul 2014 21:39:29 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <mkl@pengutronix.de>, <kernel@pengutronix.de>,
        Jingchang Lu <b35083@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] ARM: imx: clk-vf610: fix FlexCAN clock gating
Message-ID: <20140714133926.GH2197@dragon>
References: <cover.1405322992.git.stefan@agner.ch>
 <94282392d8355ac25bb998b89032c1c980d5ccce.1405322992.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <94282392d8355ac25bb998b89032c1c980d5ccce.1405322992.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(189002)(199002)(24454002)(102836001)(33656002)(76482001)(31966008)(85306003)(74662001)(50466002)(110136001)(33716001)(84676001)(54356999)(97756001)(50986999)(74502001)(26826002)(80022001)(83506001)(64706001)(57986006)(46102001)(76176999)(81342001)(21056001)(97736001)(99396002)(105606002)(46406003)(92566001)(20776003)(86362001)(47776003)(85852003)(83072002)(92726001)(79102001)(81156004)(106466001)(107046002)(6806004)(81542001)(19580395003)(4396001)(68736004)(69596002)(104016003)(87936001)(44976005)(19580405001)(95666004)(77982001)(83322001)(23726002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB478;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy Jingchang ...

On Mon, Jul 14, 2014 at 09:48:29AM +0200, Stefan Agner wrote:
> Extend the clock control for FlexCAN with the second gate which
> enable the clocks in the Clock Divider (CCM_CSCDR2) register too.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  arch/arm/mach-imx/clk-vf610.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
> index 22dc3ee..b12b888 100644
> --- a/arch/arm/mach-imx/clk-vf610.c
> +++ b/arch/arm/mach-imx/clk-vf610.c
> @@ -295,8 +295,10 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
>  
>  	clk[VF610_CLK_ASRC] = imx_clk_gate2("asrc", "ipg_bus", CCM_CCGR4, CCM_CCGRx_CGn(1));
>  
> -	clk[VF610_CLK_FLEXCAN0] = imx_clk_gate2("flexcan0", "ipg_bus", CCM_CCGR0, CCM_CCGRx_CGn(0));
> -	clk[VF610_CLK_FLEXCAN1] = imx_clk_gate2("flexcan1", "ipg_bus", CCM_CCGR9, CCM_CCGRx_CGn(4));
> +	clk[VF610_CLK_FLEXCAN0] = imx_clk_gate("flexcan0_en", "ipg_bus", CCM_CSCDR2, 11);
> +	clk[VF610_CLK_FLEXCAN0] = imx_clk_gate2("flexcan0", "flexcan0_en", CCM_CCGR0, CCM_CCGRx_CGn(0));

I do not quite understand what "flexcan0_en" clock is and the
relationship between it and clock "flexcan0".  I do not think it's a
parent-child clock relationship.  Jingchang, do you have more info on
this?

Also when you add a new clock, you should have a new clock ID, something
like VF610_CLK_FLEXCAN0_EN.

Shawn

> +	clk[VF610_CLK_FLEXCAN1] = imx_clk_gate("flexcan1_en", "ipg_bus", CCM_CSCDR2, 12);
> +	clk[VF610_CLK_FLEXCAN1] = imx_clk_gate2("flexcan1", "flexcan1_en", CCM_CCGR9, CCM_CCGRx_CGn(4));
>  
>  	clk[VF610_CLK_DMAMUX0] = imx_clk_gate2("dmamux0", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(4));
>  	clk[VF610_CLK_DMAMUX1] = imx_clk_gate2("dmamux1", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(5));
> -- 
> 2.0.1
> 
