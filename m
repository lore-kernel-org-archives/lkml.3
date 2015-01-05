Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbbAEPde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:33:34 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:50605 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbbAEPdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:33:32 -0500
From: Bart Tanghe <bart.tanghe@thomasmore.be>
To: swarren@wwwdotorg.org, lee@kernel.org, devicetree@vger.kernel.org
Cc: thierry.reding@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bart.tanghe@thomasmore.be
Subject: [PATCH]dts: add bcm2835-pwm bindings
Date: Mon,  5 Jan 2015 16:33:03 +0100
Message-Id: <1420471983-29945-1-git-send-email-bart.tanghe@thomasmore.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To probe the bcm2835-pwm driver properly, this dts bindings has to be added 
to the bcm2835 dtsi file.
In expectation of a bcm2835 clock driver, I've added fixed-clock clock binding.
To change the status of the gpio pins into pwm output pins, some additional 
bindings has to be added but this has not to be done automatically.
Is it possible to document this bindings somewhere?

Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>

diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm2835.dtsi
index 3342cb1..ba76bb4 100644
--- a/arch/arm/boot/dts/bcm2835.dtsi
+++ b/arch/arm/boot/dts/bcm2835.dtsi
@@ -146,6 +147,14 @@
 			interrupts = <1 9>;
 		};
 
+		pwm: pwm@7E20C000 {
+			compatible = "brcm,bcm2835-pwm";
+			reg = <0x7e20c000 0x28>;
+			clocks = <&clk_pwm>;
+			#pwm-cells = <2>;
+			status = "ok";
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
+		clk_pwm: pwm@3 {
+			compatible = "fixed-clock";
+			reg = <3>;
+			#clock-cells = <0>;
+			clock-output-names = "pwm";
+			clock-frequency = <9200000>;
+		};
 	};
 };
