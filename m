Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3JUOTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:19:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49978 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab3JUOTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:19:51 -0400
X-AuditID: cbfee61a-b7f836d0000025d7-4b-5265380681a6
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, kyungmin.park@samsung.com,
        t.figa@samsung.com, kishon@ti.com, sw0312.kim@samsung.com,
        inki.dae@samsung.com, rahul.sharma@samsung.com, kgene.kim@samsung.com,
        s.nawrocki@samsung.com, thomas.abraham@linaro.org,
        mturquette@linaro.org, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 12/12] arm: dts: universal_c210: add HDMI devices
Date: Mon, 21 Oct 2013 16:18:31 +0200
Message-id: <1382365111-6533-13-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jAV02i9Qgg1kbOCzmHznHanHl63s2
	i0n3J7BY9C64ymZx4WkPm8XZpjfsFpd3zWGzmHF+H5PF0wkX2SymLDrManH4TTurxYzJL9ks
	1s94zWIxr/0lq8WxGUsYHfg97lzbw+Zxv/s4k0ffllWMHsdvbGfy+LxJLoA1issmJTUnsyy1
	SN8ugStj3YJ5rAV/eCuaX6xgbGCcyd3FyMkhIWAi0bf9IBOELSZx4d56ti5GLg4hgUWMEr+u
	9TBBOF1MEsffLmQFqWID6ji25DMjiC0ikCjxq/kuM0gRs8AhJondLVOYQRLCAvYS297PARrF
	wcEioCrx9UYFiMkr4CFx4UEOxDJ5iaf3+9hAbE6g8KmXa8FGCgm4S7z7No9lAiPvAkaGVYyi
	qQXJBcVJ6bmGesWJucWleel6yfm5mxjBQfpMagfjygaLQ4wCHIxKPLwBLilBQqyJZcWVuYcY
	JTiYlUR4q0xTg4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFw
	SjUwasid2t7+N/hAmcGR+KIQpSymvnn3RGvXlhZMYP7801hmggZ3Duvq7x9E8v++Wm5mZxG5
	+pvHprsB8y+ftpxY5T3hXsUmq2m5e+eHRGjJO55dfS8sPNOft5XXKk3NkGeK3HvDiQm3K7vC
	NZyOHxEu2LLXd4vqdsUiCS4eve/pm7hWXjQ7LfdciaU4I9FQi7moOBEAw7FbVk4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds configuration of HDMI devices on Universal C210 board.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 arch/arm/boot/dts/exynos4210-universal_c210.dts |   53 +++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210-universal_c210.dts b/arch/arm/boot/dts/exynos4210-universal_c210.dts
index 889cdad..2d94a02 100644
--- a/arch/arm/boot/dts/exynos4210-universal_c210.dts
+++ b/arch/arm/boot/dts/exynos4210-universal_c210.dts
@@ -349,4 +349,57 @@
 		compatible = "samsung,s5p6440-pwm";
 		status = "okay";
 	};
+
+	hdmi_en: voltage-regulator-hdmi-5v {
+	        compatible = "regulator-fixed";
+		regulator-name = "HDMI_5V";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		gpio = <&gpe0 1 0>;
+		enable-active-high;
+	};
+
+	i2c-ddc {
+		compatible = "i2c-gpio";
+		gpios = <&gpe4 2 0 &gpe4 3 0>;
+		i2c-gpio,delay-us = <100>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		pinctrl-0 = <&i2c_ddc_bus>;
+		pinctrl-names = "default";
+		status = "okay";
+
+		hdmiddc@72 {
+			compatible = "samsung,exynos5-hdmiddc";
+			reg = <0x72>;
+		};
+	};
+
+	hdmi: hdmi@12D00000 {
+		hpd-gpio = <&gpx3 7 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&hdmi_hpd>;
+		hdmi-en-supply = <&hdmi_en>;
+		vdd-supply = <&ldo3_reg>;
+		vdd_osc-supply = <&ldo4_reg>;
+		vdd_pll-supply = <&ldo3_reg>;
+		status = "okay";
+	};
+};
+
+&pinctrl_1 {
+	hdmi_hpd: hdmi-hpd {
+		samsung,pins = "gpx3-7";
+		samsung,pin-pud = <0>;
+	};
+};
+
+&pinctrl_0 {
+	i2c_ddc_bus: i2c-ddc-bus {
+		samsung,pins = "gpe4-2", "gpe4-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
 };
-- 
1.7.9.5

