Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbaEGEPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:15:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56299 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750986AbaEGEPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:15:08 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com
Cc: Boris Brezillon <boris@free-electrons.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 7/7] ARM: sunxi: dt: add APP4-EVB1 board support
Date: Tue,  6 May 2014 22:50:23 -0500
Message-Id: <1399434623-20383-8-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399434623-20383-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1399434623-20383-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

The APP4 EVB1 development boards embeds an A31, together with some NAND, one SD
card slot, and one SDIO + UART WiFi and Bluetooth chip, a few I2C buses, USB,
and a LCD display.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/Makefile                |  1 +
 arch/arm/boot/dts/sun6i-a31-app4-evb1.dts | 63 +++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)
 create mode 100644 arch/arm/boot/dts/sun6i-a31-app4-evb1.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index ffa3f5ef27d3..d50c0895a9d5 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -343,6 +343,7 @@ dtb-$(CONFIG_ARCH_SUNXI) += \
 	sun5i-a10s-olinuxino-micro.dtb \
 	sun5i-a13-olinuxino.dtb \
 	sun5i-a13-olinuxino-micro.dtb \
+	sun6i-a31-app4-evb1.dtb \
 	sun6i-a31-colombus.dtb \
 	sun6i-a31-m9.dtb \
 	sun7i-a20-cubieboard2.dtb \
diff --git a/arch/arm/boot/dts/sun6i-a31-app4-evb1.dts b/arch/arm/boot/dts/sun6i-a31-app4-evb1.dts
new file mode 100644
index 000000000000..270ab978f858
--- /dev/null
+++ b/arch/arm/boot/dts/sun6i-a31-app4-evb1.dts
@@ -0,0 +1,63 @@
+/*
+ * Copyright 2014 Boris Brezillon
+ *
+ * Boris Brezillon <boris.brezillon@free-electrons.com>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/dts-v1/;
+/include/ "sun6i-a31.dtsi"
+
+/ {
+	model = "Allwinner A31 APP4 EVB1 Evaluation Board";
+	compatible = "allwinner,app4-evb1", "allwinner,sun6i-a31";
+
+	chosen {
+		bootargs = "earlyprintk console=ttyS0,115200";
+	};
+
+	soc@01c00000 {
+		pio: pinctrl@01c20800 {
+			usb1_vbus_pin_a: usb1_vbus_pin@0 {
+				allwinner,pins = "PH27";
+				allwinner,function = "gpio_out";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+		};
+
+		usbphy: phy@01c19400 {
+			usb1_vbus-supply = <&reg_usb1_vbus>;
+			status = "okay";
+		};
+
+		ehci0: usb@01c1a000 {
+			status = "okay";
+		};
+
+		uart0: serial@01c28000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart0_pins_a>;
+			status = "okay";
+		};
+	};
+
+	reg_usb1_vbus: usb1-vbus {
+		compatible = "regulator-fixed";
+		pinctrl-names = "default";
+		pinctrl-0 = <&usb1_vbus_pin_a>;
+		regulator-name = "usb1-vbus";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		enable-active-high;
+		gpio = <&pio 7 27 0>;
+		status = "okay";
+	};
+
+};
-- 
1.9.1

