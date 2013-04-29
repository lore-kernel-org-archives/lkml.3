Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789Ab3D2TiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:38:00 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50825 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759799Ab3D2ThH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:37:07 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        netdev@vger.kernel.org, Alejandro Mery <amery@geeks.cl>,
        Emilio Lopez <emilio@elopez.com.ar>, Stefan Roese <sr@denx.de>,
        Florian Fainelly <florian@openwrt.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] ARM: sunxi: Add EMAC controller node to sun4i DTSI
Date: Mon, 29 Apr 2013 21:36:56 +0200
Message-Id: <1367264218-15235-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367264218-15235-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1367264218-15235-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun4i-a10.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index ff1f41f..983da33 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -163,6 +163,22 @@
 		reg = <0x01c20000 0x300000>;
 		ranges;
 
+		emac: ethernet@01c0b000 {
+			compatible = "allwinner,sun4i-emac";
+			reg = <0x01c0b000 0x1000>;
+			interrupts = <55>;
+			clocks = <&ahb_gates 17>;
+			status = "disabled";
+		};
+
+		mdio@01c0b080 {
+			compatible = "allwinner,sun4i-mdio";
+			reg = <0x01c0b080 0x14>;
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
 		intc: interrupt-controller@01c20400 {
 			compatible = "allwinner,sun4i-ic";
 			reg = <0x01c20400 0x400>;
-- 
1.8.1.2

