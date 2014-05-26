Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaEZOxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:53:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37672 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752461AbaEZOv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:51:56 -0400
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
Subject: [PATCH v5 6/7] ARM: berlin: add the AHCI node for the BG2Q
Date: Mon, 26 May 2014 16:51:47 +0200
Message-Id: <1401115908-2742-7-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401115908-2742-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1401115908-2742-1-git-send-email-antoine.tenart@free-electrons.com>
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
 arch/arm/boot/dts/berlin2q.dtsi | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 07452a7483fa..3486a8c3054a 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -183,6 +183,33 @@
 			};
 		};
 
+		ahci: sata@e90000 {
+			compatible = "generic-ahci";
+			reg = <0xe90000 0x1000>;
+			interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
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
+			compatible = "marvell,berlin-sata-phy";
+			reg = <0xe900a0 0x200>;
+			#phy-cells = <1>;
+			status = "disabled";
+		};
+
 		apb@fc0000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
-- 
1.9.1

