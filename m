Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab3H2Rxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:53:46 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54017 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab3H2Rxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:53:45 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 3/3] arm: dt: zynq: Mark TTC input clock as unstable
Date: Thu, 29 Aug 2013 10:53:10 -0700
Message-Id: <1377798790-28927-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1377798790-28927-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1377798790-28927-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Zynq the TTC's input clock is directly derived from the CPU clock.
I.e. the input clock is not constant but scales with the CPU frequency.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/boot/dts/zynq-7000.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 6f54a64..c4d4e59 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -97,6 +97,7 @@
 			interrupts = < 0 10 4 0 11 4 0 12 4 >;
 			compatible = "cdns,ttc";
 			clocks = <&clkc 6>;
+			input-clock-unstable;
 			reg = <0xF8001000 0x1000>;
 			clock-ranges;
 		};
@@ -107,6 +108,7 @@
 			compatible = "cdns,ttc";
 			clocks = <&clkc 6>;
 			reg = <0xF8002000 0x1000>;
+			input-clock-unstable;
 			clock-ranges;
 		};
 		scutimer: scutimer@f8f00600 {
-- 
1.8.4

