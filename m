Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbaHZWvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 18:51:15 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:44893
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754972AbaHZWvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 18:51:13 -0400
Message-ID: <1409093463.6510.92.camel@snotra.buserror.net>
Subject: Re: [RESEND] clk: ppc-corenet: Add Freescale ARM-based platforms
 CLK_OF_DECLARE support
From: Scott Wood <scottwood@freescale.com>
To: Jingchang Lu <jingchang.lu@freescale.com>
CC: <mturquette@linaro.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Date: Tue, 26 Aug 2014 17:51:03 -0500
In-Reply-To: <1408700096-25415-1-git-send-email-jingchang.lu@freescale.com>
References: <1408700096-25415-1-git-send-email-jingchang.lu@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:9485:8c90:e4c6:b5ea]
X-ClientProxiedBy: CY1PR0601CA0022.namprd06.prod.outlook.com (25.160.162.32)
 To BY2PR0301MB0725.namprd03.prod.outlook.com (25.160.63.155)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03152A99FF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(199003)(377424004)(51704005)(189002)(24454002)(85306004)(104166001)(95666004)(105586002)(21056001)(64706001)(47776003)(20776003)(33646002)(101416001)(80022001)(110136001)(23676002)(107046002)(106356001)(74502001)(76176999)(31966008)(50986999)(102836001)(103116003)(42186005)(74662001)(87976001)(19580405001)(90102001)(81342001)(88136002)(99396002)(50226001)(92566001)(4396001)(62966002)(86362001)(81542001)(93916002)(92726001)(19580395003)(46102001)(87286001)(77982001)(89996001)(50466002)(76482001)(77096002)(83072002)(77156001)(85852003)(83322001)(79102001)(3826002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0725;H:[IPv6:2601:2:5800:3f7:9485:8c90:e4c6:b5ea];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 17:34 +0800, Jingchang Lu wrote:
> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
> ---
>  drivers/clk/Kconfig           | 7 ++++---
>  drivers/clk/clk-ppc-corenet.c | 5 +++++
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index cfd3af7..8784704 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -82,11 +82,12 @@ config COMMON_CLK_AXI_CLKGEN
>  	  FPGAs. It is commonly used in Analog Devices' reference designs.
>  
>  config CLK_PPC_CORENET
> -	bool "Clock driver for PowerPC corenet platforms"
> -	depends on PPC_E500MC && OF
> +	bool "Clock driver for PowerPC corenet and compatible ARM-based platforms"
> +	depends on (PPC_E500MC || ARM) && OF

Should the symbol and driver be renamed to something like CLK_FSL_QORIQ?

> diff --git a/drivers/clk/clk-ppc-corenet.c b/drivers/clk/clk-ppc-corenet.c
> index 8e58edf..7692cac 100644
> --- a/drivers/clk/clk-ppc-corenet.c
> +++ b/drivers/clk/clk-ppc-corenet.c
> @@ -305,3 +305,8 @@ static int __init ppc_corenet_clk_init(void)
>  	return platform_driver_register(&ppc_corenet_clk_driver);
>  }
>  subsys_initcall(ppc_corenet_clk_init);
> +
> +CLK_OF_DECLARE(ppc_core_pll_v1, "fsl,qoriq-core-pll-1.0", core_pll_init);
> +CLK_OF_DECLARE(ppc_core_pll_v2, "fsl,qoriq-core-pll-2.0", core_pll_init);
> +CLK_OF_DECLARE(ppc_core_mux_v1, "fsl,qoriq-core-mux-1.0", core_mux_init);
> +CLK_OF_DECLARE(ppc_core_mux_v2, "fsl,qoriq-core-mux-2.0", core_mux_init);

What does this do that the existing platform driver and match table
don't?  Why is it needed for ARM when PPC didn't need it?

-Scott


