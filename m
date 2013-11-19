Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab3KSLKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:10:51 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:44987 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab3KSLIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:08:12 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/10] ARM: ux500: Add DMA config bindings for MSP devices
Date: Tue, 19 Nov 2013 11:07:43 +0000
Message-Id: <1384859269-19801-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
References: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/ste-dbx5x0.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/ste-dbx5x0.dtsi b/arch/arm/boot/dts/ste-dbx5x0.dtsi
index 7da99fe..50ff5ab 100644
--- a/arch/arm/boot/dts/ste-dbx5x0.dtsi
+++ b/arch/arm/boot/dts/ste-dbx5x0.dtsi
@@ -913,6 +913,10 @@
 			interrupts = <0 31 IRQ_TYPE_LEVEL_HIGH>;
 			v-ape-supply = <&db8500_vape_reg>;
 
+			dmas = <&dma 31 0 0x12>, /* Logical - DevToMem - HighPrio */
+			       <&dma 31 0 0x10>; /* Logical - MemToDev - HighPrio */
+			dma-names = "rx", "tx";
+
 			clocks = <&prcc_kclk 1 3>, <&prcc_pclk 1 3>;
 			clock-names = "msp", "apb_pclk";
 
@@ -925,6 +929,9 @@
 			interrupts = <0 62 IRQ_TYPE_LEVEL_HIGH>;
 			v-ape-supply = <&db8500_vape_reg>;
 
+			dmas = <&dma 30 0 0x10>; /* Logical - MemToDev - HighPrio */
+			dma-names = "tx";
+
 			clocks = <&prcc_kclk 1 4>, <&prcc_pclk 1 4>;
 			clock-names = "msp", "apb_pclk";
 
@@ -938,6 +945,11 @@
 			interrupts = <0 98 IRQ_TYPE_LEVEL_HIGH>;
 			v-ape-supply = <&db8500_vape_reg>;
 
+			dmas = <&dma 14 0 0x12>, /* Logical  - DevToMem - HighPrio */
+			       <&dma 14 1 0x19>; /* Physical Chan 1 - MemToDev
+                                                    HighPrio - Fixed */
+			dma-names = "rx", "tx";
+
 			clocks = <&prcc_kclk 2 3>, <&prcc_pclk 2 5>;
 			clock-names = "msp", "apb_pclk";
 
@@ -950,6 +962,9 @@
 			interrupts = <0 62 IRQ_TYPE_LEVEL_HIGH>;
 			v-ape-supply = <&db8500_vape_reg>;
 
+			dmas = <&dma 30 0 0x12>; /* Logical - DevToMem - HighPrio */
+			dma-names = "rx";
+
 			clocks = <&prcc_kclk 1 10>, <&prcc_pclk 1 11>;
 			clock-names = "msp", "apb_pclk";
 
-- 
1.8.1.2

