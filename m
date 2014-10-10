Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaJJKAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:00:36 -0400
Received: from mail-bl2on0122.outbound.protection.outlook.com ([65.55.169.122]:38352
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751293AbaJJKAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:00:34 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <mturquette@linaro.org>
CC: <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: [PATCHv5] clk: ppc-corenet: rename to qoriq and add CLK_OF_DECLARE support
Date: Fri, 10 Oct 2014 17:14:57 +0800
Message-ID: <1412932497-27995-1-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(93916002)(86362001)(84676001)(50466002)(48376002)(4396001)(92726001)(92566001)(46102003)(80022003)(97736003)(50226001)(85306004)(99396003)(120916001)(104166001)(31966008)(21056001)(87286001)(69596002)(89996001)(68736004)(88136002)(6806004)(102836001)(19580395003)(44976005)(76482002)(85852003)(19580405001)(33646002)(104016003)(110136001)(81156004)(107046002)(36756003)(20776003)(106466001)(2351001)(87936001)(50986999)(47776003)(64706001)(229853001)(105606002)(26826002)(77156001)(95666004)(62966002)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB480;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB480;
X-Forefront-PRVS: 03607C04F0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=jingchang.lu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IP is shared by PPC and ARM, this renames it to qoriq for better
represention, and this also adds the CLK_OF_DECLARE support for being
initialized by of_clk_init() on ARM.

Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
changes in v5:
 update drivers/cpufreq/Kconfig.powerpc to slect the renamed config option.

changes in v4:
 remove "corenet" literals omitted in v3 remove.

changes in v3:
 generate the patch with -M -C option

changes in v2:
 rename the driver name to ppc-qoriq.c for shared on PPC and ARM.

 drivers/clk/Kconfig                            | 10 ++++-----
 drivers/clk/Makefile                           |  2 +-
 drivers/clk/{clk-ppc-corenet.c => clk-qoriq.c} | 29 +++++++++++++++-----------
 drivers/cpufreq/Kconfig.powerpc                |  2 +-
 4 files changed, 24 insertions(+), 19 deletions(-)
 rename drivers/clk/{clk-ppc-corenet.c => clk-qoriq.c} (89%)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 455fd17..4706a9f 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -101,12 +101,12 @@ config COMMON_CLK_AXI_CLKGEN
 	  Support for the Analog Devices axi-clkgen pcore clock generator for Xilinx
 	  FPGAs. It is commonly used in Analog Devices' reference designs.
 
-config CLK_PPC_CORENET
-	bool "Clock driver for PowerPC corenet platforms"
-	depends on PPC_E500MC && OF
+config CLK_QORIQ
+	bool "Clock driver for Freescale QorIQ platforms"
+	depends on (PPC_E500MC || ARM) && OF
 	---help---
-	  This adds the clock driver support for Freescale PowerPC corenet
-	  platforms using common clock framework.
+	  This adds the clock driver support for Freescale QorIQ platforms
+	  using common clock framework.
 
 config COMMON_CLK_XGENE
 	bool "Clock driver for APM XGene SoC"
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index d5fba5b..4ff94cd 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -30,7 +30,7 @@ obj-$(CONFIG_ARCH_MOXART)		+= clk-moxart.o
 obj-$(CONFIG_ARCH_NOMADIK)		+= clk-nomadik.o
 obj-$(CONFIG_ARCH_NSPIRE)		+= clk-nspire.o
 obj-$(CONFIG_COMMON_CLK_PALMAS)		+= clk-palmas.o
-obj-$(CONFIG_CLK_PPC_CORENET)		+= clk-ppc-corenet.o
+obj-$(CONFIG_CLK_QORIQ)			+= clk-qoriq.o
 obj-$(CONFIG_COMMON_CLK_RK808)		+= clk-rk808.o
 obj-$(CONFIG_COMMON_CLK_S2MPS11)	+= clk-s2mps11.o
 obj-$(CONFIG_COMMON_CLK_SI5351)		+= clk-si5351.o
diff --git a/drivers/clk/clk-ppc-corenet.c b/drivers/clk/clk-qoriq.c
similarity index 89%
rename from drivers/clk/clk-ppc-corenet.c
rename to drivers/clk/clk-qoriq.c
index 8e58edf..48cb923 100644
--- a/drivers/clk/clk-ppc-corenet.c
+++ b/drivers/clk/clk-qoriq.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * clock driver for Freescale PowerPC corenet SoCs.
+ * clock driver for Freescale QorIQ SoCs.
  */
 #include <linux/clk-provider.h>
 #include <linux/io.h>
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
diff --git a/drivers/cpufreq/Kconfig.powerpc b/drivers/cpufreq/Kconfig.powerpc
index 72564b7..7ea2441 100644
--- a/drivers/cpufreq/Kconfig.powerpc
+++ b/drivers/cpufreq/Kconfig.powerpc
@@ -26,7 +26,7 @@ config CPU_FREQ_MAPLE
 config PPC_CORENET_CPUFREQ
 	tristate "CPU frequency scaling driver for Freescale E500MC SoCs"
 	depends on PPC_E500MC && OF && COMMON_CLK
-	select CLK_PPC_CORENET
+	select CLK_QORIQ
 	help
 	  This adds the CPUFreq driver support for Freescale e500mc,
 	  e5500 and e6500 series SoCs which are capable of changing
-- 
1.8.0

