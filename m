Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaHVKZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 06:25:25 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:42569
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751844AbaHVKZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 06:25:23 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: [RESEND] clk: ppc-corenet: Add Freescale ARM-based platforms CLK_OF_DECLARE support
Date: Fri, 22 Aug 2014 17:34:56 +0800
Message-ID: <1408700096-25415-1-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(36756003)(4396001)(99396002)(62966002)(26826002)(83322001)(68736004)(92726001)(50466002)(47776003)(19580395003)(48376002)(44976005)(19580405001)(46102001)(74662001)(6806004)(92566001)(85306004)(74502001)(81156004)(90102001)(89996001)(81542001)(107046002)(87286001)(21056001)(77156001)(110136001)(93916002)(81342001)(77982001)(64706001)(86362001)(97736001)(2351001)(83072002)(79102001)(69596002)(105606002)(84676001)(95666004)(31966008)(87936001)(102836001)(33646002)(20776003)(80022001)(85852003)(50986999)(76482001)(50226001)(229853001)(104016003)(106466001)(104166001)(88136002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB465;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 0311124FA9
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=jingchang.lu@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
 drivers/clk/Kconfig           | 7 ++++---
 drivers/clk/clk-ppc-corenet.c | 5 +++++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index cfd3af7..8784704 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -82,11 +82,12 @@ config COMMON_CLK_AXI_CLKGEN
 	  FPGAs. It is commonly used in Analog Devices' reference designs.
 
 config CLK_PPC_CORENET
-	bool "Clock driver for PowerPC corenet platforms"
-	depends on PPC_E500MC && OF
+	bool "Clock driver for PowerPC corenet and compatible ARM-based platforms"
+	depends on (PPC_E500MC || ARM) && OF
 	---help---
 	  This adds the clock driver support for Freescale PowerPC corenet
-	  platforms using common clock framework.
+	  platforms and compatible Freescale ARM based platforms using common
+	  clock framework.
 
 config COMMON_CLK_XGENE
 	bool "Clock driver for APM XGene SoC"
diff --git a/drivers/clk/clk-ppc-corenet.c b/drivers/clk/clk-ppc-corenet.c
index 8e58edf..7692cac 100644
--- a/drivers/clk/clk-ppc-corenet.c
+++ b/drivers/clk/clk-ppc-corenet.c
@@ -305,3 +305,8 @@ static int __init ppc_corenet_clk_init(void)
 	return platform_driver_register(&ppc_corenet_clk_driver);
 }
 subsys_initcall(ppc_corenet_clk_init);
+
+CLK_OF_DECLARE(ppc_core_pll_v1, "fsl,qoriq-core-pll-1.0", core_pll_init);
+CLK_OF_DECLARE(ppc_core_pll_v2, "fsl,qoriq-core-pll-2.0", core_pll_init);
+CLK_OF_DECLARE(ppc_core_mux_v1, "fsl,qoriq-core-mux-1.0", core_mux_init);
+CLK_OF_DECLARE(ppc_core_mux_v2, "fsl,qoriq-core-mux-2.0", core_mux_init);
-- 
1.8.0

