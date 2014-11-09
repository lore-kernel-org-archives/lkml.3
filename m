Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaKIDiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 22:38:12 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:45769 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaKIDiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 22:38:10 -0500
From: Peter Crosthwaite <crosthwaitepeter@gmail.com>
X-Google-Original-From: Peter Crosthwaite <crosthwaite.peter@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: michals@xilinx.com, sorenb@xilinx.com, steven.wang@digilentinc.com
Subject: [PATCH 1/2] arm: dts: zynq: Move crystal freq. to board level
Date: Sun,  9 Nov 2014 13:38:02 +1000
Message-Id: <1415504283-31321-1-git-send-email-crosthwaite.peter@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fact that all supported boards use the same 33MHz crystal is a
co-incidence. The Zynq PS support a range of crystal freqs so the
hardcoded setting should be removed from the dtsi. Re-implement it
on the board level.

This prepares support for Zynq boards with different crystal
frequencies (e.g. the Digilent ZYBO).

Signed-off-by: Peter Crosthwaite <crosthwaite.peter@gmail.com>

---
Im guessing long term this should be converted to a fixed clock. But
I think this at least steps in that direction.
---
 arch/arm/boot/dts/zynq-7000.dtsi      | 1 -
 arch/arm/boot/dts/zynq-parallella.dts | 4 ++++
 arch/arm/boot/dts/zynq-zc702.dts      | 4 ++++
 arch/arm/boot/dts/zynq-zc706.dts      | 4 ++++
 arch/arm/boot/dts/zynq-zed.dts        | 4 ++++
 5 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index ce2ef5b..ee3e5d6 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -243,7 +243,6 @@
 			clkc: clkc@100 {
 				#clock-cells = <1>;
 				compatible = "xlnx,ps7-clkc";
-				ps-clk-frequency = <33333333>;
 				fclk-enable = <0>;
 				clock-output-names = "armpll", "ddrpll", "iopll", "cpu_6or4x",
 						"cpu_3or2x", "cpu_2x", "cpu_1x", "ddr2x", "ddr3x",
diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
index e1f51ca..cd84d45 100644
--- a/arch/arm/boot/dts/zynq-parallella.dts
+++ b/arch/arm/boot/dts/zynq-parallella.dts
@@ -83,3 +83,7 @@
 &uart1 {
 	status = "okay";
 };
+
+&clkc {
+	ps-clk-frequency = <33333333>;
+};
diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index 94e2cda..24dcece 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -135,3 +135,7 @@
 &uart1 {
 	status = "okay";
 };
+
+&clkc {
+	ps-clk-frequency = <33333333>;
+};
diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
index a8bbdfb..7b88399 100644
--- a/arch/arm/boot/dts/zynq-zc706.dts
+++ b/arch/arm/boot/dts/zynq-zc706.dts
@@ -114,3 +114,7 @@
 &uart1 {
 	status = "okay";
 };
+
+&clkc {
+	ps-clk-frequency = <33333333>;
+};
diff --git a/arch/arm/boot/dts/zynq-zed.dts b/arch/arm/boot/dts/zynq-zed.dts
index 697779a..4662da2 100644
--- a/arch/arm/boot/dts/zynq-zed.dts
+++ b/arch/arm/boot/dts/zynq-zed.dts
@@ -46,3 +46,7 @@
 &uart1 {
 	status = "okay";
 };
+
+&clkc {
+	ps-clk-frequency = <33333333>;
+};
-- 
1.9.1

