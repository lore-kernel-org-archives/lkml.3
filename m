Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaA2Ogh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:36:37 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:51885 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaA2Oeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:34:50 -0500
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
Subject: [RFC PATCH v2 10/14] ARM: dt/sunxi: add NFC node to Allwinner A20 SoC
Date: Wed, 29 Jan 2014 15:34:20 +0100
Message-Id: <1391006064-28890-11-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add NAND Flash controller node definition to the A20 SoC.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 8e4cdcc..3b47253 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -299,6 +299,17 @@
 		#size-cells = <1>;
 		ranges;
 
+		nfc: nand@01c03000 {
+			compatible = "allwinner,sun4i-nand";
+			reg = <0x01c03000 0x1000>;
+			interrupts = <0 37 1>;
+			clocks = <&ahb_gates 13>, <&nand_clk>;
+			clock-names = "ahb_clk", "sclk";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+		};
+
 		emac: ethernet@01c0b000 {
 			compatible = "allwinner,sun4i-emac";
 			reg = <0x01c0b000 0x1000>;
-- 
1.7.9.5

