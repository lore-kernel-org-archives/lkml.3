Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3FFNxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:53:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:40958 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3FFNxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:53:09 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Philip Avinash <avinashphilip@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4/4] ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evmsk
Date: Thu,  6 Jun 2013 15:52:39 +0200
Message-Id: <1370526759-31163-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370526759-31163-1-git-send-email-bigeasy@linutronix.de>
References: <1370526759-31163-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip Avinash <avinashphilip@ti.com>

PWM output from ecap2 uses as backlight source. Also adds low threshold
value to have a uniform divisions in brightness-levels scales with
inverse polarity.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/arm/boot/dts/am335x-evmsk.dts |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
index f67c360..c21fdaf 100644
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@ -51,6 +51,12 @@
 				0x9c 0x27	/* gpmc_ben0_cle.gpio2_5, INPUT | MODE7 */
 			>;
 		};
+
+		ecap2_pins: backlight_pins {
+			pinctrl-single,pins = <
+				0x19c 0x4	/* mcasp0_ahclkr.ecap2_in_pwm2_out MODE4 */
+			>;
+		};
 	};
 
 	ocp {
@@ -94,6 +100,16 @@
 				st,max-limit-z = <750>;
 			};
 		};
+
+		epwmss2: epwmss@48304000 {
+			status = "okay";
+
+			ecap2: ecap@48304100 {
+				status = "okay";
+				pinctrl-names = "default";
+				pinctrl-0 = <&ecap2_pins>;
+			};
+		};
 	};
 
 	vbat: fixedregulator@0 {
@@ -170,6 +186,13 @@
 			gpios = <&gpio2 5 0>;
 		};
 	};
+
+	backlight {
+		compatible = "pwm-backlight";
+		pwms = <&ecap2 0 50000 1>;
+		brightness-levels = <0 58 61 66 75 90 125 170 255>;
+		default-brightness-level = <8>;
+	};
 };
 
 /include/ "tps65910.dtsi"
-- 
1.7.10.4

