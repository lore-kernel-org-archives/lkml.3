Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaEGUcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:32:43 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:43385 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaEGUcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:32:41 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Bastian Hecht <hechtb+renesas@gmail.com>, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/3] ARM: shmobile: r8a7740 dtsi: Add Ethernet support
Date: Wed,  7 May 2014 22:32:29 +0200
Message-Id: <1399494750-31996-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399494750-31996-1-git-send-email-geert+renesas@glider.be>
References: <1399494750-31996-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
The "clocks" entry should be uncommented after the conversion to CCF is
integrated.

 arch/arm/boot/dts/r8a7740.dtsi |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
index 3834b94dc02a..560d8d71cea4 100644
--- a/arch/arm/boot/dts/r8a7740.dtsi
+++ b/arch/arm/boot/dts/r8a7740.dtsi
@@ -122,6 +122,19 @@
 			      0 149 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
+	ether: ethernet@e9a00000 {
+		compatible = "renesas,gether-r8a7740";
+		reg = <0xe9a00000 0x800>,
+		      <0xe9a01800 0x800>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 110 IRQ_TYPE_LEVEL_HIGH>;
+		/* clocks = <&mstp3_clks R8A7740_CLK_GETHER>; */
+		phy-mode = "mii";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
 	i2c0: i2c@fff20000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
1.7.9.5

