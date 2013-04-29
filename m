Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779Ab3D2ThO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:37:14 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50831 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759820Ab3D2ThI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:37:08 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        netdev@vger.kernel.org, Alejandro Mery <amery@geeks.cl>,
        Emilio Lopez <emilio@elopez.com.ar>, Stefan Roese <sr@denx.de>,
        Florian Fainelly <florian@openwrt.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] ARM: cubieboard: Enable ethernet (EMAC) support in dts
Date: Mon, 29 Apr 2013 21:36:57 +0200
Message-Id: <1367264218-15235-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367264218-15235-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1367264218-15235-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Roese <sr@denx.de>

Signed-off-by: Stefan Roese <sr@denx.de>
---
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
index b70fe0d..32d9b18 100644
--- a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
+++ b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
@@ -27,6 +27,21 @@
 	};
 
 	soc@01c20000 {
+		emac: ethernet@01c0b000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&emac_pins_a>;
+			phy = <&phy0>;
+			status = "okay";
+		};
+
+		mdio@01c0b080 {
+			status = "okay";
+
+			phy0: ethernet-phy@0 {
+				reg = <0>;
+			};
+		};
+
 		pinctrl@01c20800 {
 			led_pins_cubieboard: led_pins@0 {
 				allwinner,pins = "PH20", "PH21";
-- 
1.8.1.2

