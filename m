Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaEBVIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 17:08:46 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:38288 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaEBVIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 17:08:44 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, git@xilinx.com,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] ARM: zynq: dt: Add a fixed regulator for CPU voltage
Date: Fri,  2 May 2014 14:07:32 -0700
Message-Id: <1399064852-19569-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.2.1.g06c4abd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To silence the warning
	cpufreq_cpu0: failed to get cpu0 regulator: -19
from the cpufreq driver regarding a missing regulator,
add a fixed regulator to the DT.
Zynq does not support voltage scaling and the CPU rail should always be
supplied with 1 V, hence it is added in the SOC-level dtsi.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---

 arch/arm/boot/dts/zynq-7000.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index c1176abc34d9..64779f9d5c38 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -25,6 +25,7 @@
 			reg = <0>;
 			clocks = <&clkc 3>;
 			clock-latency = <1000>;
+			cpu0-supply = <&regulator_vccpint>;
 			operating-points = <
 				/* kHz    uV */
 				666667  1000000
@@ -48,6 +49,15 @@
 		reg = < 0xf8891000 0x1000 0xf8893000 0x1000 >;
 	};
 
+	regulator_vccpint: fixedregulator@0 {
+		compatible = "regulator-fixed";
+		regulator-name = "VCCPINT";
+		regulator-min-microvolt = <1000000>;
+		regulator-max-microvolt = <1000000>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
+
 	amba {
 		compatible = "simple-bus";
 		#address-cells = <1>;
-- 
1.9.2.1.g06c4abd

