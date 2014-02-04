Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbaBDPZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:25:11 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:43887 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaBDPYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:24:15 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        devicetree@vger.kernel.org
Subject: [PATCH v3 09/11] ARM: shmobile: r8a7791 dtsi: Add QSPI node
Date: Tue,  4 Feb 2014 16:24:03 +0100
Message-Id: <1391527445-14881-10-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391527445-14881-1-git-send-email-geert@linux-m68k.org>
References: <1391527445-14881-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: devicetree@vger.kernel.org
---
v3:
  - Rebased on top of renesas-devel-v3.14-rc1-20140204
v2:
  - No changes

 arch/arm/boot/dts/r8a7791.dtsi |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7791.dtsi b/arch/arm/boot/dts/r8a7791.dtsi
index d5cc3626dd60..240c4ece1f0c 100644
--- a/arch/arm/boot/dts/r8a7791.dtsi
+++ b/arch/arm/boot/dts/r8a7791.dtsi
@@ -710,4 +710,16 @@
 			clock-output-names = "scifa3", "scifa4", "scifa5";
 		};
 	};
+
+	spi: spi@e6b10000 {
+		compatible = "renesas,qspi-r8a7791", "renesas,qspi";
+		reg = <0 0xe6b10000 0 0x2c>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 184 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp9_clks R8A7791_CLK_QSPI_MOD>;
+		num-cs = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
 };
-- 
1.7.9.5

