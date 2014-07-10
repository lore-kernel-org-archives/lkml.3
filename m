Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaGJSyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:54:01 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46092 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaGJSx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:53:58 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH] ARM: zynq: dt: Add GPIO node
Date: Thu, 10 Jul 2014 11:53:38 -0700
Message-Id: <1405018418-23396-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add node describing Zynq's GPIO controller.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
The GPIO driver and binding documentation is staged in Linus' GPIO tree.

	Sören

 arch/arm/boot/dts/zynq-7000.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 760bbc463c5b..504cca338247 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -65,6 +65,16 @@
 		interrupt-parent = <&intc>;
 		ranges;
 
+		gpio0: gpio@e000a000 {
+			compatible = "xlnx,zynq-gpio-1.0";
+			#gpio-cells = <2>;
+			clocks = <&clkc 42>;
+			gpio-controller;
+			interrupt-parent = <&intc>;
+			interrupts = <0 20 4>;
+			reg = <0xe000a000 0x1000>;
+		};
+
 		i2c0: i2c@e0004000 {
 			compatible = "cdns,i2c-r1p10";
 			status = "disabled";
-- 
2.0.1.1.gfbfc394

