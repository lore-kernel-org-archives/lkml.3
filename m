Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab3FMQhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:37:48 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50101 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713Ab3FMQhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:37:46 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Dinh Nguyen <dinguyen@altera.com>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v3 2/4] arm: dt: zynq: Use 'status' property for UART nodes
Date: Thu, 13 Jun 2013 09:37:16 -0700
Message-Id: <1371141438-16553-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371141438-16553-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1371141438-16553-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the default status for UARTs to disabled in the zynq-7000.dtsi file
and let board dts files enable the UARTs on demand.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/boot/dts/zynq-7000.dtsi | 2 ++
 arch/arm/boot/dts/zynq-zc702.dts | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 0dbee2c..6f54a64 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -49,6 +49,7 @@
 
 		uart0: uart@e0000000 {
 			compatible = "xlnx,xuartps";
+			status = "disabled";
 			clocks = <&clkc 23>, <&clkc 40>;
 			clock-names = "ref_clk", "aper_clk";
 			reg = <0xE0000000 0x1000>;
@@ -57,6 +58,7 @@
 
 		uart1: uart@e0001000 {
 			compatible = "xlnx,xuartps";
+			status = "disabled";
 			clocks = <&clkc 24>, <&clkc 41>;
 			clock-names = "ref_clk", "aper_clk";
 			reg = <0xE0001000 0x1000>;
diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index e25a307..21aea99 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -24,7 +24,11 @@
 	};
 
 	chosen {
-		bootargs = "console=ttyPS1,115200 earlyprintk";
+		bootargs = "console=ttyPS0,115200 earlyprintk";
 	};
 
 };
+
+&uart1 {
+	status = "okay";
+};
-- 
1.8.3

