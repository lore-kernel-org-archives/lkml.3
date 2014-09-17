Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbaIQJvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:51:41 -0400
Received: from mail-by2on0139.outbound.protection.outlook.com ([207.46.100.139]:16288
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755219AbaIQJvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:51:39 -0400
From: Robin Gong <b38343@freescale.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <sre@kernel.org>,
        <dbaryshkov@gmail.com>, <dwmw2@infradead.org>,
        <grant.likely@linaro.org>, <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 1/3] ARM: dts: imx6: add pm_power_off support for i.mx6 chips
Date: Wed, 17 Sep 2014 17:57:58 +0800
Message-ID: <1410947881-7345-2-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410947881-7345-1-git-send-email-b38343@freescale.com>
References: <1410947881-7345-1-git-send-email-b38343@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(95666004)(105606002)(36756003)(76176999)(97736003)(2201001)(229853001)(106466001)(76482002)(33646002)(93916002)(62966002)(19580405001)(83322001)(44976005)(19580395003)(89996001)(83072002)(92566001)(84676001)(92726001)(74662003)(4396001)(50226001)(64706001)(21056001)(6806004)(68736004)(47776003)(20776003)(99396002)(50986999)(87936001)(88136002)(31966008)(77982003)(79102003)(81342003)(46102003)(107046002)(85852003)(87286001)(77156001)(104016003)(50466002)(74502003)(48376002)(104166001)(80022003)(85306004)(90102001)(102836001)(26826002)(81542003)(1121002)(921003)(2101003)(83996005)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB350;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB350;
X-Forefront-PRVS: 0337AFFE9A
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
 arch/arm/boot/dts/imx6qdl.dtsi |    5 +++++
 arch/arm/boot/dts/imx6sl.dtsi  |    5 +++++
 arch/arm/boot/dts/imx6sx.dtsi  |    5 +++++
 3 files changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index c701af9..fffa1c6 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -645,6 +645,11 @@
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
index 505da9e..3256318 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -565,6 +565,11 @@
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
index f4b9da6..74a0131 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -668,6 +668,11 @@
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
1.7.9.5

