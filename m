Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab3G3PAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:00:16 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:42313 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753705Ab3G3PAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:00:10 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 07/10] ARM: sun7i: Add the PIO controller node to the DTSI
Date: Tue, 30 Jul 2013 16:59:51 +0200
Message-Id: <1375196394-21138-8-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375196394-21138-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375196394-21138-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PIO controller is responsible for the GPIO/muxing/external
interrupts handling. Now that we have support for the A20 pin set in the
pinctrl driver, we can start using it in the DTSI.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 1afdb4e..704fca9 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -60,6 +60,18 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 
+		pio: pinctrl@01c20800 {
+			compatible = "allwinner,sun7i-a20-pinctrl";
+			reg = <0x01c20800 0x400>;
+			interrupts = <0 28 1>;
+			clocks = <&osc24M>;
+			gpio-controller;
+			interrupt-controller;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			#gpio-cells = <3>;
+		};
+
 		timer@01c20c00 {
 			compatible = "allwinner,sun4i-timer";
 			reg = <0x01c20c00 0x90>;
-- 
1.8.3.4

