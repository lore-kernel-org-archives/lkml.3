Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab3BPLit (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 06:38:49 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:34948 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3BPLir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 06:38:47 -0500
From: Anil Kumar <anilk4.v@gmail.com>
To: devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, b-cousson@ti.com, tony@atomide.com,
        grant.likely@secretlab.ca, zonque@gmail.com, thomas@tomweber.eu,
        anilk4.v@gmail.com
Subject: [PATCH 2/2] ARM: dts: omap3-devkit8000: add nand dt node
Date: Sat, 16 Feb 2013 17:08:28 +0530
Message-Id: <1361014708-1659-3-git-send-email-anilk4.v@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1361014708-1659-1-git-send-email-anilk4.v@gmail.com>
References: <1361014708-1659-1-git-send-email-anilk4.v@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the needed sections to enable nand support on
Devkit8000.

Add nand partitions information.

Signed-off-by: Anil Kumar <anilk4.v@gmail.com>
---
:100644 100644 6338993... 6c6decf... M	arch/arm/boot/dts/omap3-devkit8000.dts
 arch/arm/boot/dts/omap3-devkit8000.dts |   52 ++++++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-devkit8000.dts b/arch/arm/boot/dts/omap3-devkit8000.dts
index 6338993..6c6decf 100644
--- a/arch/arm/boot/dts/omap3-devkit8000.dts
+++ b/arch/arm/boot/dts/omap3-devkit8000.dts
@@ -101,3 +101,55 @@
 &mcbsp5 {
 	status = "disabled";
 };
+
+&gpmc {
+	ranges = <0 0 0x30000000 0x04>;       /* CS0: NAND */
+
+	nand@0,0 {
+		reg = <0 0 0>; /* CS0, offset 0 */
+		nand-bus-width = <16>;
+
+		gpmc,sync-clk = <0>;
+		gpmc,cs-on = <0>;
+		gpmc,cs-rd-off = <44>;
+		gpmc,cs-wr-off = <44>;
+		gpmc,adv-on = <6>;
+		gpmc,adv-rd-off = <34>;
+		gpmc,adv-wr-off = <44>;
+		gpmc,we-off = <40>;
+		gpmc,oe-off = <54>;
+		gpmc,access = <64>;
+		gpmc,rd-cycle = <82>;
+		gpmc,wr-cycle = <82>;
+		gpmc,wr-access = <40>;
+		gpmc,wr-data-mux-bus = <0>;
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
1.7.0.4

