Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968002Ab3DRKO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:14:58 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35002 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967913Ab3DRKNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:13:20 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 26/32] ARM: ux500: Supply UART's DMA configuration via Device Tree
Date: Thu, 18 Apr 2013 11:12:08 +0100
Message-Id: <1366279934-30761-27-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When requesting a channel, a DMA client needs to pass some pieces of
information such as; request channel, device type, channel type and
direction etc. Normally we do this in the form of platform data, but
when DT is enabled we need to pass it using the driver's bindings
instead.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index e2fa20f..bd0fe5f 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -569,18 +569,35 @@
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x80120000 0x1000>;
 			interrupts = <0 11 0x4>;
+
+			dmas = <&dma 0 13 0x8>, /* Logical - DevToMem */
+			       <&dma 0 13 0x4>; /* Logical - MemToDev */
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
+			dmas = <&dma 0 12 0x8>, /* Logical - DevToMem */
+			       <&dma 0 12 0x4>; /* Logical - MemToDev */
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
+			dmas = <&dma 0 11 0x8>, /* Logical - DevToMem */
+			       <&dma 0 11 0x4>; /* Logical - MemToDev */
+			dma-names = "rx", "tx";
+
 			status = "disabled";
 		};
 
-- 
1.7.10.4

