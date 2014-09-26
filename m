Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaIZDws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 23:52:48 -0400
Received: from mail-by2on0119.outbound.protection.outlook.com ([207.46.100.119]:4448
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752893AbaIZDwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 23:52:39 -0400
From: Robin Gong <b38343@freescale.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <LW@KARO-electronics.de>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <grant.likely@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v4 1/3] ARM: dts: imx6: add pm_power_off support for i.mx6 chips
Date: Fri, 26 Sep 2014 11:59:05 +0800
Message-ID: <1411703947-31956-2-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411703947-31956-1-git-send-email-b38343@freescale.com>
References: <1411703947-31956-1-git-send-email-b38343@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(33646002)(85306004)(93916002)(44976005)(48376002)(31966008)(68736004)(81542003)(99396003)(87936001)(47776003)(6806004)(120916001)(19580405001)(77982003)(85852003)(2201001)(10300001)(83322001)(92566001)(229853001)(106466001)(36756003)(20776003)(84676001)(83072002)(90102001)(19580395003)(104016003)(89996001)(77156001)(102836001)(62966002)(50986999)(104166001)(107046002)(92726001)(76482002)(105606002)(81342003)(74662003)(81156004)(95666004)(50226001)(50466002)(46102003)(87286001)(97736003)(64706001)(79102003)(4396001)(69596002)(21056001)(88136002)(76176999)(74502003)(80022003)(921003)(1121002)(83996005)(2101003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB352;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB352;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
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
---
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi |    4 ++++
 arch/arm/boot/dts/imx6qdl.dtsi         |    6 ++++++
 arch/arm/boot/dts/imx6sl-evk.dts       |    4 ++++
 arch/arm/boot/dts/imx6sl.dtsi          |    6 ++++++
 arch/arm/boot/dts/imx6sx-sdb.dts       |    4 ++++
 arch/arm/boot/dts/imx6sx.dtsi          |    6 ++++++
 6 files changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index baf2f00..05f5ff7 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -531,6 +531,10 @@
 	status = "okay";
 };
 
+&snvs_poweroff {
+	status = "okay";
+};
+
 &ssi2 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 9596ed5..ac0453f 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -657,6 +657,12 @@
 					interrupts = <0 19 IRQ_TYPE_LEVEL_HIGH>,
 						     <0 20 IRQ_TYPE_LEVEL_HIGH>;
 				};
+
+				snvs_poweroff: snvs-poweroff@38 {
+					compatible = "fsl,sec-v4.0-poweroff";
+					reg = <0x38 0x4>;
+					status = "disabled";
+				};
 			};
 
 			epit1: epit@020d0000 { /* EPIT1 */
diff --git a/arch/arm/boot/dts/imx6sl-evk.dts b/arch/arm/boot/dts/imx6sl-evk.dts
index 898d14f..fda4932 100644
--- a/arch/arm/boot/dts/imx6sl-evk.dts
+++ b/arch/arm/boot/dts/imx6sl-evk.dts
@@ -580,6 +580,10 @@
 	status = "okay";
 };
 
+&snvs_poweroff {
+	status = "okay";
+};
+
 &ssi2 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index dfd83e6..36ab8e0 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -574,6 +574,12 @@
 					interrupts = <0 19 IRQ_TYPE_LEVEL_HIGH>,
 						     <0 20 IRQ_TYPE_LEVEL_HIGH>;
 				};
+
+				snvs_poweroff: snvs-poweroff@38 {
+					compatible = "fsl,sec-v4.0-poweroff";
+					reg = <0x38 0x4>;
+					status = "disabled";
+				};
 			};
 
 			epit1: epit@020d0000 {
diff --git a/arch/arm/boot/dts/imx6sx-sdb.dts b/arch/arm/boot/dts/imx6sx-sdb.dts
index 82d6b34..182db49 100644
--- a/arch/arm/boot/dts/imx6sx-sdb.dts
+++ b/arch/arm/boot/dts/imx6sx-sdb.dts
@@ -304,6 +304,10 @@
 	status = "okay";
 };
 
+&snvs_poweroff {
+	status = "okay";
+};
+
 &ssi2 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index 888dd76..d8e3eca 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -671,6 +671,12 @@
 					reg = <0x34 0x58>;
 					interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>, <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
 				};
+
+				snvs_poweroff: snvs-poweroff@38 {
+					compatible = "fsl,sec-v4.0-poweroff";
+					reg = <0x38 0x4>;
+					status = "disabled";
+				};
 			};
 
 			epit1: epit@020d0000 {
-- 
1.7.9.5

