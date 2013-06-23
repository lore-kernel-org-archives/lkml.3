Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3FWPAn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 11:00:43 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:43360 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3FWPAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 11:00:39 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        devicetree-discuss@lists.ozlabs.org, Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Heiko Schocher <hs@denx.de>
Subject: [PATCH v3 2/6] ARM: davinci: da850: add DT node for mdio device
Date: Sun, 23 Jun 2013 20:30:03 +0530
Message-Id: <1371999607-6483-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371999607-6483-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1371999607-6483-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Add mdio device tree node information to da850 by
providing register details and bus frequency of mdio.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
Cc: netdev@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Heiko Schocher <hs@denx.de>
---
 Changes for v2: none
 Changes for v3:
  a> Added pin entries for mdio.
 
 arch/arm/boot/dts/da850-evm.dts |    6 ++++++
 arch/arm/boot/dts/da850.dtsi    |   13 +++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index c914357..661219e 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -90,6 +90,12 @@
 				};
 			};
 		};
+		mdio: mdio@1e24000 {
+			status = "okay";
+			pinctrl-names = "default";
+			pinctrl-0 = <&mdio_pins>;
+			bus_freq = <2200000>;
+		};
 	};
 	nand_cs3@62000000 {
 		status = "okay";
diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 4660693..bcef5a9 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -125,6 +125,13 @@
 					0x14 0x00000010 0x000000f0
 				>;
 			};
+			mdio_pins: pinmux_mdio_pins {
+				pinctrl-single,bits = <
+					/* MDIO_CLK, MDIO_D */
+					0x10 0x00000088 0x000000ff
+				>;
+			};
+
 		};
 		serial0: serial@1c42000 {
 			compatible = "ns16550a";
@@ -216,6 +223,12 @@
 			interrupts = <56>;
 			status = "disabled";
 		};
+		mdio: mdio@1e24000 {
+			compatible = "ti,davinci_mdio";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x224000 0x1000>;
+		};
 	};
 	nand_cs3@62000000 {
 		compatible = "ti,davinci-nand";
-- 
1.7.9.5

