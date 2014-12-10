Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbaLJItj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:49:39 -0500
Received: from mail-bn1bbn0106.outbound.protection.outlook.com ([157.56.111.106]:52768
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753577AbaLJIth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:49:37 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <p.zabel@pengutronix.de>,
        <thierry.reding@gmail.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <mturquette@linaro.org>, <airlied@linux.ie>
Subject: [PATCH RFC 12/15] ARM: dts: imx6qdl-sabresd: Add support for TRULY TFT480800-16-E MIPI DSI panel
Date: Wed, 10 Dec 2014 16:37:25 +0800
Message-ID: <1418200648-32656-13-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
References: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(48376002)(68736005)(77096005)(50466002)(31966008)(92566001)(46102003)(36756003)(230783001)(104016003)(4396001)(50226001)(110136001)(50986999)(106466001)(97736003)(99396003)(19580395003)(19580405001)(87936001)(84676001)(76176999)(105606002)(21056001)(107046002)(20776003)(64706001)(47776003)(89996001)(62966003)(86362001)(575784001)(2351001)(77156002)(229853001)(6806004)(85426001)(120916001)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0640;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0640;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:DM2PR0301MB0640;
X-Forefront-PRVS: 0421BF7135
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0640;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TRULY TFT480800-16-E panel is driven by the Himax HX8369A driver IC.
The driver IC supports several display/control interface modes, including
the MIPI DSI video mode and command mode.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi | 41 ++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index baf2f00..483aa5f 100644
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
@@ -518,6 +525,40 @@
 	};
 };
 
+&mipi_dsi {
+	status = "okay";
+
+	panel@0 {
+		compatible = "himax,hx8369a-dsi";
+		reg = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_mipi_panel>;
+		reset-gpios = <&gpio6 11 GPIO_ACTIVE_LOW>;
+		reset-delay = <120>;
+		bs2-gpios = <&gpio6 14 GPIO_ACTIVE_HIGH>;
+		data-lanes = <2>;
+		panel-width-mm = <45>;
+		panel-height-mm = <76>;
+		bs = <10>;
+		status = "okay";
+
+		display-timings {
+			native-mode = <&timing1>;
+			timing1: truly-tft480800-16-e {
+				clock-frequency = <26400000>;
+				hactive = <480>;
+				vactive = <800>;
+				hfront-porch = <8>;
+				hback-porch = <8>;
+				hsync-len = <8>;
+				vfront-porch = <6>;
+				vback-porch = <6>;
+				vsync-len = <6>;
+			};
+		};
+	};
+};
+
 &pcie {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_pcie>;
-- 
2.1.0

