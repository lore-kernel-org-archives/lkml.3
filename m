Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaIYJsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:48:04 -0400
Received: from mail-by2on0104.outbound.protection.outlook.com ([207.46.100.104]:43712
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752277AbaIYJsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:48:01 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: "mturquette@linaro.org" <mturquette@linaro.org>,
        Scott Wood <scottwood@freescale.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
 CLK_OF_DECLARE support
Thread-Topic: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
 CLK_OF_DECLARE support
Thread-Index: AQHP1wGYMBQEa9GSl0OI/HOhX0hHNpwRlvDQ
Date: Thu, 25 Sep 2014 09:47:59 +0000
Message-ID: <d4a375f40b544cf1ae78ac82dc20569c@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1411454806-8214-1-git-send-email-jingchang.lu@freescale.com>
In-Reply-To: <1411454806-8214-1-git-send-email-jingchang.lu@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB466;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(51704005)(13464003)(189002)(199003)(31966008)(85306004)(2501002)(80022003)(108616004)(106116001)(101416001)(54356999)(64706001)(76176999)(50986999)(19580395003)(19580405001)(20776003)(99396003)(83322001)(83072002)(106356001)(90102001)(107046002)(76482002)(86362001)(21056001)(99286002)(76576001)(2656002)(4396001)(97736003)(81542003)(105586002)(87936001)(33646002)(74502003)(95666004)(46102003)(77982003)(66066001)(79102003)(74316001)(120916001)(81342003)(74662003)(10300001)(92566001)(85852003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB466;H:BL2PR03MB467.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8P9mAN0022033

Hi, Scott and Mike,
  
  Could you please help review this patch and give an ACK if ok. Thanks.

Best Regards,
Jingchang

>-----Original Message-----
>From: Jingchang Lu [mailto:jingchang.lu@freescale.com]
>Sent: Tuesday, September 23, 2014 2:47 PM
>To: mturquette@linaro.org
>Cc: Wood Scott-B07421; linuxppc-dev@lists.ozlabs.org; linux-
>kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Lu
>Jingchang-B35083
>Subject: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
>CLK_OF_DECLARE support
>
>The IP is shared by PPC and ARM, this renames it to qoriq for better
>represention, and this also adds the CLK_OF_DECLARE support for being
>initialized by of_clk_init() on ARM.
>
>Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
>---
>changes in v4:
> remove "corenet" literals omitted in v3 remove.
>
>changes in v3:
> generate the patch with -M -C option
>
>changes in v2:
> rename the driver name to ppc-qoriq.c for shared on PPC and ARM.
>
> drivers/clk/Kconfig                            |  9 +++++----
> drivers/clk/Makefile                           |  2 +-
> drivers/clk/{clk-ppc-corenet.c => clk-qoriq.c} | 27 +++++++++++++++------
>-----
> 3 files changed, 22 insertions(+), 16 deletions(-)  rename
>drivers/clk/{clk-ppc-corenet.c => clk-qoriq.c} (89%)
>
>diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig index
>85131ae..f5f76cb 100644
>--- a/drivers/clk/Kconfig
>+++ b/drivers/clk/Kconfig
>@@ -92,12 +92,13 @@ config COMMON_CLK_AXI_CLKGEN
> 	  Support for the Analog Devices axi-clkgen pcore clock generator
>for Xilinx
> 	  FPGAs. It is commonly used in Analog Devices' reference designs.
>
>-config CLK_PPC_CORENET
>-	bool "Clock driver for PowerPC corenet platforms"
>-	depends on PPC_E500MC && OF
>+config CLK_QORIQ
>+	bool "Clock driver for PowerPC corenet and compatible ARM-based
>platforms"
>+	depends on (PPC_E500MC || ARM) && OF
> 	---help---
> 	  This adds the clock driver support for Freescale PowerPC corenet
>-	  platforms using common clock framework.
>+	  platforms and compatible Freescale ARM based platforms using
>common
>+	  clock framework.
>
> config COMMON_CLK_XGENE
> 	bool "Clock driver for APM XGene SoC"
>diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile index
>27c542b..20f42e9 100644
>--- a/drivers/clk/Makefile
>+++ b/drivers/clk/Makefile
>@@ -29,7 +29,7 @@ obj-$(CONFIG_ARCH_MOXART)		+= clk-moxart.o
> obj-$(CONFIG_ARCH_NOMADIK)		+= clk-nomadik.o
> obj-$(CONFIG_ARCH_NSPIRE)		+= clk-nspire.o
> obj-$(CONFIG_COMMON_CLK_PALMAS)		+= clk-palmas.o
>-obj-$(CONFIG_CLK_PPC_CORENET)		+= clk-ppc-corenet.o
>+obj-$(CONFIG_CLK_QORIQ)			+= clk-qoriq.o
> obj-$(CONFIG_COMMON_CLK_S2MPS11)	+= clk-s2mps11.o
> obj-$(CONFIG_COMMON_CLK_SI5351)		+= clk-si5351.o
> obj-$(CONFIG_COMMON_CLK_SI570)		+= clk-si570.o
>diff --git a/drivers/clk/clk-ppc-corenet.c b/drivers/clk/clk-qoriq.c
>similarity index 89% rename from drivers/clk/clk-ppc-corenet.c rename to
>drivers/clk/clk-qoriq.c index 8e58edf..cba8abe 100644
>--- a/drivers/clk/clk-ppc-corenet.c
>+++ b/drivers/clk/clk-qoriq.c
>@@ -155,7 +155,7 @@ static void __init core_pll_init(struct device_node
>*np)
>
> 	base = of_iomap(np, 0);
> 	if (!base) {
>-		pr_err("clk-ppc: iomap error\n");
>+		pr_err("clk-qoriq: iomap error\n");
> 		return;
> 	}
>
>@@ -252,7 +252,7 @@ static void __init sysclk_init(struct device_node
>*node)
> 	u32 rate;
>
> 	if (!np) {
>-		pr_err("ppc-clk: could not get parent node\n");
>+		pr_err("qoriq-clk: could not get parent node\n");
> 		return;
> 	}
>
>@@ -278,30 +278,35 @@ static const struct of_device_id clk_match[]
>__initconst = {
> 	{}
> };
>
>-static int __init ppc_corenet_clk_probe(struct platform_device *pdev)
>+static int __init qoriq_clk_probe(struct platform_device *pdev)
> {
> 	of_clk_init(clk_match);
>
> 	return 0;
> }
>
>-static const struct of_device_id ppc_clk_ids[] __initconst = {
>+static const struct of_device_id qoriq_clk_ids[] __initconst = {
> 	{ .compatible = "fsl,qoriq-clockgen-1.0", },
> 	{ .compatible = "fsl,qoriq-clockgen-2.0", },
> 	{}
> };
>
>-static struct platform_driver ppc_corenet_clk_driver __initdata = {
>+static struct platform_driver qoriq_clk_driver __initdata = {
> 	.driver = {
>-		.name = "ppc_corenet_clock",
>+		.name = "qoriq_clock",
> 		.owner = THIS_MODULE,
>-		.of_match_table = ppc_clk_ids,
>+		.of_match_table = qoriq_clk_ids,
> 	},
>-	.probe = ppc_corenet_clk_probe,
>+	.probe = qoriq_clk_probe,
> };
>
>-static int __init ppc_corenet_clk_init(void)
>+static int __init qoriq_clk_init(void)
> {
>-	return platform_driver_register(&ppc_corenet_clk_driver);
>+	return platform_driver_register(&qoriq_clk_driver);
> }
>-subsys_initcall(ppc_corenet_clk_init);
>+subsys_initcall(qoriq_clk_init);
>+
>+CLK_OF_DECLARE(qoriq_core_pll_v1, "fsl,qoriq-core-pll-1.0",
>+core_pll_init); CLK_OF_DECLARE(qoriq_core_pll_v2,
>+"fsl,qoriq-core-pll-2.0", core_pll_init);
>+CLK_OF_DECLARE(qoriq_core_mux_v1, "fsl,qoriq-core-mux-1.0",
>+core_mux_init); CLK_OF_DECLARE(qoriq_core_mux_v2,
>+"fsl,qoriq-core-mux-2.0", core_mux_init);
>--
>1.8.0

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
