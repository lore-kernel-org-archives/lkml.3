Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbbANJTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:19:10 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:53699 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbbANJTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:19:07 -0500
From: Bart Tanghe <bart.tanghe@thomasmore.be>
To: swarren@wwwdotorg.org, lee@kernel.org
Cc: thierry.reding@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bart Tanghe <bart.tanghe@thomasmore.be>
Subject: [PATCH v3] ARM: dts: add bcm2835-pwm bindings
Date: Wed, 14 Jan 2015 10:18:54 +0100
Message-Id: <1421227134-8590-1-git-send-email-bart.tanghe@thomasmore.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To probe the bcm2835-pwm driver properly, this dts bindings has to be added 
to the bcm2835 dtsi file.
In expectation of a bcm2835 clock driver, I've added fixed-clock clock binding.
---
Changes in v3:
 - node added by reg value

Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>

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
