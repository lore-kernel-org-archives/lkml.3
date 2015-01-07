Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbbAGLBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:01:14 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:33119 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbbAGLBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:01:11 -0500
From: Bart Tanghe <bart.tanghe@thomasmore.be>
To: swarren@wwwdotorg.org, lee@kernel.org
Cc: thierry.reding@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bart Tanghe <bart.tanghe@thomasmore.be>
Subject: [PATCH v2] ARM: dts: add bcm2835-pwm bindings
Date: Wed,  7 Jan 2015 12:00:58 +0100
Message-Id: <1420628458-11459-1-git-send-email-bart.tanghe@thomasmore.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To probe the bcm2835-pwm driver properly, this dts bindings has to be added 
to the bcm2835 dtsi file.
In expectation of a bcm2835 clock driver, I've added fixed-clock clock binding.
---
Changes in v2:
 - status set to disabled
 - follow the clock naming convention

Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>

diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm2835.dtsi
index 3342cb1..ba76bb4 100644
--- a/arch/arm/boot/dts/bcm2835.dtsi
+++ b/arch/arm/boot/dts/bcm2835.dtsi
@@ -146,6 +147,14 @@
 			interrupts = <1 9>;
 		};
 
+		pwm: pwm@7e20e000 {
+			compatible = "brcm,bcm2835-pwm";
+			reg = <0x7e20c000 0x28>;
+			clocks = <&clk_pwm>;
+			#pwm-cells = <2>;
+			status = "disabled";
+		};
+
 		arm-pmu {
 			compatible = "arm,arm1176-pmu";
 		};
@@ -179,5 +188,13 @@
 			clock-output-names = "spi";
 			clock-frequency = <250000000>;
 		};
+
+		clk_pwm: clock@3 {
+			compatible = "fixed-clock";
+			reg = <3>;
+			#clock-cells = <0>;
+			clock-output-names = "pwm";
+			clock-frequency = <9200000>;
+		};
 	};
 };
