Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaH2NwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:52:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48991 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753009AbaH2NwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:52:10 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, thomas.petazzoni@free-electrons.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ARM: dts: berlin: add ethernet and mdio nodes
Date: Fri, 29 Aug 2014 15:51:02 +0200
Message-Id: <1409320263-10295-5-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409320263-10295-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1409320263-10295-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the mdio and the Ethernet nodes, enabling the network
unit on Berlin BG2Q SoCs.

The mac address is set to 00:00:00:00:00:00 so that the one set by the
bootloader is used. The PHY nodes are in the board device tree.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 400c40fceccc..bb84a3d3740f 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -114,6 +114,25 @@
 			#interrupt-cells = <3>;
 		};
 
+		eth0: ethernet@b90000 {
+			compatible = "marvell,berlin-eth";
+			reg = <0xb90000 0x10000>;
+			clocks = <&chip CLKID_GETH0>;
+			interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
+			/* set by bootloader */
+			local-mac-address = [00 00 00 00 00 00];
+			status = "disabled";
+		};
+
+		mdio: mdio-bus@b90010 {
+			compatible = "marvell,orion-mdio";
+			reg = <0xb90010 0x84>;
+			clocks = <&chip CLKID_GETH0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+		};
+
 		cpu-ctrl@dd0000 {
 			compatible = "marvell,berlin-cpu-ctrl";
 			reg = <0xdd0000 0x10000>;
-- 
1.9.1

