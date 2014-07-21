Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaGUVF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:05:58 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56798 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaGUVFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:05:55 -0400
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH 1/7] arm: dts: omap3-gta04: Add nand support
Date: Mon, 21 Jul 2014 23:05:21 +0200
Message-Id: <1405976727-15166-2-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405976727-15166-1-git-send-email-marek@goldelico.com>
References: <1405976727-15166-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dts | 54 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
index 021311f..7d7ddd7 100644
--- a/arch/arm/boot/dts/omap3-gta04.dts
+++ b/arch/arm/boot/dts/omap3-gta04.dts
@@ -309,3 +309,57 @@
 		};
 	};
 };
+
+&gpmc {
+	ranges = <0 0 0x30000000 0x04>; /* CS0: NAND */
+
+	nand@0,0 {
+		reg = <0 0 0>; /* CS0, offset 0 */
+		nand-bus-width = <16>;
+		ti,nand-ecc-opt = "bch8";
+
+		gpmc,sync-clk-ps = <0>;
+		gpmc,cs-on-ns = <0>;
+		gpmc,cs-rd-off-ns = <44>;
+		gpmc,cs-wr-off-ns = <44>;
+		gpmc,adv-on-ns = <6>;
+		gpmc,adv-rd-off-ns = <34>;
+		gpmc,adv-wr-off-ns = <44>;
+		gpmc,we-off-ns = <40>;
+		gpmc,oe-off-ns = <54>;
+		gpmc,access-ns = <64>;
+		gpmc,rd-cycle-ns = <82>;
+		gpmc,wr-cycle-ns = <82>;
+		gpmc,wr-access-ns = <40>;
+		gpmc,wr-data-mux-bus-ns = <0>;
+		gpmc,device-width = <2>;
+
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		x-loader@0 {
+			label = "X-Loader";
+			reg = <0 0x80000>;
+		};
+
+		bootloaders@80000 {
+			label = "U-Boot";
+			reg = <0x80000 0x1e0000>;
+		};
+
+		bootloaders_env@260000 {
+			label = "U-Boot Env";
+			reg = <0x260000 0x20000>;
+		};
+
+		kernel@280000 {
+			label = "Kernel";
+			reg = <0x280000 0x400000>;
+		};
+
+		filesystem@680000 {
+			label = "File System";
+			reg = <0x680000 0xf980000>;
+		};
+	};
+};
-- 
1.9.1

