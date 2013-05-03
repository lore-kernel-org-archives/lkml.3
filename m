Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab3ECOda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:33:30 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48106 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113Ab3ECOd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:33:28 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/63] ARM: ux500: Populate the ux500-musb Device Tree entry
Date: Fri,  3 May 2013 15:31:51 +0100
Message-Id: <1367591569-32197-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides all the information to successfully probe() and
correctly configure the ux500-musb device driver for DMA.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

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
-- 
1.7.10.4

