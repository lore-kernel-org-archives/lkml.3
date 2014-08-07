Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaHGBJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:09:15 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35164 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbaHGBJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:09:14 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Stephen Warren <swarren@nvidia.com>,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/1] ARM: dts: Add Peach Pit and Pi dts entry for atmel touchpad
Date: Thu,  7 Aug 2014 03:08:33 +0200
Message-Id: <1407373713-26281-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>

The Peach Pit and Pi boards have an Atmel maXTouch device.
Add the needed Device Tree nodes to support it.

Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
[javier.martinez: added linux,gpio-keymap property and changed IRQ type]
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

With only this patch the touchpad is probed but interrupts are not being
generated. The following is needed to have a fully functional touchpad:

[PATCH 1/2] "Input: atmel_mxt_ts - Get IRQ edge/level flags on DT booting"
https://lkml.org/lkml/2014/8/6/585

 arch/arm/boot/dts/exynos5420-peach-pit.dts | 29 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 29 +++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 228a6b1..7dce444 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -11,6 +11,7 @@
 /dts-v1/;
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/irq.h>
 #include "exynos5420.dtsi"
 
 / {
@@ -157,6 +158,27 @@
 	};
 };
 
+&hsi2c_8 {
+	status = "okay";
+	clock-frequency = <333000>;
+
+	trackpad@4b {
+		compatible="atmel,maxtouch";
+		reg=<0x4b>;
+		interrupt-parent=<&gpx1>;
+		interrupts=<1 IRQ_TYPE_EDGE_FALLING>;
+		wakeup-source;
+		pinctrl-names = "default";
+		pinctrl-0 = <&trackpad_irq>;
+		linux,gpio-keymap = < BTN_LEFT
+				      BTN_TOOL_FINGER
+				      BTN_TOOL_DOUBLETAP
+				      BTN_TOOL_TRIPLETAP
+				      BTN_TOOL_QUADTAP
+				      BTN_TOOL_QUINTTAP >;
+	};
+};
+
 &hsi2c_9 {
 	status = "okay";
 	clock-frequency = <400000>;
@@ -249,6 +271,13 @@
 		samsung,pin-drv = <0>;
 	};
 
+	trackpad_irq: trackpad-irq {
+		samsung,pins = "gpx1-1";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
 	power_key_irq: power-key-irq {
 		samsung,pins = "gpx1-2";
 		samsung,pin-function = <0>;
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index f3ee48b..de946b3 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -11,6 +11,7 @@
 /dts-v1/;
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/irq.h>
 #include "exynos5800.dtsi"
 
 / {
@@ -155,6 +156,27 @@
 	};
 };
 
+&hsi2c_8 {
+	status = "okay";
+	clock-frequency = <333000>;
+
+	trackpad@4b {
+		compatible="atmel,maxtouch";
+		reg=<0x4b>;
+		interrupt-parent=<&gpx1>;
+		interrupts=<1 IRQ_TYPE_EDGE_FALLING>;
+		wakeup-source;
+		pinctrl-names = "default";
+		pinctrl-0 = <&trackpad_irq>;
+		linux,gpio-keymap = < BTN_LEFT
+				      BTN_TOOL_FINGER
+				      BTN_TOOL_DOUBLETAP
+				      BTN_TOOL_TRIPLETAP
+				      BTN_TOOL_QUADTAP
+				      BTN_TOOL_QUINTTAP >;
+	};
+};
+
 &hsi2c_9 {
 	status = "okay";
 	clock-frequency = <400000>;
@@ -247,6 +269,13 @@
 		samsung,pin-drv = <0>;
 	};
 
+	trackpad_irq: trackpad-irq {
+		samsung,pins = "gpx1-1";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
 	power_key_irq: power-key-irq {
 		samsung,pins = "gpx1-2";
 		samsung,pin-function = <0>;
-- 
2.0.0.rc2

