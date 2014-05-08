Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaEHI6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:58:32 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:63637 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaEHI63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:58:29 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] ARM: dts: AM33XX: fix ethernet and mdio default state
Date: Thu,  8 May 2014 10:57:36 +0200
Message-Id: <1399539456-555-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure ethernet and mdio nodes are disabled by default and enable
them explicitly only on boards that actually use them.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 arch/arm/boot/dts/am335x-bone-common.dtsi | 3 ++-
 arch/arm/boot/dts/am335x-evm.dts          | 2 ++
 arch/arm/boot/dts/am335x-evmsk.dts        | 2 ++
 arch/arm/boot/dts/am335x-igep0033.dtsi    | 8 ++++++++
 arch/arm/boot/dts/am335x-nano.dts         | 5 +++++
 arch/arm/boot/dts/am33xx.dtsi             | 2 ++
 6 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
index 2e7d932887b5..26a1fa958f37 100644
--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -280,13 +280,14 @@
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&cpsw_default>;
 	pinctrl-1 = <&cpsw_sleep>;
-
+	status = "okay";
 };
 
 &davinci_mdio {
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&davinci_mdio_default>;
 	pinctrl-1 = <&davinci_mdio_sleep>;
+	status = "okay";
 };
 
 &mmc1 {
diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index 6028217ace0f..44c63d1c4f12 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -614,12 +614,14 @@
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&cpsw_default>;
 	pinctrl-1 = <&cpsw_sleep>;
+	status = "okay";
 };
 
 &davinci_mdio {
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&davinci_mdio_default>;
 	pinctrl-1 = <&davinci_mdio_sleep>;
+	status = "okay";
 };
 
 &cpsw_emac0 {
diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
index ab238850a7b2..365383f7f617 100644
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@ -484,12 +484,14 @@
 	pinctrl-0 = <&cpsw_default>;
 	pinctrl-1 = <&cpsw_sleep>;
 	dual_emac = <1>;
+	status = "okay";
 };
 
 &davinci_mdio {
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&davinci_mdio_default>;
 	pinctrl-1 = <&davinci_mdio_sleep>;
+	status = "okay";
 };
 
 &cpsw_emac0 {
diff --git a/arch/arm/boot/dts/am335x-igep0033.dtsi b/arch/arm/boot/dts/am335x-igep0033.dtsi
index 9f22c189f636..27445d07f953 100644
--- a/arch/arm/boot/dts/am335x-igep0033.dtsi
+++ b/arch/arm/boot/dts/am335x-igep0033.dtsi
@@ -95,6 +95,14 @@
 	};
 };
 
+&mac {
+	status = "okay";
+};
+
+&davinci_mdio {
+	status = "okay";
+};
+
 &cpsw_emac0 {
 	phy_id = <&davinci_mdio>, <0>;
 };
diff --git a/arch/arm/boot/dts/am335x-nano.dts b/arch/arm/boot/dts/am335x-nano.dts
index 9907b494b99c..a3466455b171 100644
--- a/arch/arm/boot/dts/am335x-nano.dts
+++ b/arch/arm/boot/dts/am335x-nano.dts
@@ -344,6 +344,11 @@
 
 &mac {
 	dual_emac = <1>;
+	status = "okay";
+};
+
+&davinci_mdio {
+	status = "okay";
 };
 
 &cpsw_emac0 {
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index cb6811e5ae5a..0fb5df4ad498 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -688,6 +688,7 @@
 			 */
 			interrupts = <40 41 42 43>;
 			ranges;
+			status = "disabled";
 
 			davinci_mdio: mdio@4a101000 {
 				compatible = "ti,davinci_mdio";
@@ -696,6 +697,7 @@
 				ti,hwmods = "davinci_mdio";
 				bus_freq = <1000000>;
 				reg = <0x4a101000 0x100>;
+				status = "disabled";
 			};
 
 			cpsw_emac0: slave@4a100200 {
-- 
1.8.3.2

