Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaKWQLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 11:11:21 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:58556 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbaKWQLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 11:11:19 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Carlo Caione <carlo@caione.org>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH] ARM: dts: meson: enable Ethernet controller
Date: Sun, 23 Nov 2014 17:08:48 +0100
Message-Id: <1416758928-12640-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a node for the Ethernet controller to Meson DTS file and
enable it on the Geniatech ATV1200 board.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 arch/arm/boot/dts/meson.dtsi         | 11 +++++++++++
 arch/arm/boot/dts/meson6-atv1200.dts |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/meson.dtsi b/arch/arm/boot/dts/meson.dtsi
index 03bcff8..4704b95 100644
--- a/arch/arm/boot/dts/meson.dtsi
+++ b/arch/arm/boot/dts/meson.dtsi
@@ -143,5 +143,16 @@
 			#size-cells = <0>;
 			status = "disabled";
 		};
+
+		ethmac: ethernet@c9410000 {
+			compatible = "amlogic,meson6-dwmac", "snps,dwmac";
+			reg = <0xc9410000 0x10000
+			       0xc1108108 0x4>;
+			interrupts = <0 8 1>;
+			interrupt-names = "macirq";
+			clocks = <&clk81>;
+			clock-names = "stmmaceth";
+			status = "disabled";
+		};
 	};
 }; /* end of / */
diff --git a/arch/arm/boot/dts/meson6-atv1200.dts b/arch/arm/boot/dts/meson6-atv1200.dts
index d7d351a..1237faa 100644
--- a/arch/arm/boot/dts/meson6-atv1200.dts
+++ b/arch/arm/boot/dts/meson6-atv1200.dts
@@ -64,3 +64,7 @@
 &uart_AO {
 	status = "okay";
 };
+
+&ethmac {
+	status = "okay";
+};
-- 
1.9.1

