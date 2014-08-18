Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaHRQv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:51:56 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:35659 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaHRQvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:51:55 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ARM: dts: sun8i: Enable i2c controllers on ippo-q8h-v5
Date: Tue, 19 Aug 2014 00:51:51 +0800
Message-Id: <1408380711-26308-3-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408380711-26308-1-git-send-email-wens@csie.org>
References: <1408380711-26308-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c0 is connected to the gsl1680 capacitive touch panel controller.
i2c1 is connected to an mma7660 3-axis accelerometer.
i2c2 is connected to the front and back gc0309 camera sensors.
The camera sensors require additional regulators be enabled before
they are available.

All these peripherals are not supported by the kernel yet.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts b/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
index ef1e4f3..e9b8cca 100644
--- a/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
+++ b/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
@@ -43,6 +43,25 @@
 			};
 		};
 
+		i2c0: i2c@01c2ac00 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c0_pins_a>;
+			status = "okay";
+		};
+
+		i2c1: i2c@01c2b000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c1_pins_a>;
+			status = "okay";
+		};
+
+		i2c2: i2c@01c2b400 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c2_pins_a>;
+			/* pull-ups and devices require PMIC regulator */
+			status = "failed";
+		};
+
 		r_uart: serial@01f02800 {
 			pinctrl-names = "default";
 			pinctrl-0 = <&r_uart_pins_a>;
-- 
2.1.0

