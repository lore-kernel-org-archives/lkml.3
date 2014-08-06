Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaHFIff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 04:35:35 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:3783
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754182AbaHFIfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:35:31 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>
CC: <shengjiu.wang@freescale.com>, <Guangyu.Chen@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 1/3] ARM: clk-imx6q: refine clock tree for ESAI
Date: Wed, 6 Aug 2014 16:35:13 +0800
Message-ID: <cdb30bb5d7f8a61c778ed53988976c4e79f56ace.1407313676.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1407313676.git.shengjiu.wang@freescale.com>
References: <cover.1407313676.git.shengjiu.wang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(93916002)(83322001)(19580405001)(19580395003)(97736001)(80022001)(68736004)(81342001)(31966008)(62966002)(104166001)(102836001)(50986999)(104016003)(99396002)(74662001)(86362001)(74502001)(76176999)(81542001)(26826002)(84676001)(46102001)(76482001)(21056001)(85306004)(77982001)(69596002)(79102001)(95666004)(107046002)(33646002)(87286001)(48376002)(36756003)(50226001)(64706001)(83072002)(4396001)(89996001)(88136002)(77156001)(47776003)(20776003)(85852003)(2201001)(87936001)(50466002)(44976005)(92566001)(106466001)(105606002)(229853001)(81156004)(92726001)(6806004);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB338;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 02951C14DC
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are three clock for ESAI, esai_extal, esai_ipg, esai_mem. Rename
'esai' to 'esai_extal', 'esai_ahb' to 'esai_mem', and add 'esai_ipg'.
Make the clock for ESAI more clear and align them with imx6sx.

Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 arch/arm/mach-imx/clk-imx6q.c             |    7 ++++---
 include/dt-bindings/clock/imx6qdl-clock.h |    7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index 6cceb77..1d6dd59 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -64,7 +64,7 @@ static const char *cko2_sels[] = {
 	"ipu2", "vdo_axi", "osc", "gpu2d_core",
 	"gpu3d_core", "usdhc2", "ssi1", "ssi2",
 	"ssi3", "gpu3d_shader", "vpu_axi", "can_root",
-	"ldb_di0", "ldb_di1", "esai", "eim_slow",
+	"ldb_di0", "ldb_di1", "esai_extal", "eim_slow",
 	"uart_serial", "spdif", "asrc", "hsi_tx",
 };
 static const char *cko_sels[] = { "cko1", "cko2", };
@@ -325,8 +325,9 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	else
 		clk[IMX6Q_CLK_ECSPI5] = imx_clk_gate2("ecspi5",        "ecspi_root",        base + 0x6c, 8);
 	clk[IMX6QDL_CLK_ENET]         = imx_clk_gate2("enet",          "ipg",               base + 0x6c, 10);
-	clk[IMX6QDL_CLK_ESAI]         = imx_clk_gate2_shared("esai",   "esai_podf",         base + 0x6c, 16, &share_count_esai);
-	clk[IMX6QDL_CLK_ESAI_AHB]     = imx_clk_gate2_shared("esai_ahb", "ahb",             base + 0x6c, 16, &share_count_esai);
+	clk[IMX6QDL_CLK_ESAI_EXTAL]   = imx_clk_gate2_shared("esai_extal",   "esai_podf",   base + 0x6c, 16, &share_count_esai);
+	clk[IMX6QDL_CLK_ESAI_IPG]     = imx_clk_gate2_shared("esai_ipg",   "ipg",           base + 0x6c, 16, &share_count_esai);
+	clk[IMX6QDL_CLK_ESAI_MEM]     = imx_clk_gate2_shared("esai_mem", "ahb",             base + 0x6c, 16, &share_count_esai);
 	clk[IMX6QDL_CLK_GPT_IPG]      = imx_clk_gate2("gpt_ipg",       "ipg",               base + 0x6c, 20);
 	clk[IMX6QDL_CLK_GPT_IPG_PER]  = imx_clk_gate2("gpt_ipg_per",   "ipg_per",           base + 0x6c, 22);
 	if (cpu_is_imx6dl())
diff --git a/include/dt-bindings/clock/imx6qdl-clock.h b/include/dt-bindings/clock/imx6qdl-clock.h
index 654151e..323e865 100644
--- a/include/dt-bindings/clock/imx6qdl-clock.h
+++ b/include/dt-bindings/clock/imx6qdl-clock.h
@@ -128,7 +128,7 @@
 #define IMX6Q_CLK_ECSPI5			116
 #define IMX6DL_CLK_I2C4				116
 #define IMX6QDL_CLK_ENET			117
-#define IMX6QDL_CLK_ESAI			118
+#define IMX6QDL_CLK_ESAI_EXTAL			118
 #define IMX6QDL_CLK_GPT_IPG			119
 #define IMX6QDL_CLK_GPT_IPG_PER			120
 #define IMX6QDL_CLK_GPU2D_CORE			121
@@ -218,7 +218,8 @@
 #define IMX6QDL_CLK_LVDS2_SEL			205
 #define IMX6QDL_CLK_LVDS1_GATE			206
 #define IMX6QDL_CLK_LVDS2_GATE			207
-#define IMX6QDL_CLK_ESAI_AHB			208
-#define IMX6QDL_CLK_END				209
+#define IMX6QDL_CLK_ESAI_IPG			208
+#define IMX6QDL_CLK_ESAI_MEM			209
+#define IMX6QDL_CLK_END				210
 
 #endif /* __DT_BINDINGS_CLOCK_IMX6QDL_H */
-- 
1.7.9.5

