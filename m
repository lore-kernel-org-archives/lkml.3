Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaIOODI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:03:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38273 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753074AbaIOOCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:02:01 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 8/9] ARM: dts: berlin: add the Ethernet node
Date: Mon, 15 Sep 2014 16:01:52 +0200
Message-Id: <1410789713-15341-9-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410789713-15341-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1410789713-15341-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Ethernet node, enabling the network unit on Berlin
BG2Q SoCs.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 902eddb19cd8..a88db4097b47 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -114,6 +114,16 @@
 			#interrupt-cells = <3>;
 		};
 
+		eth0: ethernet@b90000 {
+			compatible = "marvell,pxa168-eth";
+			reg = <0xb90000 0x10000>;
+			clocks = <&chip CLKID_GETH0>;
+			interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
+			/* set by bootloader */
+			local-mac-address = [00 00 00 00 00 00];
+			status = "disabled";
+		};
+
 		cpu-ctrl@dd0000 {
 			compatible = "marvell,berlin-cpu-ctrl";
 			reg = <0xdd0000 0x10000>;
-- 
1.9.1

