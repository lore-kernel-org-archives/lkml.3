Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaDYXD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 19:03:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48399 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaDYXDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 19:03:19 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 10/10] ARM: dts: OMAP4: Add clock nodes for AES/DES nodes
Date: Fri, 25 Apr 2014 18:02:48 -0500
Message-ID: <1398466968-29506-11-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398466968-29506-1-git-send-email-joelf@ti.com>
References: <1398466968-29506-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AES/DES nodes have clock nodes in the clock tree, use them. Internal trees were
using hwmod, but now that clock nodes are there, we can use them instead and
upstream it.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 27fcac8..f19ffa8 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -806,6 +806,8 @@
 			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
 			dmas = <&sdma 111>, <&sdma 110>;
 			dma-names = "tx", "rx";
+			clocks = <&aes1_fck>;
+			clock-names = "fck";
 		};
 
 		des: des@480a5000 {
@@ -815,6 +817,8 @@
 			interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
 			dmas = <&sdma 117>, <&sdma 116>;
 			dma-names = "tx", "rx";
+			clocks = <&des_fck>;
+			clock-names = "fck";
 		};
 
 		abb_mpu: regulator-abb-mpu {
-- 
1.7.9.5

