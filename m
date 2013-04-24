Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab3DXHlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 03:41:53 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:36513 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab3DXHlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 03:41:51 -0400
Date: Wed, 24 Apr 2013 08:41:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        mian.yousaf.kaukab@stericsson.com
Subject: [PATCH 08/10 v2] ARM: ux500: Populate the ux500-musb Device Tree
 entry
Message-ID: <20130424074146.GC17416@gmail.com>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
 <1366729394-11406-9-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366729394-11406-9-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides all the information to successfully probe() and
correctly configure the ux500-musb device driver for DMA.
    
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 86b35a1..838214c 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -175,11 +175,40 @@
 			prcm = <&prcmu>;
 		};
 
-		usb@a03e0000 {
+		usb_per5@a03e0000 {
 			compatible = "stericsson,db8500-musb",
 				"mentor,musb";
 			reg = <0xa03e0000 0x10000>;
 			interrupts = <0 23 0x4>;
+			interrupt-names = "mc";
+
+			dr_mode = "otg";
+
+			dmas = <&dma 38 0 0x2>, /* Logical - DevToMem */
+			       <&dma 38 0 0x0>, /* Logical - MemToDev */
+			       <&dma 37 0 0x2>, /* Logical - DevToMem */
+			       <&dma 37 0 0x0>, /* Logical - MemToDev */
+			       <&dma 36 0 0x2>, /* Logical - DevToMem */
+			       <&dma 36 0 0x0>, /* Logical - MemToDev */
+			       <&dma 19 0 0x2>, /* Logical - DevToMem */
+			       <&dma 19 0 0x0>, /* Logical - MemToDev */
+			       <&dma 18 0 0x2>, /* Logical - DevToMem */
+			       <&dma 18 0 0x0>, /* Logical - MemToDev */
+			       <&dma 17 0 0x2>, /* Logical - DevToMem */
+			       <&dma 17 0 0x0>, /* Logical - MemToDev */
+			       <&dma 16 0 0x2>, /* Logical - DevToMem */
+			       <&dma 16 0 0x0>, /* Logical - MemToDev */
+			       <&dma 39 0 0x2>, /* Logical - DevToMem */
+			       <&dma 39 0 0x0>; /* Logical - MemToDev */
+
+			dma-names = "iep_1_9",  "oep_1_9",
+				    "iep_2_10", "oep_2_10",
+				    "iep_3_11", "oep_3_11",
+				    "iep_4_12", "oep_4_12",
+				    "iep_5_13", "oep_5_13",
+				    "iep_6_14", "oep_6_14",
+				    "iep_7_15", "oep_7_15",
+				    "iep_8",    "oep_8";
 		};
 
 		dma: dma-controller@801C0000 {
