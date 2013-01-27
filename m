Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3A0TCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 14:02:31 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:53999 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab3A0TC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 14:02:26 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] sunxi: a13-olinuxino: Add user LED to the device tree
Date: Sun, 27 Jan 2013 20:02:12 +0100
Message-Id: <1359313332-12305-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359313332-12305-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1359313332-12305-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun5i-a13-olinuxino.dts |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/sun5i-a13-olinuxino.dts b/arch/arm/boot/dts/sun5i-a13-olinuxino.dts
index 4a1e45d..33d1c7e 100644
--- a/arch/arm/boot/dts/sun5i-a13-olinuxino.dts
+++ b/arch/arm/boot/dts/sun5i-a13-olinuxino.dts
@@ -23,10 +23,30 @@
 	};
 
 	soc {
+		pinctrl@01c20800 {
+			led_pins_olinuxino: led_pins@0 {
+				allwinner,pins = "PG9";
+				allwinner,function = "gpio_out";
+				allwinner,drive = <1>;
+				allwinner,pull = <0>;
+			};
+		};
+
 		uart1: uart@01c28400 {
 			pinctrl-names = "default";
 			pinctrl-0 = <&uart1_pins_b>;
 			status = "okay";
 		};
 	};
+
+	leds {
+		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&led_pins_olinuxino>;
+
+		power {
+			gpios = <&pio 6 9 0>;
+			default-state = "on";
+		};
+	};
 };
-- 
1.7.10.4

