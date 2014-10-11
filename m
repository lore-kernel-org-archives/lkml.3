Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaJKPlu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 11:41:50 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52549 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaJKPlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 11:41:23 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ARM: berlin: Add AHCI and SATA PHY nodes to BG2
Date: Sat, 11 Oct 2014 17:41:12 +0200
Message-Id: <1413042073-14253-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1413042073-14253-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413042073-14253-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT nodes for the AHCI controller and SATA PHY found on Marvell
Berlin2 SoCs.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Kishon Vijay Abraham I <kishon@ti.com> 
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org 
---
 arch/arm/boot/dts/berlin2.dtsi | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
index d7e81e124de0..7bfe51986a35 100644
--- a/arch/arm/boot/dts/berlin2.dtsi
+++ b/arch/arm/boot/dts/berlin2.dtsi
@@ -246,6 +246,46 @@
 			};
 		};
 
+		ahci: sata@e90000 {
+			compatible = "marvell,berlin2-ahci", "generic-ahci";
+			reg = <0xe90000 0x1000>;
+			interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&chip CLKID_SATA>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			sata0: sata-port@0 {
+				reg = <0>;
+				phys = <&sata_phy 0>;
+				status = "disabled";
+			};
+
+			sata1: sata-port@1 {
+				reg = <1>;
+				phys = <&sata_phy 1>;
+				status = "disabled";
+			};
+		};
+
+		sata_phy: phy@e900a0 {
+			compatible = "marvell,berlin2-sata-phy";
+			reg = <0xe900a0 0x200>;
+			clocks = <&chip CLKID_SATA>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			#phy-cells = <1>;
+			status = "disabled";
+
+			sata-phy@0 {
+				reg = <0>;
+			};
+
+			sata-phy@1 {
+				reg = <1>;
+			};
+		};
+
 		chip: chip-control@ea0000 {
 			compatible = "marvell,berlin2-chip-ctrl";
 			#clock-cells = <1>;
-- 
2.1.1

