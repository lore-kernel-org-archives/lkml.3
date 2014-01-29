Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaA2Oe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:34:59 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:45125 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbaA2Oey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:34:54 -0500
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Boris BREZILLON <b.brezillon.dev@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: [RFC PATCH v2 12/14] ARM: sunxi/dt: enable NAND on cubietruck board
Date: Wed, 29 Jan 2014 15:34:22 +0100
Message-Id: <1391006064-28890-13-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the NFC and describe the NAND flash connected to this controller.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts |   31 ++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
index 8a1009d..031de97 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
@@ -19,6 +19,37 @@
 	compatible = "cubietech,cubietruck", "allwinner,sun7i-a20";
 
 	soc@01c00000 {
+		nfc: nand@01c03000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&nand_pins_a &nand_cs0_pins_a &nand_rb0_pins_a>;
+			status = "okay";
+
+			nand@0 {
+				#address-cells = <1>;
+				#size-cells = <1>;
+				reg = <0>;
+				allwinner,rb = <0>;
+				nand-ecc-mode = "soft_bch";
+
+				/* nand timings */
+				tCLS-min = <6>;
+				tCLH-min = <3>;
+				tCS-min = <20>;
+				tCH-min = <5>;
+				tWP-min = <8>;
+				tWH-min = <6>;
+				tALS-min = <6>;
+				tDS-min = <6>;
+				tDH-min = <2>;
+				tRR-min = <20>;
+				tALH-min = <3>;
+				tRP-min = <8>;
+				tREH-min = <6>;
+				tRC-min = <16>;
+				tWC-min = <16>;
+			};
+		};
+
 		pinctrl@01c20800 {
 			led_pins_cubietruck: led_pins@0 {
 				allwinner,pins = "PH7", "PH11", "PH20", "PH21";
-- 
1.7.9.5

