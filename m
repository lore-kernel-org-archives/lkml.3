Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaIWHy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:54:28 -0400
Received: from mail-bl2on0105.outbound.protection.outlook.com ([65.55.169.105]:31920
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751989AbaIWHy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:54:26 -0400
X-Greylist: delayed 858 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 03:54:26 EDT
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <mturquette@linaro.org>
CC: <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add CLK_OF_DECLARE support
Date: Tue, 23 Sep 2014 14:46:46 +0800
Message-ID: <1411454806-8214-1-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(99396002)(110136001)(74502003)(102836001)(44976005)(89996001)(80022003)(69596002)(50226001)(90102001)(79102003)(47776003)(4396001)(21056001)(19580405001)(106466001)(64706001)(50986999)(120916001)(68736004)(83322001)(87286001)(62966002)(2351001)(84676001)(92726001)(48376002)(76482002)(6806004)(92566001)(93916002)(97736003)(104166001)(33646002)(105606002)(104016003)(95666004)(77982003)(20776003)(74662003)(81542003)(31966008)(36756003)(77156001)(19580395003)(83072002)(46102003)(229853001)(85306004)(81156004)(50466002)(88136002)(81342003)(87936001)(85852003)(86362001)(107046002)(10300001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0722;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0722;
X-Forefront-PRVS: 0343AC1D30
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=jingchang.lu@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0641;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IP is shared by PPC and ARM, this renames it to qoriq for better
represention, and this also adds the CLK_OF_DECLARE support for being
initialized by of_clk_init() on ARM.

Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
changes in v4:
 remove "corenet" literals omitted in v3 remove.

changes in v3:
 generate the patch with -M -C option

changes in v2:
 rename the driver name to ppc-qoriq.c for shared on PPC and ARM.

 drivers/clk/Kconfig                            |  9 +++++----
 drivers/clk/Makefile                           |  2 +-
 drivers/clk/{clk-ppc-corenet.c => clk-qoriq.c} | 27 +++++++++++++++-----------
 3 files changed, 22 insertions(+), 16 deletions(-)
 rename drivers/clk/{clk-ppc-corenet.c => clk-qoriq.c} (89%)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 85131ae..f5f76cb 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -92,12 +92,13 @@ config COMMON_CLK_AXI_CLKGEN
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
index 27c542b..20f42e9 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -29,7 +29,7 @@ obj-$(CONFIG_ARCH_MOXART)		+= clk-moxart.o
 obj-$(CONFIG_ARCH_NOMADIK)		+= clk-nomadik.o
 obj-$(CONFIG_ARCH_NSPIRE)		+= clk-nspire.o
 obj-$(CONFIG_COMMON_CLK_PALMAS)		+= clk-palmas.o
-obj-$(CONFIG_CLK_PPC_CORENET)		+= clk-ppc-corenet.o
+obj-$(CONFIG_CLK_QORIQ)			+= clk-qoriq.o
 obj-$(CONFIG_COMMON_CLK_S2MPS11)	+= clk-s2mps11.o
 obj-$(CONFIG_COMMON_CLK_SI5351)		+= clk-si5351.o
 obj-$(CONFIG_COMMON_CLK_SI570)		+= clk-si570.o
diff --git a/drivers/clk/clk-ppc-corenet.c b/drivers/clk/clk-qoriq.c
similarity index 89%
rename from drivers/clk/clk-ppc-corenet.c
rename to drivers/clk/clk-qoriq.c
index 8e58edf..cba8abe 100644
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
+static int __init qoriq_clk_probe(struct platform_device *pdev)
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
+static struct platform_driver qoriq_clk_driver __initdata = {
 	.driver = {
-		.name = "ppc_corenet_clock",
+		.name = "qoriq_clock",
 		.owner = THIS_MODULE,
-		.of_match_table = ppc_clk_ids,
+		.of_match_table = qoriq_clk_ids,
 	},
-	.probe = ppc_corenet_clk_probe,
+	.probe = qoriq_clk_probe,
 };
 
-static int __init ppc_corenet_clk_init(void)
+static int __init qoriq_clk_init(void)
 {
-	return platform_driver_register(&ppc_corenet_clk_driver);
+	return platform_driver_register(&qoriq_clk_driver);
 }
-subsys_initcall(ppc_corenet_clk_init);
+subsys_initcall(qoriq_clk_init);
+
+CLK_OF_DECLARE(qoriq_core_pll_v1, "fsl,qoriq-core-pll-1.0", core_pll_init);
+CLK_OF_DECLARE(qoriq_core_pll_v2, "fsl,qoriq-core-pll-2.0", core_pll_init);
+CLK_OF_DECLARE(qoriq_core_mux_v1, "fsl,qoriq-core-mux-1.0", core_mux_init);
+CLK_OF_DECLARE(qoriq_core_mux_v2, "fsl,qoriq-core-mux-2.0", core_mux_init);
-- 
1.8.0

