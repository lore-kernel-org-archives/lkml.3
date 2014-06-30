Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaF3NLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:11:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54477 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753086AbaF3NLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:11:21 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 6/7] ARM: berlin: add the AHCI node for the BG2Q
Date: Mon, 30 Jun 2014 15:09:31 +0200
Message-Id: <1404133772-11741-7-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404133772-11741-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1404133772-11741-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BG2Q has an AHCI SATA controller. Add the corresponding nodes
(AHCI, PHY) into its device tree.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 635a16a64cb4..fa34ae6657ac 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -303,6 +303,45 @@
 			clock-names = "refclk";
 		};
 
+		ahci: sata@e90000 {
+			compatible = "generic-ahci";
+			reg = <0xe90000 0x1000>;
+			interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&chip CLKID_SATA>;
+			#address-cells = <1>;
+			#size-cells = <0>;
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
+			compatible = "marvell,berlin2q-sata-phy";
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
 		apb@fc0000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
-- 
1.9.1

