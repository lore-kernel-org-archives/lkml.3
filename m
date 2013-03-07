Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099Ab3CGEQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:16:16 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:46425 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071Ab3CGEQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:16:14 -0500
From: Matt Porter <mporter@ti.com>
To: Balaji T K <balajitk@ti.com>, Chris Ball <cjb@laptop.org>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: [PATCH 2/2] ARM: dts: add AM33XX MMC support
Date: Wed,  6 Mar 2013 23:16:39 -0500
Message-Id: <1362629799-22485-3-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362629799-22485-1-git-send-email-mporter@ti.com>
References: <1362629799-22485-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds AM33XX MMC support for am335x-bone, am335x-evm, and
am335x-evmsk.

Signed-off-by: Matt Porter <mporter@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/boot/dts/am335x-bone.dts  |    7 +++++++
 arch/arm/boot/dts/am335x-evm.dts   |    7 +++++++
 arch/arm/boot/dts/am335x-evmsk.dts |    7 +++++++
 arch/arm/boot/dts/am33xx.dtsi      |   28 ++++++++++++++++++++++++++++
 4 files changed, 49 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index 11b240c..a154ce0 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -120,6 +120,8 @@
 		};
 
 		ldo3_reg: regulator@5 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
 			regulator-always-on;
 		};
 
@@ -136,3 +138,8 @@
 &cpsw_emac1 {
 	phy_id = <&davinci_mdio>, <1>;
 };
+
+&mmc1 {
+	status = "okay";
+	vmmc-supply = <&ldo3_reg>;
+};
diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index d649644..2907da6 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -232,6 +232,8 @@
 		};
 
 		vmmc_reg: regulator@12 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
 			regulator-always-on;
 		};
 	};
@@ -244,3 +246,8 @@
 &cpsw_emac1 {
 	phy_id = <&davinci_mdio>, <1>;
 };
+
+&mmc1 {
+	status = "okay";
+	vmmc-supply = <&vmmc_reg>;
+};
diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
index f5a6162..f050c46 100644
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@ -244,7 +244,14 @@
 		};
 
 		vmmc_reg: regulator@12 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
 			regulator-always-on;
 		};
 	};
 };
+
+&mmc1 {
+	status = "okay";
+	vmmc-supply = <&vmmc_reg>;
+};
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index c3c781a..e029eea 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -234,6 +234,34 @@
 			status = "disabled";
 		};
 
+		mmc1: mmc@48060000 {
+			compatible = "ti,omap3-hsmmc";
+			ti,hwmods = "mmc1";
+			ti,dual-volt;
+			ti,needs-special-reset;
+			dmas = <&edma 24
+				&edma 25>;
+			dma-names = "tx", "rx";
+			status = "disabled";
+		};
+
+		mmc2: mmc@481d8000 {
+			compatible = "ti,omap3-hsmmc";
+			ti,hwmods = "mmc2";
+			ti,needs-special-reset;
+			dmas = <&edma 2
+				&edma 3>;
+			dma-names = "tx", "rx";
+			status = "disabled";
+		};
+
+		mmc3: mmc@47810000 {
+			compatible = "ti,omap3-hsmmc";
+			ti,hwmods = "mmc3";
+			ti,needs-special-reset;
+			status = "disabled";
+		};
+
 		wdt2: wdt@44e35000 {
 			compatible = "ti,omap3-wdt";
 			ti,hwmods = "wd_timer2";
-- 
1.7.9.5

