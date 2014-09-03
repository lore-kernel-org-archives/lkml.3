Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbaICJff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:35:35 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:15774
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751319AbaICJfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:35:32 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <mturquette@linaro.org>
CC: <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: [PATCHv3] clk: ppc-corenet: rename to ppc-qoriq and add CLK_OF_DECLARE support
Date: Wed, 3 Sep 2014 16:44:13 +0800
Message-ID: <1409733853-19727-1-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(50986999)(6806004)(31966008)(74662001)(74502001)(26826002)(62966002)(69596002)(44976005)(46102001)(102836001)(104016003)(68736004)(99396002)(97736001)(85306004)(33646002)(19580405001)(36756003)(19580395003)(83322001)(110136001)(21056001)(83072002)(64706001)(85852003)(50466002)(107046002)(105606002)(90102001)(79102001)(80022001)(104166001)(87286001)(86362001)(89996001)(229853001)(50226001)(88136002)(92726001)(48376002)(77156001)(76482001)(81542001)(84676001)(77982001)(4396001)(2351001)(95666004)(575784001)(93916002)(92566001)(87936001)(20776003)(106466001)(47776003)(81342001)(81156004);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB480;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 032334F434
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=jingchang.lu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IP is shared on PPC and ARM, this rename it to qoriq for better
represention, and this also add the CLK_OF_DECLARE support for being
initialized by of_clk_init() on ARM.

Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
changes in v3:
 generate the patch with -M -C option

changes in v2:
 rename the driver name to ppc-qoriq.c for shared on PPC and ARM.

 drivers/clk/Kconfig                            |  9 +++++----
 drivers/clk/Makefile                           |  2 +-
 drivers/clk/{clk-ppc-corenet.c => clk-qoriq.c} | 27 +++++++++++++++-----------
 3 files changed, 22 insertions(+), 16 deletions(-)
 rename drivers/clk/{clk-ppc-corenet.c => clk-qoriq.c} (88%)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index cfd3af7..d7892b9 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -81,12 +81,13 @@ config COMMON_CLK_AXI_CLKGEN
 	  Support for the Analog Devices axi-clkgen pcore clock generator for Xilinx
 	  FPGAs. It is commonly used in Analog Devices' reference designs.
 
-config CLK_PPC_CORENET
-	bool "Clock driver for PowerPC corenet platforms"
-	depends on PPC_E500MC && OF
+config CLK_QORIQ
+	bool "Clock driver for PowerPC corenet and compatible ARM-based platforms"
+	depends on (PPC_E500MC || ARM) && OF
 	---help---
 	  This adds the clock driver support for Freescale PowerPC corenet
-	  platforms using common clock framework.
+	  platforms and compatible Freescale ARM based platforms using common
+	  clock framework.
 
 config COMMON_CLK_XGENE
 	bool "Clock driver for APM XGene SoC"
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index f537a0b..5ca4b72 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -27,7 +27,7 @@ obj-$(CONFIG_ARCH_MOXART)		+= clk-moxart.o
 obj-$(CONFIG_ARCH_NOMADIK)		+= clk-nomadik.o
 obj-$(CONFIG_ARCH_NSPIRE)		+= clk-nspire.o
 obj-$(CONFIG_COMMON_CLK_PALMAS)		+= clk-palmas.o
-obj-$(CONFIG_CLK_PPC_CORENET)		+= clk-ppc-corenet.o
+obj-$(CONFIG_CLK_QORIQ)			+= clk-qoriq.o
 obj-$(CONFIG_COMMON_CLK_S2MPS11)	+= clk-s2mps11.o
 obj-$(CONFIG_COMMON_CLK_SI5351)		+= clk-si5351.o
 obj-$(CONFIG_COMMON_CLK_SI570)		+= clk-si570.o
diff --git a/drivers/clk/clk-ppc-corenet.c b/drivers/clk/clk-qoriq.c
similarity index 88%
rename from drivers/clk/clk-ppc-corenet.c
rename to drivers/clk/clk-qoriq.c
index 8e58edf..5053f46 100644
--- a/drivers/clk/clk-ppc-corenet.c
+++ b/drivers/clk/clk-qoriq.c
@@ -155,7 +155,7 @@ static void __init core_pll_init(struct device_node *np)
 
 	base = of_iomap(np, 0);
 	if (!base) {
-		pr_err("clk-ppc: iomap error\n");
+		pr_err("clk-qoriq: iomap error\n");
 		return;
 	}
 
@@ -252,7 +252,7 @@ static void __init sysclk_init(struct device_node *node)
 	u32 rate;
 
 	if (!np) {
-		pr_err("ppc-clk: could not get parent node\n");
+		pr_err("qoriq-clk: could not get parent node\n");
 		return;
 	}
 
@@ -278,30 +278,35 @@ static const struct of_device_id clk_match[] __initconst = {
 	{}
 };
 
-static int __init ppc_corenet_clk_probe(struct platform_device *pdev)
+static int __init qoriq_corenet_clk_probe(struct platform_device *pdev)
 {
 	of_clk_init(clk_match);
 
 	return 0;
 }
 
-static const struct of_device_id ppc_clk_ids[] __initconst = {
+static const struct of_device_id qoriq_clk_ids[] __initconst = {
 	{ .compatible = "fsl,qoriq-clockgen-1.0", },
 	{ .compatible = "fsl,qoriq-clockgen-2.0", },
 	{}
 };
 
-static struct platform_driver ppc_corenet_clk_driver __initdata = {
+static struct platform_driver qoriq_corenet_clk_driver __initdata = {
 	.driver = {
-		.name = "ppc_corenet_clock",
+		.name = "qoriq_corenet_clock",
 		.owner = THIS_MODULE,
-		.of_match_table = ppc_clk_ids,
+		.of_match_table = qoriq_clk_ids,
 	},
-	.probe = ppc_corenet_clk_probe,
+	.probe = qoriq_corenet_clk_probe,
 };
 
-static int __init ppc_corenet_clk_init(void)
+static int __init qoriq_corenet_clk_init(void)
 {
-	return platform_driver_register(&ppc_corenet_clk_driver);
+	return platform_driver_register(&qoriq_corenet_clk_driver);
 }
-subsys_initcall(ppc_corenet_clk_init);
+subsys_initcall(qoriq_corenet_clk_init);
+
+CLK_OF_DECLARE(qoriq_core_pll_v1, "fsl,qoriq-core-pll-1.0", core_pll_init);
+CLK_OF_DECLARE(qoriq_core_pll_v2, "fsl,qoriq-core-pll-2.0", core_pll_init);
+CLK_OF_DECLARE(qoriq_core_mux_v1, "fsl,qoriq-core-mux-1.0", core_mux_init);
+CLK_OF_DECLARE(qoriq_core_mux_v2, "fsl,qoriq-core-mux-2.0", core_mux_init);
-- 
1.8.0

