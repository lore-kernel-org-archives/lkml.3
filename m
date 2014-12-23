Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbaLWKBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:01:00 -0500
Received: from mail-bn1on0148.outbound.protection.outlook.com ([157.56.110.148]:25844
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755900AbaLWJ73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 04:59:29 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v4 18/21] ARM: dts: imx6qdl-sabresd: Add support for TRULY TFT480800-16-E MIPI DSI panel
Date: Tue, 23 Dec 2014 18:02:16 +0800
Message-ID: <1419328939-22758-19-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419328939-22758-1-git-send-email-Ying.Liu@freescale.com>
References: <1419328939-22758-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(104016003)(77156002)(575784001)(84676001)(229853001)(50466002)(48376002)(107046002)(46102003)(106466001)(19580405001)(19580395003)(6806004)(47776003)(20776003)(64706001)(97736003)(62966003)(92566001)(50986999)(76176999)(86362001)(77096005)(68736005)(2950100001)(85426001)(87936001)(36756003)(21056001)(31966008)(120916001)(50226001)(2351001)(4396001)(110136001)(99396003)(230783001)(105606002)(89996001)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0627;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0627;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0627;
X-Forefront-PRVS: 04347F8039
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0627;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2014 09:59:25.7818
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0627
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TRULY TFT480800-16-E panel is driven by the Himax HX8369A driver IC.
The driver IC supports several display/control interface modes, including
the MIPI DSI video mode and command mode.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v3->v4:
 * None.

v2->v3:
 * None.

v1->v2:
 * To address Thierry Reding's comments, remove several unnecessary
   properties as they can be implied by the compatible string.
 * Fix the compatible string.
 * Remove the display-timings node from the panel node as it can be
   implied by the compatible string as well.
 * Remove the status property as it is unneeded.

 arch/arm/boot/dts/imx6qdl-sabresd.dtsi | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index baf2f00..658bde9 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -482,6 +482,13 @@
 				MX6QDL_PAD_SD4_DAT7__SD4_DATA7		0x17059
 			>;
 		};
+
+		pinctrl_mipi_panel: mipipanelgrp {
+			fsl,pins = <
+				MX6QDL_PAD_NANDF_CS0__GPIO6_IO11 0x1b0b0
+				MX6QDL_PAD_NANDF_CS1__GPIO6_IO14 0x1b0b0
+			>;
+		};
 	};
 
 	gpio_leds {
@@ -518,6 +525,19 @@
 	};
 };
 
+&mipi_dsi {
+	status = "okay";
+
+	panel {
+		compatible = "truly,tft480800-16-e-dsi";
+		reg = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_mipi_panel>;
+		reset-gpios = <&gpio6 11 GPIO_ACTIVE_LOW>;
+		bs2-gpios = <&gpio6 14 GPIO_ACTIVE_HIGH>;
+	};
+};
+
 &pcie {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_pcie>;
-- 
2.1.0

