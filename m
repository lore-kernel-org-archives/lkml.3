Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaBYKaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:30:35 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:59944 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbaBYKaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:30:24 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        devicetree@vger.kernel.org
Subject: [PATCH v2 10/11] ARM: shmobile: koelsch dts: Add MSIOF nodes
Date: Tue, 25 Feb 2014 11:30:18 +0100
Message-Id: <1393324219-3317-11-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393324219-3317-1-git-send-email-geert@linux-m68k.org>
References: <1393324219-3317-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Add pinctrl and SPI device for MSIOF on Koelsch.
On this board, only MSIOF0 is in use. Its bus contains a single device
(a Renesas R2A11302FT PMIC), for which no bindings are defined yet.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: devicetree@vger.kernel.org
---
v2:
  - No changes

 arch/arm/boot/dts/r8a7791-koelsch.dts |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/r8a7791-koelsch.dts
index 03508cc73e8b..f3eb83c4265d 100644
--- a/arch/arm/boot/dts/r8a7791-koelsch.dts
+++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
@@ -161,6 +161,12 @@
 		renesas,groups = "qspi_ctrl", "qspi_data4";
 		renesas,function = "qspi";
 	};
+
+	msiof0_pins: spi1 {
+		renesas,groups = "msiof0_clk", "msiof0_sync", "msiof0_rx",
+				 "msiof0_tx";
+		renesas,function = "msiof0";
+	};
 };
 
 &ether {
@@ -212,3 +218,18 @@
 		};
 	};
 };
+
+&msiof0 {
+	pinctrl-0 = <&msiof0_pins>;
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
+};
-- 
1.7.9.5

