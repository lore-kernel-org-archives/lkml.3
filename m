Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab3DWPD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:03:57 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:44452 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab3DWPDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:03:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        mian.yousaf.kaukab@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/10] ARM: ux500: Populate the ux500-musb Device Tree entry
Date: Tue, 23 Apr 2013 16:03:12 +0100
Message-Id: <1366729394-11406-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides all the information to successfully probe() and
correctly configure the ux500-musb device driver for DMA.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 86b35a1..f4f371f 100644
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
+			mode = "otg";
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
-- 
1.7.10.4

