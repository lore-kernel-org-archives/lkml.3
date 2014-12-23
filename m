Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaLWDnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:43:13 -0500
Received: from mail-bn1on0143.outbound.protection.outlook.com ([157.56.110.143]:53886
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754711AbaLWDnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:43:08 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v3 07/18] ARM: imx6q: clk: Change hsi_tx clock to be a shared clock gate
Date: Tue, 23 Dec 2014 11:46:28 +0800
Message-ID: <1419306399-9387-8-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419306399-9387-1-git-send-email-Ying.Liu@freescale.com>
References: <1419306399-9387-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(47776003)(20776003)(50466002)(50226001)(64706001)(36756003)(110136001)(6806004)(19580395003)(19580405001)(92566001)(106466001)(86362001)(97736003)(104016003)(48376002)(2351001)(105606002)(120916001)(107046002)(46102003)(4396001)(99396003)(229853001)(21056001)(84676001)(77156002)(87936001)(50986999)(77096005)(89996001)(85426001)(76176999)(62966003)(2950100001)(31966008)(68736005)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0635;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0635;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0635;
X-Forefront-PRVS: 04347F8039
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0635;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2014 03:43:05.2728
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB0635
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CG8 field of the CCM CCGR3 register is named as 'mipi_core_cfg'
clock, according to the i.MX6q/sdl reference manuals.  This clock is
actually the gate for several clocks, including the hsi_tx_sel clock's
output and the video_27m clock's output.  So, this patch changes the
hsi_tx clock to be a shared clock gate.

Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v2->v3:
 * Newly introduced in v3.

 arch/arm/mach-imx/clk-imx6q.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index f19472a..080d5b7 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -119,6 +119,7 @@ static unsigned int share_count_asrc;
 static unsigned int share_count_ssi1;
 static unsigned int share_count_ssi2;
 static unsigned int share_count_ssi3;
+static unsigned int share_count_mipi_core_cfg;
 
 static void __init imx6q_clocks_init(struct device_node *ccm_node)
 {
@@ -416,7 +417,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	clk[IMX6QDL_CLK_LDB_DI0]      = imx_clk_gate2("ldb_di0",       "ldb_di0_podf",      base + 0x74, 12);
 	clk[IMX6QDL_CLK_LDB_DI1]      = imx_clk_gate2("ldb_di1",       "ldb_di1_podf",      base + 0x74, 14);
 	clk[IMX6QDL_CLK_IPU2_DI1]     = imx_clk_gate2("ipu2_di1",      "ipu2_di1_sel",      base + 0x74, 10);
-	clk[IMX6QDL_CLK_HSI_TX]       = imx_clk_gate2("hsi_tx",        "hsi_tx_podf",       base + 0x74, 16);
+	clk[IMX6QDL_CLK_HSI_TX]       = imx_clk_gate2_shared("hsi_tx", "hsi_tx_podf",       base + 0x74, 16, &share_count_mipi_core_cfg);
 	if (cpu_is_imx6dl())
 		/*
 		 * The multiplexer and divider of the imx6q clock gpu2d get
-- 
2.1.0

