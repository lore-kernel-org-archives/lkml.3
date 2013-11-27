Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076Ab3K0BHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:07:31 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46435 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3K0BFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:05:16 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 2/9] arm: dt: zynq: Add 'cpus' node
Date: Tue, 26 Nov 2013 17:04:49 -0800
Message-Id: <1385514296-26702-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a 'cpus' node to describe the CPU cores of Zynq.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
---
v2:
 - remove cache size related properties
---
 arch/arm/boot/dts/zynq-7000.dtsi | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 605a2d0a39fc..23ba82c205a2 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -15,6 +15,25 @@
 / {
 	compatible = "xlnx,zynq-7000";
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			compatible = "arm,cortex-a9";
+			device_type = "cpu";
+			reg = <0>;
+			clocks = <&clkc 3>;
+		};
+
+		cpu@1 {
+			compatible = "arm,cortex-a9";
+			device_type = "cpu";
+			reg = <1>;
+			clocks = <&clkc 3>;
+		};
+	};
+
 	pmu {
 		compatible = "arm,cortex-a9-pmu";
 		interrupts = <0 5 4>, <0 6 4>;
-- 
1.8.4.4

