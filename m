Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaFKFf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 01:35:56 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:35808 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbaFKFfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 01:35:50 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: mturquette@linaro.org, t.figa@samsung.com, linux@arm.linux.org.uk,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        kgene.kim@samsung.com, khilman@linaro.org, dianders@google.com,
        trblinux@gmail.com
Subject: [PATCH 3/3] ARM: dts: Enable audio support for Peach-pi board
Date: Wed, 11 Jun 2014 11:02:19 +0530
Message-Id: <1402464739-19044-4-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peach-pi board has MAX98090 audio codec connected on HSI2C-7 bus.

Signed-off-by: Tushar Behera <tushar.b@samsung.com>
---
 arch/arm/boot/dts/exynos5800-peach-pi.dts |   31 +++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index f3af207..76f5966 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -78,9 +78,27 @@
 		pinctrl-0 = <&usb301_vbus_en>;
 		enable-active-high;
 	};
+
+	sound {
+		compatible = "google,snow-audio-max98090";
+
+		samsung,i2s-controller = <&i2s0>;
+		samsung,audio-codec = <&max98090>;
+	};
+};
+
+&i2s0 {
+	status = "okay";
 };
 
 &pinctrl_0 {
+	max98090_irq: max98090-irq {
+		samsung,pins = "gpx0-2";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
 	tpm_irq: tpm-irq {
 		samsung,pins = "gpx1-0";
 		samsung,pin-function = <0>;
@@ -207,6 +225,19 @@
 	samsung,invert-vclk;
 };
 
+&hsi2c_7 {
+	status = "okay";
+
+	max98090: codec@10 {
+		compatible = "maxim,max98090";
+		reg = <0x10>;
+		interrupts = <2 0>;
+		interrupt-parent = <&gpx0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&max98090_irq>;
+	};
+};
+
 &hsi2c_9 {
 	status = "okay";
 	clock-frequency = <400000>;
-- 
1.7.9.5

