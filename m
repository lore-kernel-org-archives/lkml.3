Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3G2McL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:32:11 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:47742 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab3G2McG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:32:06 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ARM: dove: add MBus DT node
Date: Mon, 29 Jul 2013 14:31:52 +0200
Message-Id: <1375101114-28858-4-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a MBus node including ranges and pcie apertures required later.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove.dtsi |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 397674c..bdda016 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -29,6 +29,20 @@
 		marvell,tauros2-cache-features = <0>;
 	};
 
+	mbus {
+		compatible = "marvell,dove-mbus", "marvell,mbus", "simple-bus";
+		#address-cells = <2>;
+		#size-cells = <1>;
+		pcie-mem-aperture = <0xe0000000 0x10000000>; /* 256M MEM space */
+		pcie-io-aperture  = <0xf2000000 0x00200000>; /*   2M I/O space */
+
+		ranges = <MBUS_ID(0xf0, 0x01) 0 0xf1000000 0x0100000   /* MBUS regs  1M */
+			  MBUS_ID(0xf0, 0x02) 0 0xf1800000 0x1000000   /* AXI  regs 16M */
+			  MBUS_ID(0x01, 0xfd) 0 0xf8000000 0x8000000   /* BootROM  128M */
+			  MBUS_ID(0x03, 0x01) 0 0xc8000000 0x0100000   /* CESA SRAM  1M */
+			  MBUS_ID(0x0d, 0x00) 0 0xf0000000 0x0100000>; /* PMU  SRAM  1M */
+	};
+
 	soc@f1000000 {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -44,6 +58,11 @@
 		          0xf2100000 0xf2100000 0x0100000   /* PCIe0 I/O   1M */
 		          0xf8000000 0xf8000000 0x8000000>; /* BootROM   128M */
 
+		mbusc: mbus-ctrl@20000 {
+			compatible = "marvell,mbus-controller";
+			reg = <0x20000 0x80>, <0x800100 0x8>;
+		};
+
 		timer: timer@20300 {
 			compatible = "marvell,orion-timer";
 			reg = <0x20300 0x20>;
-- 
1.7.10.4

