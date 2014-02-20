Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaBTOuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:50:40 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:60576 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbaBTOt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:49:58 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        devicetree@vger.kernel.org
Subject: [PATCH 06/11] ARM: shmobile: r8a7790/lager dts: Rename label spi to qspi, add spi0 alias
Date: Thu, 20 Feb 2014 15:49:34 +0100
Message-Id: <1392907779-22053-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392907779-22053-1-git-send-email-geert@linux-m68k.org>
References: <1392907779-22053-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Prepare for the advent of MSIOF SPI, which will be spi1 to spi4.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: devicetree@vger.kernel.org
---
 arch/arm/boot/dts/r8a7790-lager.dts |    4 ++--
 arch/arm/boot/dts/r8a7790.dtsi      |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index 26a90106e96c..5d53def10c42 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -144,7 +144,7 @@
 		renesas,function = "mmc1";
 	};
 
-	qspi_pins: spi {
+	qspi_pins: spi0 {
 		renesas,groups = "qspi_ctrl", "qspi_data4";
 		renesas,function = "qspi";
 	};
@@ -164,7 +164,7 @@
 	status = "okay";
 };
 
-&spi {
+&qspi {
 	pinctrl-0 = <&qspi_pins>;
 	pinctrl-names = "default";
 
diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
index a1e7c396afea..bc652a2848e7 100644
--- a/arch/arm/boot/dts/r8a7790.dtsi
+++ b/arch/arm/boot/dts/r8a7790.dtsi
@@ -23,6 +23,7 @@
 		i2c1 = &i2c1;
 		i2c2 = &i2c2;
 		i2c3 = &i2c3;
+		spi0 = &qspi;
 	};
 
 	cpus {
@@ -753,7 +754,7 @@
 		};
 	};
 
-	spi: spi@e6b10000 {
+	qspi: spi@e6b10000 {
 		compatible = "renesas,qspi-r8a7790", "renesas,qspi";
 		reg = <0 0xe6b10000 0 0x2c>;
 		interrupts = <0 184 IRQ_TYPE_LEVEL_HIGH>;
-- 
1.7.9.5

