Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030213Ab3DRKOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:14:33 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37487 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965607Ab3DRKN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:13:28 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 30/32] ARM: ux500: Supply MMC DMA configuration via Device Tree
Date: Thu, 18 Apr 2013 11:12:12 +0100
Message-Id: <1366279934-30761-31-git-send-email-lee.jones@linaro.org>
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
 arch/arm/boot/dts/dbx5x0.dtsi |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index bd0fe5f..c064a9a 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -605,6 +605,11 @@
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80126000 0x1000>;
 			interrupts = <0 60 0x4>;
+
+			dmas = <&dma 0 29 0x8>, /* Logical - DevToMem */
+			       <&dma 0 29 0x4>; /* Logical - MemToDev */
+			dma-names = "rx", "tx";
+
 			status = "disabled";
 		};
 
@@ -612,6 +617,11 @@
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80118000 0x1000>;
 			interrupts = <0 50 0x4>;
+
+			dmas = <&dma 0 32 0x8>, /* Logical - DevToMem */
+			       <&dma 0 32 0x4>; /* Logical - MemToDev */
+			dma-names = "rx", "tx";
+
 			status = "disabled";
 		};
 
@@ -619,6 +629,11 @@
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80005000 0x1000>;
 			interrupts = <0 41 0x4>;
+
+			dmas = <&dma 0 28 0x8>, /* Logical - DevToMem */
+			       <&dma 0 28 0x4>; /* Logical - MemToDev */
+			dma-names = "rx", "tx";
+
 			status = "disabled";
 		};
 
@@ -633,6 +648,11 @@
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80114000 0x1000>;
 			interrupts = <0 99 0x4>;
+
+			dmas = <&dma 0 42 0x8>, /* Logical - DevToMem */
+			       <&dma 0 42 0x4>; /* Logical - MemToDev */
+			dma-names = "rx", "tx";
+
 			status = "disabled";
 		};
 
-- 
1.7.10.4

