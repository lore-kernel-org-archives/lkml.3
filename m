Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab3IRStR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:49:17 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41181 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab3IRStP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:49:15 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Preeti Murthy <preeti.lkml@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 4/4] arm: zynq: Enable arm_global_timer
Date: Wed, 18 Sep 2013 11:48:38 -0700
Message-Id: <1379530118-22813-5-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379530118-22813-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1379530118-22813-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zynq is based on an ARM Cortex-A9 MPCore, which features the
arm_global_timer in its SCU. Therefore enable the timer for Zynq.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
v2:
 - rename DT node: global_timer@... => timer@...
 - add Daniel's ACK
---
 arch/arm/boot/dts/zynq-7000.dtsi | 8 ++++++++
 arch/arm/mach-zynq/Kconfig       | 1 +
 2 files changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index e32b92b..e7f73b2 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -92,6 +92,14 @@
 			};
 		};
 
+		global_timer: timer@f8f00200 {
+			compatible = "arm,cortex-a9-global-timer";
+			reg = <0xf8f00200 0x20>;
+			interrupts = <1 11 0x301>;
+			interrupt-parent = <&intc>;
+			clocks = <&clkc 4>;
+		};
+
 		ttc0: ttc0@f8001000 {
 			interrupt-parent = <&intc>;
 			interrupts = < 0 10 4 0 11 4 0 12 4 >;
diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
index 04f8a4a..6b04260 100644
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@ -13,5 +13,6 @@ config ARCH_ZYNQ
 	select HAVE_SMP
 	select SPARSE_IRQ
 	select CADENCE_TTC_TIMER
+	select ARM_GLOBAL_TIMER
 	help
 	  Support for Xilinx Zynq ARM Cortex A9 Platform
-- 
1.8.4

