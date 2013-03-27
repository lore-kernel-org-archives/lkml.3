Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3C0Hok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 03:44:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44035 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050Ab3C0Hnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 03:43:51 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <linux@arm.linux.org.uk>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 1/3] ARM: davinci: da850: Add LCDC DT entries
Date: Wed, 27 Mar 2013 13:13:57 +0530
Message-ID: <1364370239-18390-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364370239-18390-1-git-send-email-avinashphilip@ti.com>
References: <1364370239-18390-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add LCDC DT entries in da850 dts file.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/boot/dts/da850.dtsi |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index a6cbf89..087b4ea 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -62,6 +62,21 @@
 					0x10 0x00002200 0x0000ff00
 				>;
 			};
+			lcdc_pins:pinmux_lcdc_pins {
+				pinctrl-single,bits = <
+					/* LCD_D[2], LCD_D[3], LCD_D[4],
+					   LCD_D[5], LCD_D[6], LCD_D[7] */
+					0x40 0x22222200 0xffffff00
+					/* LCD_D[10], LCD_D[11], LCD_D[12],
+					   LCD_D[13], LCD_D[14], LCD_D[15],
+					   LCD_D[0], LCD_D[1] */
+					0x44 0x22222222 0xffffffff
+					/* LCD_PCLK, LCD_D[8], LCD_D[9] */
+					0x48 0x02000022 0x0f0000ff
+					/* LCD_AC_ENB_CS, LCD_VSYNC, LCD_HSYNC*/
+					0x4c 0x02000022 0x0f0000ff
+				>;
+			};
 		};
 		serial0: serial@1c42000 {
 			compatible = "ns16550a";
@@ -137,6 +152,12 @@
 			reg = <0x308000 0x80>;
 			status = "disabled";
 		};
+		lcdc: lcdc@01e13000 {
+			compatible = "ti,da830-lcdc";
+			reg = <0x213000 0x1000>;
+			interrupts = <52>;
+			status = "disabled";
+		};
 	};
 	nand_cs3@62000000 {
 		compatible = "ti,davinci-nand";
-- 
1.7.9.5

