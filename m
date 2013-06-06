Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab3FFNxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:53:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:40953 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3FFNxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:53:07 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Philip Avinash <avinashphilip@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 3/4] ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evm
Date: Thu,  6 Jun 2013 15:52:38 +0200
Message-Id: <1370526759-31163-4-git-send-email-bigeasy@linutronix.de>
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

PWM output from ecap0 uses as backlight source. Also adds low threshold
value to have a uniform divisions in brightness-levels scales.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/arm/boot/dts/am335x-evm.dts |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index 0423298..35b2f77 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -44,6 +44,12 @@
 				0x154 0x27	/* spi0_d0.gpio0_3, INPUT | MODE7 */
 			>;
 		};
+
+		ecap0_pins: backlight_pins {
+			pinctrl-single,pins = <
+				0x164 0x0	/* eCAP0_in_PWM0_out.eCAP0_in_PWM0_out MODE0 */
+			>;
+		};
 	};
 
 	ocp {
@@ -102,6 +108,16 @@
 				reg = <0x48>;
 			};
 		};
+
+		epwmss0: epwmss@48300000 {
+			status = "okay";
+
+			ecap0: ecap@48300100 {
+				status = "okay";
+				pinctrl-names = "default";
+				pinctrl-0 = <&ecap0_pins>;
+			};
+		};
 	};
 
 	vbat: fixedregulator@0 {
@@ -158,6 +174,13 @@
 			gpio-key,wakeup;
 		};
 	};
+
+	backlight {
+		compatible = "pwm-backlight";
+		pwms = <&ecap0 0 50000 0>;
+		brightness-levels = <0 51 53 56 62 75 101 152 255>;
+		default-brightness-level = <8>;
+	};
 };
 
 /include/ "tps65910.dtsi"
-- 
1.7.10.4

