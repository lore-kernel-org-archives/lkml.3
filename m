Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbaJVJip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:38:45 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:42026 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbaJVJij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:38:39 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/3] ARM: shmobile: r8a7740 dtsi: Add TMU0 and TMU1 device nodes
Date: Wed, 22 Oct 2014 11:38:28 +0200
Message-Id: <1413970709-26607-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413970709-26607-1-git-send-email-geert+renesas@glider.be>
References: <1413970709-26607-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/boot/dts/r8a7740.dtsi | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
index 559bd39e778bddaf..aec8da89ef9ac766 100644
--- a/arch/arm/boot/dts/r8a7740.dtsi
+++ b/arch/arm/boot/dts/r8a7740.dtsi
@@ -335,6 +335,34 @@
 		status = "disabled";
 	};
 
+	tmu0: timer@fff80000 {
+		compatible = "renesas,tmu-r8a7740", "renesas,tmu";
+		reg = <0xfff80000 0x2c>;
+		interrupts = <0 198 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 199 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 200 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp1_clks R8A7740_CLK_TMU0>;
+		clock-names = "fck";
+
+		#renesas,channels = <3>;
+
+		status = "disabled";
+	};
+
+	tmu1: timer@fff90000 {
+		compatible = "renesas,tmu-r8a7740", "renesas,tmu";
+		reg = <0xfff90000 0x2c>;
+		interrupts = <0 170 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 171 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 172 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp1_clks R8A7740_CLK_TMU1>;
+		clock-names = "fck";
+
+		#renesas,channels = <3>;
+
+		status = "disabled";
+	};
+
 	clocks {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.9.1

