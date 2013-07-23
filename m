Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934414Ab3GWW0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:26:00 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51723 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934309Ab3GWWZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:25:31 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, albert.u.boot@aribaud.net,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 08/10] ARM: sunxi: dt: Add PIO controller to A31 DTSI
Date: Wed, 24 Jul 2013 00:25:10 +0200
Message-Id: <1374618312-19001-9-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A31 has a different set of pins than the one found on the A10 and
A13, so we will need a different compatible string, even though the IP
is the same.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index c6c19a9..0443628 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -67,6 +67,18 @@
 		reg = <0x01c20000 0x300000>;
 		ranges;
 
+		pio: pinctrl@01c20800 {
+			compatible = "allwinner,sun6i-a31-pinctrl";
+			reg = <0x01c20800 0x400>;
+			interrupts = <0 11 1>, <0 15 1>, <0 16 1>, <0 17 1>;
+			clocks = <&osc>;
+			gpio-controller;
+			interrupt-controller;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			#gpio-cells = <3>;
+		};
+
 		timer@01c20c00 {
 			compatible = "allwinner,sun4i-timer";
 			reg = <0x01c20c00 0xa0>;
-- 
1.8.3.2

