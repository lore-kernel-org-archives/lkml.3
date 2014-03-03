Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaCCQDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:03:24 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:45733 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbaCCQC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:02:56 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Mark Brown <broonie@kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v2 11/11] ARM: dts: s3c6410-mini6410: Add support for LCD screen
Date: Mon,  3 Mar 2014 17:02:16 +0100
Message-Id: <1393862536-9842-12-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds necessary device tree nodes and properties to enable LCD
screen on mini6410 board.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/boot/dts/s3c6410-mini6410.dts | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm/boot/dts/s3c6410-mini6410.dts b/arch/arm/boot/dts/s3c6410-mini6410.dts
index 57e00f9..97f6353 100644
--- a/arch/arm/boot/dts/s3c6410-mini6410.dts
+++ b/arch/arm/boot/dts/s3c6410-mini6410.dts
@@ -167,6 +167,33 @@
 	};
 };
 
+&fimd {
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&lcd_data24>, <&lcd_power>;
+
+	display-timings {
+		native-mode = <&timing0>;
+
+		timing0: timing@0 {
+			/* 480x272@60Hz */
+			clock-frequency = <10000000>;
+			hactive = <480>;
+			vactive = <272>;
+			hfront-porch = <4>;
+			hback-porch = <45>;
+			hsync-len = <40>;
+			vback-porch = <3>;
+			vfront-porch = <2>;
+			vsync-len = <6>;
+			vsync-active = <1>;
+			hsync-active = <1>;
+			de-active = <1>;
+			pixelclk-active = <0>;
+		};
+	};
+};
+
 &sdhci0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&sd0_clk>, <&sd0_cmd>, <&sd0_cd>, <&sd0_bus4>;
@@ -213,6 +240,12 @@
 				"gpn-4", "gpn-5", "gpl-11", "gpl-12";
 		samsung,pin-pud = <PIN_PULL_NONE>;
 	};
+
+	lcd_power: lcd-power {
+		samsung,pins = "gpe-0";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <PIN_PULL_UP>;
+	};
 };
 
 &i2c0 {
-- 
1.9.0

