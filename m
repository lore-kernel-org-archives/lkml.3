Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab3LUPMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 10:12:33 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:48957 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab3LUPMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 10:12:30 -0500
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH] ARM: dts: omap3-gta04: Add EOC irq gpio line handling.
Date: Sat, 21 Dec 2013 16:12:23 +0100
Message-Id: <1387638743-12278-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BMP085 EOC (End Of Conversion) irq line is connected to
gpio113 on gta04. Set irq properties to have driver using irq
instead polling for EOC.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
index b9b55c9..7a8e37d 100644
--- a/arch/arm/boot/dts/omap3-gta04.dts
+++ b/arch/arm/boot/dts/omap3-gta04.dts
@@ -92,6 +92,8 @@
 	bmp085@77 {
 		compatible = "bosch,bmp085";
 		reg = <0x77>;
+		interrupt-parent = <&gpio4>;
+		interrupts = <17 IRQ_TYPE_EDGE_RISING>;
 	};
 
 	/* leds */
-- 
1.8.4.2

