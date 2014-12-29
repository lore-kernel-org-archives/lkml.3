Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaL2Gi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 01:38:28 -0500
Received: from mail-by2on0109.outbound.protection.outlook.com ([207.46.100.109]:10800
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752177AbaL2Ggv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 01:36:51 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v6 17/21] ARM: dtsi: imx6qdl: Add support for MIPI DSI host controller
Date: Mon, 29 Dec 2014 14:39:24 +0800
Message-ID: <1419835168-9034-18-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419835168-9034-1-git-send-email-Ying.Liu@freescale.com>
References: <1419835168-9034-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(36756003)(19580405001)(50466002)(64706001)(87936001)(19580395003)(89996001)(97736003)(21056001)(47776003)(20776003)(99396003)(85426001)(229853001)(48376002)(106466001)(120916001)(76176999)(50986999)(2351001)(86362001)(104016003)(84676001)(105606002)(107046002)(6806004)(77156002)(68736005)(77096005)(62966003)(46102003)(2950100001)(50226001)(110136001)(4396001)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0626;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0626;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0626;
X-Forefront-PRVS: 0440AC9990
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0626;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2014 06:36:47.8950
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0626
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for MIPI DSI host controller.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v5->v6:
 * None.

v3->v4:
 * None.

v2->v3:
 * As suggested by Phillip Zabel, change the clocks and the clock-names
   properties to use the pllref and core_cfg clocks only.

v1->v2:
 * None.

 arch/arm/boot/dts/imx6qdl.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 96bf2a0..7b1c313 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1006,7 +1006,13 @@
 			mipi_dsi: mipi@021e0000 {
 				#address-cells = <1>;
 				#size-cells = <0>;
+				compatible = "fsl,imx6q-mipi-dsi";
 				reg = <0x021e0000 0x4000>;
+				interrupts = <0 102 IRQ_TYPE_LEVEL_HIGH>;
+				gpr = <&gpr>;
+				clocks = <&clks IMX6QDL_CLK_MIPI_CORE_CFG>,
+					 <&clks IMX6QDL_CLK_MIPI_CORE_CFG>;
+				clock-names = "pllref", "core_cfg";
 				status = "disabled";
 
 				ports {
-- 
2.1.0

