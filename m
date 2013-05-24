Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217Ab3EXJYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:24:38 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48778 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760009Ab3EXJX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:23:28 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: davem@davemloft.net
Cc: linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Florian Fainelli <florian@openwrt.org>,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com
Subject: [PATCHv3 5/6] ARM: cubieboard: Enable ethernet (EMAC) support in dts
Date: Fri, 24 May 2013 11:23:13 +0200
Message-Id: <1369387394-9453-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369387394-9453-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1369387394-9453-1-git-send-email-maxime.ripard@free-electrons.com>
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

