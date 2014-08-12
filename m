Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbaHLQqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:46:25 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38285 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaHLQpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:45:14 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 3/6] ARM: dts: Create cros-tps65090 fragment
Date: Tue, 12 Aug 2014 18:44:25 +0200
Message-Id: <1407861868-20097-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tps65090 PMU is a component used in many ChromeOS devices
so instead of having the same device tree definitions in many
files, create a .dtsi fragment that can be included in DTS.

This fragment is based on the DT definitions for Peach boards.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/cros-tps65090.dtsi | 81 ++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100644 arch/arm/boot/dts/cros-tps65090.dtsi

diff --git a/arch/arm/boot/dts/cros-tps65090.dtsi b/arch/arm/boot/dts/cros-tps65090.dtsi
new file mode 100644
index 0000000..99df15e
--- /dev/null
+++ b/arch/arm/boot/dts/cros-tps65090.dtsi
@@ -0,0 +1,81 @@
+/*
+ * Copyright (C) 2014 Google, Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * Common file for tps65090 PMU on Chromebooks
+ */
+/ {
+	vbat: fixed-regulator {
+		compatible = "regulator-fixed";
+		regulator-name = "vbat-supply";
+		regulator-boot-on;
+		regulator-always-on;
+	};
+};
+
+&tps {
+	/*
+	 * Config irq to disable internal pulls
+	 * even though we run in polling mode.
+	 */
+	pinctrl-names = "default";
+	pinctrl-0 = <&tps65090_irq>;
+
+	vsys1-supply = <&vbat>;
+	vsys2-supply = <&vbat>;
+	vsys3-supply = <&vbat>;
+	infet1-supply = <&vbat>;
+	infet2-supply = <&vbat>;
+	infet3-supply = <&vbat>;
+	infet4-supply = <&vbat>;
+	infet5-supply = <&vbat>;
+	infet6-supply = <&vbat>;
+	infet7-supply = <&vbat>;
+	vsys-l1-supply = <&vbat>;
+	vsys-l2-supply = <&vbat>;
+};
+
+&tps65090_dcdc1 {
+	ti,enable-ext-control;
+};
+
+&tps65090_dcdc2 {
+	ti,enable-ext-control;
+};
+
+&tps65090_dcdc3 {
+	ti,enable-ext-control;
+};
+
+&tps65090_fet1 {
+	regulator-name = "vcd_led";
+};
+
+&tps65090_fet2 {
+	regulator-name = "video_mid";
+};
+
+&tps65090_fet3 {
+	regulator-name = "wwan_r";
+};
+
+&tps65090_fet4 {
+	regulator-name = "sdcard";
+};
+
+&tps65090_fet5 {
+	regulator-name = "camout";
+};
+
+&tps65090_fet6 {
+	regulator-name = "lcd_vdd";
+};
+
+&tps65090_fet7 {
+	regulator-name = "video_mid_1a";
+};
-- 
2.0.0.rc2

