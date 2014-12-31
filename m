Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaLaITs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:19:48 -0500
Received: from mail-bn1on0139.outbound.protection.outlook.com ([157.56.110.139]:32156
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751726AbaLaITp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:19:45 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v8 05/21] ARM: imx6q: clk: Add the video_27m clock
Date: Wed, 31 Dec 2014 16:23:23 +0800
Message-ID: <1420014219-915-6-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420014219-915-1-git-send-email-Ying.Liu@freescale.com>
References: <1420014219-915-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(97736003)(86362001)(21056001)(81156004)(4396001)(2950100001)(77096005)(68736005)(50226001)(87936001)(92566001)(99396003)(50986999)(76176999)(20776003)(19580405001)(6806004)(69596002)(89996001)(110136001)(120916001)(36756003)(106466001)(85426001)(84676001)(50466002)(47776003)(77156002)(48376002)(46102003)(229853001)(31966008)(19580395003)(62966003)(107046002)(104016003)(2351001)(64706001)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0634;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0634;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0634;
X-Forefront-PRVS: 0442E569BC
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0634;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2014 08:19:42.1392
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB0634
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports the video_27m clock which is a fixed factor
clock of the pll3_pfd1_540m clock.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v7->v8:
 * None.

v6->v7:
 * None.

v5->v6:
 * None.

v4->v5:
 * None.

v3->v4:
 * None.

v2->v3:
 * None.

v1->v2:
 * None.

 arch/arm/mach-imx/clk-imx6q.c             | 1 +
 include/dt-bindings/clock/imx6qdl-clock.h | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index 4e79da7..9470df3 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -246,6 +246,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	clk[IMX6QDL_CLK_PLL3_60M]  = imx_clk_fixed_factor("pll3_60m",  "pll3_usb_otg",   1, 8);
 	clk[IMX6QDL_CLK_TWD]       = imx_clk_fixed_factor("twd",       "arm",            1, 2);
 	clk[IMX6QDL_CLK_GPT_3M]    = imx_clk_fixed_factor("gpt_3m",    "osc",            1, 8);
+	clk[IMX6QDL_CLK_VIDEO_27M] = imx_clk_fixed_factor("video_27m", "pll3_pfd1_540m", 1, 20);
 	if (cpu_is_imx6dl()) {
 		clk[IMX6QDL_CLK_GPU2D_AXI] = imx_clk_fixed_factor("gpu2d_axi", "mmdc_ch0_axi_podf", 1, 1);
 		clk[IMX6QDL_CLK_GPU3D_AXI] = imx_clk_fixed_factor("gpu3d_axi", "mmdc_ch0_axi_podf", 1, 1);
diff --git a/include/dt-bindings/clock/imx6qdl-clock.h b/include/dt-bindings/clock/imx6qdl-clock.h
index b690cdb..25625bf 100644
--- a/include/dt-bindings/clock/imx6qdl-clock.h
+++ b/include/dt-bindings/clock/imx6qdl-clock.h
@@ -248,6 +248,7 @@
 #define IMX6QDL_PLL6_BYPASS			235
 #define IMX6QDL_PLL7_BYPASS			236
 #define IMX6QDL_CLK_GPT_3M			237
-#define IMX6QDL_CLK_END				238
+#define IMX6QDL_CLK_VIDEO_27M			238
+#define IMX6QDL_CLK_END				239
 
 #endif /* __DT_BINDINGS_CLOCK_IMX6QDL_H */
-- 
2.1.0

