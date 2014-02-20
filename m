Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbaBTO5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:57:35 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:40439 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbaBTO5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:57:31 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>
Cc: linux-spi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2 2/2] ARM: shmobile: bockw reference dts: Add SPI FLASH
Date: Thu, 20 Feb 2014 15:57:19 +0100
Message-Id: <1392908239-22645-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392908239-22645-1-git-send-email-geert@linux-m68k.org>
References: <1392908239-22645-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Add Spansion s25fl008k SPI FLASH and MTD partition, based on bockw legacy
board code.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Tested-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---
v2:
  - Add Tested-by

 arch/arm/boot/dts/r8a7778-bockw-reference.dts |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7778-bockw-reference.dts b/arch/arm/boot/dts/r8a7778-bockw-reference.dts
index 06cda19dac6a..f76f6ec01e19 100644
--- a/arch/arm/boot/dts/r8a7778-bockw-reference.dts
+++ b/arch/arm/boot/dts/r8a7778-bockw-reference.dts
@@ -109,4 +109,18 @@
 	pinctrl-0 = <&hspi0_pins>;
 	pinctrl-names = "default";
 	status = "okay";
+
+	flash: flash@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "spansion,s25fl008k";
+		reg = <0>;
+		spi-max-frequency = <104000000>;
+		m25p,fast-read;
+
+		partition@0 {
+			label = "data(spi)";
+			reg = <0x00000000 0x00100000>;
+		};
+	};
 };
-- 
1.7.9.5

