Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaHUL2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:28:39 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:32649
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754500AbaHUL2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:28:37 -0400
Message-ID: <53F5D7DD.4070805@freescale.com>
Date: Thu, 21 Aug 2014 14:28:29 +0300
From: Diana Craciun <diana.craciun@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jingchang Lu <jingchang.lu@freescale.com>
CC: <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: ppc-corenet: Add Freescale ARM-based platforms CLK_OF_DECLARE
 support
References: <1407145537-15027-1-git-send-email-jingchang.lu@freescale.com>
In-Reply-To: <1407145537-15027-1-git-send-email-jingchang.lu@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(377454003)(189002)(199003)(51704005)(479174003)(83322001)(4396001)(84676001)(99396002)(95666004)(65806001)(81542001)(80316001)(50466002)(26826002)(21056001)(86362001)(81342001)(68736004)(105606002)(19580395003)(85852003)(46102001)(87936001)(33656002)(65816999)(83506001)(76482001)(65956001)(74662001)(54356999)(107046002)(74502001)(110136001)(31966008)(83072002)(102836001)(23756003)(77982001)(92566001)(20776003)(44976005)(36756003)(81156004)(85306004)(79102001)(47776003)(19580405001)(97736001)(59896002)(80022001)(6806004)(106466001)(87266999)(104016003)(92726001)(50986999)(64706001)(64126003)(76176999)(69596002)(21314002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB471;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0310C78181
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Diana.Craciun@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you should cc also linuxppc-dev as it touches common code.

On 08/04/2014 12:45 PM, Jingchang Lu wrote:
> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
> ---
>   drivers/clk/Kconfig           | 7 ++++---
>   drivers/clk/clk-ppc-corenet.c | 5 +++++
>   2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index cfd3af7..8784704 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -82,11 +82,12 @@ config COMMON_CLK_AXI_CLKGEN
>   	  FPGAs. It is commonly used in Analog Devices' reference designs.
>   
>   config CLK_PPC_CORENET
> -	bool "Clock driver for PowerPC corenet platforms"
> -	depends on PPC_E500MC && OF
> +	bool "Clock driver for PowerPC corenet and compatible ARM-based platforms"
> +	depends on (PPC_E500MC || ARM) && OF
>   	---help---
>   	  This adds the clock driver support for Freescale PowerPC corenet
> -	  platforms using common clock framework.
> +	  platforms and compatible Freescale ARM based platforms using common
> +	  clock framework.
>   
>   config COMMON_CLK_XGENE
>   	bool "Clock driver for APM XGene SoC"
> diff --git a/drivers/clk/clk-ppc-corenet.c b/drivers/clk/clk-ppc-corenet.c

Can't this file be renamed in order to reflect that is common between 
PPC and ARM? It is strange to be named ppc_xxx and to be used by ARM kernel.

> index 8e58edf..7692cac 100644
> --- a/drivers/clk/clk-ppc-corenet.c
> +++ b/drivers/clk/clk-ppc-corenet.c
> @@ -305,3 +305,8 @@ static int __init ppc_corenet_clk_init(void)
>   	return platform_driver_register(&ppc_corenet_clk_driver);
>   }
>   subsys_initcall(ppc_corenet_clk_init);
> +
> +CLK_OF_DECLARE(ppc_core_pll_v1, "fsl,qoriq-core-pll-1.0", core_pll_init);
> +CLK_OF_DECLARE(ppc_core_pll_v2, "fsl,qoriq-core-pll-2.0", core_pll_init);
> +CLK_OF_DECLARE(ppc_core_mux_v1, "fsl,qoriq-core-mux-1.0", core_mux_init);
> +CLK_OF_DECLARE(ppc_core_mux_v2, "fsl,qoriq-core-mux-2.0", core_mux_init);

Diana

