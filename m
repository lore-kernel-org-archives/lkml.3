Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab3CTLXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:23:51 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:38538 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab3CTLXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:23:50 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] DTS at91sam9x5cm: add 1-wire chip on CM board
Date: Wed, 20 Mar 2013 12:23:40 +0100
Message-Id: <1363778620-5213-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add the 1-wire chip present on the CM board to the DTS.
As the pin is also used by leds, tt's disabled by default.
If the board really wants it, it can be enabled in the board DTS.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 arch/arm/boot/dts/at91sam9x5cm.dtsi |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9x5cm.dtsi b/arch/arm/boot/dts/at91sam9x5cm.dtsi
index 4027ac7..347a74a 100644
--- a/arch/arm/boot/dts/at91sam9x5cm.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5cm.dtsi
@@ -24,6 +24,16 @@
 	};
 
 	ahb {
+		apb {
+			pinctrl@fffff400 {
+				1wire_cm {
+					pinctrl_1wire_cm: 1wire_cm-0 {
+						atmel,pins = <1 18 0x0 0x2>; /* PB18 multidrive, conflicts with led */
+					};
+				};
+			};
+		};
+
 		nand0: nand@40000000 {
 			nand-bus-width = <8>;
 			nand-ecc-mode = "hw";
@@ -74,4 +84,14 @@
 			gpios = <&pioD 21 0>;
 		};
 	};
+
+	1wire_cm {
+		compatible = "w1-gpio";
+		gpios = <&pioB 18 0>;
+		linux,open-drain;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_1wire_cm>;
+		status = "okay";
+	};
+
 };
-- 
1.7.2.5

