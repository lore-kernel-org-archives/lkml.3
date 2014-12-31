Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaLaIUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:20:42 -0500
Received: from mail-bn1on0117.outbound.protection.outlook.com ([157.56.110.117]:29328
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751986AbaLaIUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:20:37 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v8 18/21] ARM: dts: imx6qdl-sabresd: Add support for TRULY TFT480800-16-E MIPI DSI panel
Date: Wed, 31 Dec 2014 16:23:36 +0800
Message-ID: <1420014219-915-19-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420014219-915-1-git-send-email-Ying.Liu@freescale.com>
References: <1420014219-915-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(50986999)(120916001)(85426001)(46102003)(48376002)(6806004)(97736003)(21056001)(50466002)(229853001)(4396001)(69596002)(92566001)(107046002)(106466001)(19580405001)(2351001)(77156002)(68736005)(87936001)(62966003)(2950100001)(36756003)(19580395003)(84676001)(99396003)(86362001)(20776003)(76176999)(230783001)(89996001)(77096005)(47776003)(31966008)(81156004)(50226001)(64706001)(110136001)(575784001)(104016003)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB1013;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB1013;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR03MB1013;
X-Forefront-PRVS: 0442E569BC
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB1013;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TRULY TFT480800-16-E panel is driven by the Himax HX8369A driver IC.
The driver IC supports several display/control interface modes, including
the MIPI DSI video mode and command mode.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v7->v8:
 * None.

v6->v7:
 * None.

v5->v6:
 * None.

v4->v5:
 * Replace the bs[3:0]-gpios properties with the bs-gpios property.
   This addresses Andrzej Hajda's comment.

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
index baf2f00..4e3a666 100644
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
+		bs-gpios = <0>, <0>, <&gpio6 14 GPIO_ACTIVE_HIGH>, <0>;
+	};
+};
+
 &pcie {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_pcie>;
-- 
2.1.0

