Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaILJxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:53:18 -0400
Received: from mail-bn1on0142.outbound.protection.outlook.com ([157.56.110.142]:60640
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751382AbaILJxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:53:12 -0400
From: Robin Gong <b38343@freescale.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <sre@kernel.org>,
        <dbaryshkov@gmail.com>, <dwmw2@infradead.org>,
        <grant.likely@linaro.org>, <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 1/3] ARM: dts: imx6: add pm_power_off support for i.mx6 chips
Date: Fri, 12 Sep 2014 16:48:57 +0800
Message-ID: <1410511739-31122-2-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410511739-31122-1-git-send-email-b38343@freescale.com>
References: <1410511739-31122-1-git-send-email-b38343@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(77156001)(87936001)(93916002)(33646002)(47776003)(106466001)(92726001)(50986999)(76176999)(104016003)(84676001)(64706001)(92566001)(80022001)(2201001)(99396002)(89996001)(81542001)(85306004)(76482001)(20776003)(21056001)(19580405001)(87286001)(81342001)(83322001)(36756003)(19580395003)(229853001)(95666004)(74502001)(31966008)(74662001)(107046002)(6806004)(79102001)(44976005)(97736003)(105606002)(102836001)(50466002)(4396001)(104166001)(50226001)(26826002)(90102001)(62966002)(83072002)(88136002)(85852003)(48376002)(46102001)(77982001)(68736004)(1121002)(921003)(42262002)(2101003)(83996005);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB347;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB347;
X-Forefront-PRVS: 0332AACBC3
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
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

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 .../bindings/power_supply/imx-snvs-poweroff.txt     | 21 +++++++++++++++++++++
 arch/arm/boot/dts/imx6qdl.dtsi                      |  5 +++++
 arch/arm/boot/dts/imx6sl.dtsi                       |  5 +++++
 arch/arm/boot/dts/imx6sx.dtsi                       |  5 +++++
 4 files changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt

diff --git a/Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt b/Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
new file mode 100644
index 0000000..1a3ab9a
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
@@ -0,0 +1,21 @@
+i.mx6 Poweroff Driver
+
+SNVS_LPCR in SNVS module can power off the whole system by pull
+PMIC_ON_REQ low.
+
+Required Properties:
+-compatible: "fsl,sec-v4.0-poweroff"
+-reg: Specifies the physical address of the SNVS_LPCR register
+
+Example:
+	snvs@020cc000 {
+		compatible = "fsl,sec-v4.0-mon", "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0 0x020cc000 0x4000>;
+		.....
+		snvs-poweroff@38 {
+			compatible = "fsl,sec-v4.0-poweroff";
+			reg = <0x38 0x4>;
+		};
+	}
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 70d7207..d2d7563 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -650,6 +650,11 @@
 					interrupts = <0 19 IRQ_TYPE_LEVEL_HIGH>,
 						     <0 20 IRQ_TYPE_LEVEL_HIGH>;
 				};
+
+				snvs-poweroff@38 {
+					compatible = "fsl,sec-v4.0-poweroff";
+					reg = <0x38 0x4>;
+				};
 			};
 
 			epit1: epit@020d0000 { /* EPIT1 */
diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index ba67714..6e1d8f6 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -568,6 +568,11 @@
 					interrupts = <0 19 IRQ_TYPE_LEVEL_HIGH>,
 						     <0 20 IRQ_TYPE_LEVEL_HIGH>;
 				};
+
+				snvs-poweroff@38 {
+					compatible = "fsl,sec-v4.0-poweroff";
+					reg = <0x38 0x4>;
+				};
 			};
 
 			epit1: epit@020d0000 {
diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index d137caca..c1f937e 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -671,6 +671,11 @@
 					reg = <0x34 0x58>;
 					interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>, <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
 				};
+
+				snvs-poweroff@38 {
+					compatible = "fsl,sec-v4.0-poweroff";
+					reg = <0x38 0x4>;
+				};
 			};
 
 			epit1: epit@020d0000 {
-- 
1.9.1

