Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab3ECOuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:50:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52523 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab3ECOdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:33:24 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/63] ARM: ux500: Supply UART's DMA configuration via Device Tree
Date: Fri,  3 May 2013 15:31:49 +0100
Message-Id: <1367591569-32197-4-git-send-email-lee.jones@linaro.org>
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
 arch/arm/boot/dts/dbx5x0.dtsi |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 8a82b18..d595e2c 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -568,18 +568,35 @@
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x80120000 0x1000>;
 			interrupts = <0 11 0x4>;
+
+			dmas = <&dma 13 0 0x2>, /* Logical - DevToMem */
+			       <&dma 13 0 0x0>; /* Logical - MemToDev */
+			dma-names = "rx", "tx";
+
 			status = "disabled";
 		};
+
 		uart@80121000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x80121000 0x1000>;
 			interrupts = <0 19 0x4>;
+
+			dmas = <&dma 12 0 0x2>, /* Logical - DevToMem */
+			       <&dma 12 0 0x0>; /* Logical - MemToDev */
+			dma-names = "rx", "tx";
+
 			status = "disabled";
 		};
+
 		uart@80007000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x80007000 0x1000>;
 			interrupts = <0 26 0x4>;
+
+			dmas = <&dma 11 0 0x2>, /* Logical - DevToMem */
+			       <&dma 11 0 0x0>; /* Logical - MemToDev */
+			dma-names = "rx", "tx";
+
 			status = "disabled";
 		};
 
-- 
1.7.10.4

