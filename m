Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbaFKJLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:11:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56290 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbaFKI57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:57:59 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 12/36] ARM: dts: omap3-beagle: Add NAND device
Date: Wed, 11 Jun 2014 11:56:17 +0300
Message-ID: <1402477001-31132-13-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The beagle board contains a 16-bit NAND device connected to
chip select 0 of the GPMC controller.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap3-beagle.dts | 53 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index 3c3e6da..fafd229 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -350,3 +350,56 @@
 		};
 	};
 };
+
+&gpmc {
+	ranges = <0 0 0x30000000 0x1000000	/* CS0 space, 16MB */
+		  255 0 0x6e000000 0x02d4>;	/* register space */
+
+	/* Chip select 0 */
+	nand@0,0 {
+		compatible = "ti,omap2-nand";
+		reg = <0 0 4		/* NAND I/O window, 4 bytes */
+		       255 0 0x02d4>;	/* GPMC register space */
+		interrupts = <20>;
+		ti,nand-ecc-opt = "ham1";
+		nand-bus-width = <16>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		gpmc,cs-on-ns = <0>;
+		gpmc,cs-rd-off-ns = <36>;
+		gpmc,cs-wr-off-ns = <36>;
+		gpmc,adv-on-ns = <6>;
+		gpmc,adv-rd-off-ns = <24>;
+		gpmc,adv-wr-off-ns = <36>;
+		gpmc,oe-on-ns = <6>;
+		gpmc,oe-off-ns = <48>;
+		gpmc,we-on-ns = <6>;
+		gpmc,we-off-ns = <30>;
+		gpmc,rd-cycle-ns = <72>;
+		gpmc,wr-cycle-ns = <72>;
+		gpmc,access-ns = <54>;
+		gpmc,wr-access-ns = <30>;
+
+		partition@0 {
+			label = "X-Loader";
+			reg = <0 0x80000>;
+		};
+		partition@80000 {
+			label = "U-Boot";
+			reg = <0x80000 0x1e0000>;
+		};
+		partition@1c0000 {
+			label = "U-Boot Env";
+			reg = <0x260000 0x20000>;
+		};
+		partition@280000 {
+			label = "Kernel";
+			reg = <0x280000 0x400000>;
+		};
+		partition@780000 {
+			label = "Filesystem";
+			reg = <0x680000 0xf980000>;
+		};
+	};
+};
-- 
1.8.3.2

