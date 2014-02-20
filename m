Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaBTOuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:50:00 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:59329 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaBTOtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:49:53 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        devicetree@vger.kernel.org
Subject: [PATCH 08/11] ARM: shmobile: r8a7790 dtsi: Add MSIOF nodes and aliases
Date: Thu, 20 Feb 2014 15:49:36 +0100
Message-Id: <1392907779-22053-9-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392907779-22053-1-git-send-email-geert@linux-m68k.org>
References: <1392907779-22053-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: devicetree@vger.kernel.org
---
 arch/arm/boot/dts/r8a7790.dtsi |   52 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
index bc652a2848e7..aab5f4cf6ce2 100644
--- a/arch/arm/boot/dts/r8a7790.dtsi
+++ b/arch/arm/boot/dts/r8a7790.dtsi
@@ -24,6 +24,10 @@
 		i2c2 = &i2c2;
 		i2c3 = &i2c3;
 		spi0 = &qspi;
+		spi1 = &msiof0;
+		spi2 = &msiof1;
+		spi3 = &msiof2;
+		spi4 = &msiof3;
 	};
 
 	cpus {
@@ -764,4 +768,52 @@
 		#size-cells = <0>;
 		status = "disabled";
 	};
+
+	msiof0: spi@e6e20000 {
+		compatible = "renesas,msiof-r8a7790";
+		reg = <0 0xe6e20000 0 0x0064>;
+		interrupts = <0 156 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp0_clks R8A7790_CLK_MSIOF0>;
+		num-cs = <1>;
+		renesas,rx-fifo-size = <256>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	msiof1: spi@e6e10000 {
+		compatible = "renesas,msiof-r8a7790";
+		reg = <0 0xe6e10000 0 0x0064>;
+		interrupts = <0 157 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp2_clks R8A7790_CLK_MSIOF1>;
+		num-cs = <1>;
+		renesas,rx-fifo-size = <256>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	msiof2: spi@e6e00000 {
+		compatible = "renesas,msiof-r8a7790";
+		reg = <0 0xe6e00000 0 0x0064>;
+		interrupts = <0 158 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp2_clks R8A7790_CLK_MSIOF2>;
+		num-cs = <1>;
+		renesas,rx-fifo-size = <256>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	msiof3: spi@e6c90000 {
+		compatible = "renesas,msiof-r8a7790";
+		reg = <0 0xe6c90000 0 0x0064>;
+		interrupts = <0 159 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp2_clks R8A7790_CLK_MSIOF3>;
+		num-cs = <1>;
+		renesas,rx-fifo-size = <256>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
 };
-- 
1.7.9.5

