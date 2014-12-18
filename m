Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaLRHJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 02:09:31 -0500
Received: from mail-bl2on0111.outbound.protection.outlook.com ([65.55.169.111]:63943
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752343AbaLRHIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 02:08:22 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 11/14] ARM: dts: imx6qdl-sabresd: Add support for TRULY TFT480800-16-E MIPI DSI panel
Date: Thu, 18 Dec 2014 15:11:33 +0800
Message-ID: <1418886696-11636-12-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418886696-11636-1-git-send-email-Ying.Liu@freescale.com>
References: <1418886696-11636-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(76176999)(229853001)(77096005)(87936001)(4396001)(89996001)(97736003)(2351001)(2950100001)(230783001)(20776003)(21056001)(50226001)(6806004)(77156002)(62966003)(99396003)(68736005)(86362001)(104016003)(46102003)(19580405001)(31966008)(105606002)(92566001)(50986999)(36756003)(85426001)(120916001)(110136001)(107046002)(64706001)(84676001)(47776003)(48376002)(106466001)(575784001)(19580395003)(50466002)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0625;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0625;
X-Forefront-PRVS: 042957ACD7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TRULY TFT480800-16-E panel is driven by the Himax HX8369A driver IC.
The driver IC supports several display/control interface modes, including
the MIPI DSI video mode and command mode.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
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

