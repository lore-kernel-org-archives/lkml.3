Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaHDKeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:34:00 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:10816
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751409AbaHDKd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:33:59 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: [PATCH] clk: ppc-corenet: Add Freescale ARM-based platforms CLK_OF_DECLARE support
Date: Mon, 4 Aug 2014 17:45:37 +0800
Message-ID: <1407145537-15027-1-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(80022001)(19580405001)(85852003)(97736001)(76482001)(74502001)(69596002)(81542001)(87286001)(20776003)(102836001)(74662001)(50986999)(86362001)(68736004)(31966008)(64706001)(85306004)(50226001)(81342001)(47776003)(4396001)(95666004)(83072002)(6806004)(105606002)(84676001)(92726001)(26826002)(50466002)(99396002)(87936001)(46102001)(79102001)(33646002)(21056001)(19580395003)(36756003)(104016003)(104166001)(77156001)(48376002)(81156004)(93916002)(92566001)(106466001)(2351001)(44976005)(229853001)(110136001)(88136002)(89996001)(83322001)(77982001)(62966002)(107046002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB478;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0293D40691
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=jingchang.lu@freescale.com; 
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

