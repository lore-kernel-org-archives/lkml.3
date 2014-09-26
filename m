Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaIZOeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:34:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35015 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755186AbaIZOeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:34:06 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 09/10] ARM: dts: berlin: add the Ethernet node
Date: Fri, 26 Sep 2014 16:33:55 +0200
Message-Id: <1411742036-23520-10-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411742036-23520-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1411742036-23520-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Ethernet node, enabling the network unit on Berlin
BG2Q SoCs.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/boot/dts/berlin2q.dtsi | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 902eddb19cd8..d442b22fd1ea 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -114,6 +114,23 @@
 			#interrupt-cells = <3>;
 		};
 
+		eth0: ethernet@b90000 {
+			compatible = "marvell,pxa168-eth";
+			reg = <0xb90000 0x10000>;
+			clocks = <&chip CLKID_GETH0>;
+			interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
+			/* set by bootloader */
+			local-mac-address = [00 00 00 00 00 00];
+			#address-cells = <1>;
+			#size-cells = <0>;
+			phy-handle = <&ethphy0>;
+			status = "disabled";
+
+			ethphy0: ethernet-phy@0 {
+				reg = <0>;
+			};
+		};
+
 		cpu-ctrl@dd0000 {
 			compatible = "marvell,berlin-cpu-ctrl";
 			reg = <0xdd0000 0x10000>;
-- 
1.9.1

