Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbaLJItx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:49:53 -0500
Received: from mail-bn1on0117.outbound.protection.outlook.com ([157.56.110.117]:23488
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751842AbaLJItr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:49:47 -0500
X-Greylist: delayed 917 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Dec 2014 03:49:46 EST
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <p.zabel@pengutronix.de>,
        <thierry.reding@gmail.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <mturquette@linaro.org>, <airlied@linux.ie>
Subject: [PATCH RFC 11/15] ARM: dtsi: imx6qdl: Add support for MIPI DSI host controller
Date: Wed, 10 Dec 2014 16:37:24 +0800
Message-ID: <1418200648-32656-12-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
References: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(46102003)(87936001)(20776003)(47776003)(85426001)(64706001)(68736005)(2351001)(105606002)(107046002)(104016003)(106466001)(36756003)(31966008)(77096005)(110136001)(229853001)(21056001)(84676001)(6806004)(97736003)(50986999)(50226001)(4396001)(76176999)(19580395003)(19580405001)(62966003)(77156002)(120916001)(89996001)(50466002)(48376002)(99396003)(92566001)(86362001)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0634;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0634;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:CY1PR0301MB0634;
X-Forefront-PRVS: 0421BF7135
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0634;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for MIPI DSI host controller.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 arch/arm/boot/dts/imx6qdl.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 5d92ad7..4769767 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1006,7 +1006,14 @@
 			mipi_dsi: mipi@021e0000 {
 				#address-cells = <1>;
 				#size-cells = <0>;
+				compatible = "fsl,imx6q-mipi-dsi";
 				reg = <0x021e0000 0x4000>;
+				interrupts = <0 102 IRQ_TYPE_LEVEL_HIGH>;
+				gpr = <&gpr>;
+				clocks = <&clks IMX6QDL_CLK_VIDEO_27M>,
+					 <&clks IMX6QDL_CLK_HSI_TX>,
+					 <&clks IMX6QDL_CLK_HSI_TX>;
+				clock-names = "pllref", "pllref_gate", "core_cfg";
 				status = "disabled";
 
 				port@0 {
-- 
2.1.0

