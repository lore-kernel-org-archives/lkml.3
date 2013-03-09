Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218Ab3CISOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:14:00 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5559 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3CISNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:13:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sat, 09 Mar 2013 10:06:53 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pdeschrijver@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 3/5] ARM: DT: tegra114:add aliases and DMA requestor for serial controller
Date: Sat, 9 Mar 2013 23:41:16 +0530
Message-ID: <1362852678-13421-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com>
References: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add APB DMA requestor and serial aliases for serial controller.
There will be two serial driver i.e. 8250 based simple serial driver
and APB DMA based serial driver for higher baudrate and performace.

The simple serial driver get enabled with compatible "nvidia,tegra114-uart",
"nvidia,tegra20-uart" and APB DMA based driver will get enabled with
compatible "nvidia,tegra114-hsuart", "nvidia,tegra30-hsuart".

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Remove UARTB car id correction. Make the compatible with tegra114 and
  tegra30 for hsuart and tegra20 for simple uart driver.

 arch/arm/boot/dts/tegra114.dtsi |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index 14afbc8..300082d 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -4,6 +4,13 @@
 	compatible = "nvidia,tegra114";
 	interrupt-parent = <&gic>;
 
+	aliases {
+		serial0 = &uarta;
+		serial1 = &uartb;
+		serial2 = &uartc;
+		serial3 = &uartd;
+	};
+
 	gic: interrupt-controller {
 		compatible = "arm,cortex-a15-gic";
 		#interrupt-cells = <3>;
@@ -99,38 +106,50 @@
 		       0x70003000 0x40c>;	/* Mux registers */
 	};
 
-	serial@70006000 {
+	/*
+	 * There are two serial driver i.e. 8250 based simple serial
+	 * driver and APB DMA based serial driver for higher baudrate
+	 * and performace. To enable the 8250 based driver, the compatible
+	 * is "nvidia,tegra114-uart", "nvidia,tegra20-uart" and to enable
+	 * the APB DMA based serial driver, the comptible is
+	 * "nvidia,tegra114-hsuart", "nvidia,tegra30-hsuart".
+	 */
+	uarta: serial@70006000 {
 		compatible = "nvidia,tegra114-uart", "nvidia,tegra20-uart";
 		reg = <0x70006000 0x40>;
 		reg-shift = <2>;
 		interrupts = <0 36 0x04>;
+		nvidia,dma-request-selector = <&apbdma 8>;
 		status = "disabled";
 		clocks = <&tegra_car 6>;
 	};
 
-	serial@70006040 {
+	uartb: serial@70006040 {
 		compatible = "nvidia,tegra114-uart", "nvidia,tegra20-uart";
 		reg = <0x70006040 0x40>;
 		reg-shift = <2>;
 		interrupts = <0 37 0x04>;
+		nvidia,dma-request-selector = <&apbdma 9>;
 		status = "disabled";
 		clocks = <&tegra_car 192>;
 	};
 
-	serial@70006200 {
+	uartc: serial@70006200 {
 		compatible = "nvidia,tegra114-uart", "nvidia,tegra20-uart";
 		reg = <0x70006200 0x100>;
 		reg-shift = <2>;
 		interrupts = <0 46 0x04>;
+		nvidia,dma-request-selector = <&apbdma 10>;
 		status = "disabled";
 		clocks = <&tegra_car 55>;
 	};
 
-	serial@70006300 {
+	uartd: serial@70006300 {
 		compatible = "nvidia,tegra114-uart", "nvidia,tegra20-uart";
 		reg = <0x70006300 0x100>;
 		reg-shift = <2>;
 		interrupts = <0 90 0x04>;
+		nvidia,dma-request-selector = <&apbdma 19>;
 		status = "disabled";
 		clocks = <&tegra_car 65>;
 	};
-- 
1.7.1.1

