Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaDYXDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 19:03:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40142 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaDYXDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 19:03:20 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 07/10] ARM: dts: DRA7: Add DT node for DES IP
Date: Fri, 25 Apr 2014 18:02:45 -0500
Message-ID: <1398466968-29506-8-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398466968-29506-1-git-send-email-joelf@ti.com>
References: <1398466968-29506-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRA7xx SoCs have a DES3DES IP. Add DT data for the same.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 1c0f8e1..0533b89 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -789,6 +789,17 @@
 			dma-names = "tx0", "rx0";
 			status = "disabled";
 		};
+
+		des: des@480a5000 {
+			compatible = "ti,omap4-des";
+			ti,hwmods = "des";
+			reg = <0x480a5000 0xa0>;
+			interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
+			dmas = <&sdma 117>, <&sdma 116>;
+			dma-names = "tx", "rx";
+			clocks = <&l3_iclk_div>;
+			clock-names = "fck";
+		};
 	};
 };
 
-- 
1.7.9.5

