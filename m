Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaIVRL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:11:56 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:58163 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbaIVRJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:09:41 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, linus.walleij@linaro.org,
        gnurou@gmail.com
Cc: linux@arm.linux.org.uk, jingchang.lu@freescale.com, b20788@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 3/9] ARM: dts: vf610: add on-chip SRAM
Date: Mon, 22 Sep 2014 19:09:24 +0200
Message-Id: <593e881b5050795076426a4071bfa1bff66cb215.1411404079.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
In-Reply-To: <cover.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf610.dtsi | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 67bb3b7..d2128e5 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -69,6 +69,27 @@
 		interrupt-parent = <&intc>;
 		ranges;
 
+		ocram0: sram@3f000000 {
+			compatible = "mmio-sram";
+			reg = <0x3f000000 0x40000>;
+		};
+
+		ocram1: sram@3f040000 {
+			compatible = "mmio-sram";
+			reg = <0x3f040000 0x40000>;
+		};
+
+		gfxram0: sram@3f400000 {
+			compatible = "mmio-sram";
+			reg = <0x3f400000 0x80000>;
+		};
+
+		/* used by L2 cache */
+		gfxram1: sram@3f480000 {
+			compatible = "mmio-sram";
+			reg = <0x3f480000 0x80000>;
+		};
+
 		aips0: aips-bus@40000000 {
 			compatible = "fsl,aips-bus", "simple-bus";
 			#address-cells = <1>;
-- 
2.1.0

