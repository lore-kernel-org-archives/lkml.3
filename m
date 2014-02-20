Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbaBTOwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:52:09 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:60566 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbaBTOt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:49:58 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        devicetree@vger.kernel.org
Subject: [PATCH 10/11] ARM: shmobile: lager dts: Add MSIOF nodes
Date: Thu, 20 Feb 2014 15:49:38 +0100
Message-Id: <1392907779-22053-11-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392907779-22053-1-git-send-email-geert@linux-m68k.org>
References: <1392907779-22053-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Add pinctrl and SPI device for MSIOF on Lager.
On this board, only MSIOF1 is in use. Its bus contains a single device
(a Renesas R2A11302FT PMIC), for which no bindings are defined yet.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: devicetree@vger.kernel.org
---
 arch/arm/boot/dts/r8a7790-lager.dts |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index 5d53def10c42..0658c881687e 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -148,6 +148,12 @@
 		renesas,groups = "qspi_ctrl", "qspi_data4";
 		renesas,function = "qspi";
 	};
+
+	msiof1_pins: spi2 {
+		renesas,groups = "msiof1_clk", "msiof1_sync", "msiof1_rx",
+				 "msiof1_tx";
+		renesas,function = "msiof1";
+	};
 };
 
 &mmcif1 {
@@ -195,6 +201,22 @@
 	};
 };
 
+&msiof1 {
+	pinctrl-0 = <&msiof1_pins>;
+	pinctrl-names = "default";
+
+	status = "okay";
+
+	pmic: pmic@0 {
+		compatible = "renesas,r2a11302ft";
+		reg = <0>;
+		spi-max-frequency = <6000000>;
+		spi-cpol;
+		spi-cpha;
+	};
+
+};
+
 &sdhi0 {
 	pinctrl-0 = <&sdhi0_pins>;
 	pinctrl-names = "default";
-- 
1.7.9.5

