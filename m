Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab3ECOdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:33:32 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:47692 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab3ECOd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:33:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/63] ARM: ux500: Supply MMC DMA configuration via Device Tree
Date: Fri,  3 May 2013 15:31:50 +0100
Message-Id: <1367591569-32197-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When requesting a channel, a DMA client needs to pass some pieces of
information such as; request channel, device type, channel type and
direction etc. Normally we do this in the form of platform data, but
when DT is enabled we need to pass it using the driver's bindings
instead.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index d595e2c..86b35a1 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -604,6 +604,11 @@
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80126000 0x1000>;
 			interrupts = <0 60 0x4>;
+
+			dmas = <&dma 29 0 0x2>, /* Logical - DevToMem */
+			       <&dma 29 0 0x0>; /* Logical - MemToDev */
+			dma-names = "rx", "tx";
+
 			status = "disabled";
 		};
 
@@ -611,6 +616,11 @@
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80118000 0x1000>;
 			interrupts = <0 50 0x4>;
+
+			dmas = <&dma 32 0 0x2>, /* Logical - DevToMem */
+			       <&dma 32 0 0x0>; /* Logical - MemToDev */
+			dma-names = "rx", "tx";
+
 			status = "disabled";
 		};
 
@@ -618,6 +628,11 @@
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80005000 0x1000>;
 			interrupts = <0 41 0x4>;
+
+			dmas = <&dma 28 0 0x2>, /* Logical - DevToMem */
+			       <&dma 28 0 0x0>; /* Logical - MemToDev */
+			dma-names = "rx", "tx";
+
 			status = "disabled";
 		};
 
@@ -632,6 +647,11 @@
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80114000 0x1000>;
 			interrupts = <0 99 0x4>;
+
+			dmas = <&dma 42 0 0x2>, /* Logical - DevToMem */
+			       <&dma 42 0 0x0>; /* Logical - MemToDev */
+			dma-names = "rx", "tx";
+
 			status = "disabled";
 		};
 
-- 
1.7.10.4

