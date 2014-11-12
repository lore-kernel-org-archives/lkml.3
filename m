Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaKLJ2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:28:37 -0500
Received: from mail-bn1on0111.outbound.protection.outlook.com ([157.56.110.111]:61934
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752648AbaKLJ2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:28:33 -0500
From: Robin Gong <b38343@freescale.com>
To: <shawn.guo@linaro.org>, <kernel@pengutronix.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <smoch@web.de>
Subject: [PATCH 1/3] ARM: dts: imx6: add pm_power_off support for i.mx6 chips
Date: Wed, 12 Nov 2014 16:20:37 +0800
Message-ID: <1415780439-29728-2-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415780439-29728-1-git-send-email-b38343@freescale.com>
References: <1415780439-29728-1-git-send-email-b38343@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(95666004)(6806004)(105606002)(47776003)(20776003)(64706001)(102836001)(104166001)(62966003)(77156002)(50986999)(19580405001)(19580395003)(4396001)(68736004)(106466001)(48376002)(36756003)(33646002)(104016003)(229853001)(50226001)(44976005)(120916001)(99396003)(87936001)(87286001)(50466002)(89996001)(93916002)(107046002)(88136002)(76176999)(31966008)(92726001)(2201001)(92566001)(46102003)(21056001)(84676001)(97736003)(921003)(1121002)(42262002)(2101003)(83996005);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0633;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0633;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0633;
X-Forefront-PRVS: 03932714EB
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0633;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All chips of i.mx6 can be powered off by programming SNVS.
For example :
On i.mx6q-sabresd board, PMIC_ON_REQ connect with external
pmic ON/OFF pin, that will cause the whole PMIC powered off
except VSNVS. And system can restart once PMIC_ON_REQ goes
high by push POWRER key.

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi |    4 ++++
 arch/arm/boot/dts/imx6qdl.dtsi         |    6 ++++++
 arch/arm/boot/dts/imx6sl-evk.dts       |    4 ++++
 arch/arm/boot/dts/imx6sl.dtsi          |    6 ++++++
 arch/arm/boot/dts/imx6sx-sdb.dts       |    4 ++++
 arch/arm/boot/dts/imx6sx.dtsi          |    6 ++++++
 6 files changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index 07fb302..ba12cc6 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -531,6 +531,10 @@
 	status = "okay";
 };
 
+&snvs-poweroff {
+	status = "okay";
+};
+
 &ssi2 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index c701af9..3a032d1 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -645,6 +645,12 @@
 					interrupts = <0 19 IRQ_TYPE_LEVEL_HIGH>,
 						     <0 20 IRQ_TYPE_LEVEL_HIGH>;
 				};
+
+				snvs-poweroff: snvs-poweroff@38 {
+					compatible = "fsl,sec-v4.0-poweroff";
+					reg = <0x38 0x4>;
+					status = "disabled";
+				};
 			};
 
 			epit1: epit@020d0000 { /* EPIT1 */
diff --git a/arch/arm/boot/dts/imx6sl-evk.dts b/arch/arm/boot/dts/imx6sl-evk.dts
index 3f9e041..dab588f 100644
--- a/arch/arm/boot/dts/imx6sl-evk.dts
+++ b/arch/arm/boot/dts/imx6sl-evk.dts
@@ -488,6 +488,10 @@
 	status = "okay";
 };
 
+&snvs-poweroff {
+	status = "okay";
+};
+
 &ssi2 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index 505da9e..5e5ed07 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -565,6 +565,12 @@
 					interrupts = <0 19 IRQ_TYPE_LEVEL_HIGH>,
 						     <0 20 IRQ_TYPE_LEVEL_HIGH>;
 				};
+
+				snvs-poweroff: snvs-poweroff@38 {
+					compatible = "fsl,sec-v4.0-poweroff";
+					reg = <0x38 0x4>;
+					status = "disabled";
+				};
 			};
 
 			epit1: epit@020d0000 {
diff --git a/arch/arm/boot/dts/imx6sx-sdb.dts b/arch/arm/boot/dts/imx6sx-sdb.dts
index a3980d9..78dc031 100644
--- a/arch/arm/boot/dts/imx6sx-sdb.dts
+++ b/arch/arm/boot/dts/imx6sx-sdb.dts
@@ -251,6 +251,10 @@
 	};
 };
 
+&snvs-poweroff {
+	status = "okay";
+};
+
 &ssi2 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index f4b9da6..652be9f 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -668,6 +668,12 @@
 					reg = <0x34 0x58>;
 					interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>, <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
 				};
+
+				snvs-poweroff: snvs-poweroff@38 {
+					compatible = "fsl,sec-v4.0-poweroff";
+					reg = <0x38 0x4>;
+					status = "disabled";
+				};
 			};
 
 			epit1: epit@020d0000 {
-- 
1.7.9.5

