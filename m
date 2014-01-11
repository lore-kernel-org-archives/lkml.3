Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaAKTo1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 14:44:27 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:40529 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbaAKTn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 14:43:27 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH RFC 09/10] ARM: dts: s3c64xx: Add node for display controller
Date: Sat, 11 Jan 2014 20:42:51 +0100
Message-Id: <1389469372-17199-10-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree node for the display controller present on
S3C64xx SoCs.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/boot/dts/s3c64xx.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/s3c64xx.dtsi b/arch/arm/boot/dts/s3c64xx.dtsi
index 4e3be4d..6fe1042 100644
--- a/arch/arm/boot/dts/s3c64xx.dtsi
+++ b/arch/arm/boot/dts/s3c64xx.dtsi
@@ -18,6 +18,7 @@
 
 #include "skeleton.dtsi"
 #include <dt-bindings/clock/samsung,s3c64xx-clock.h>
+#include <dt-bindings/arm/s3c64xx-power-domains.h>
 
 / {
 	aliases {
@@ -56,6 +57,18 @@
 			#interrupt-cells = <1>;
 		};
 
+		fimd: display@77100000 {
+			compatible = "samsung,s3c6400-fimd";
+			reg = <0x77100000 0x1000>;
+			interrupt-parent = <&vic0>;
+			interrupts = <29>, <30>, <31>;
+			interrupt-names = "fifo", "vsync", "lcd_sys";
+			clocks = <&clocks HCLK_LCD>, <&clocks SCLK_LCD>;
+			clock-names = "fimd", "sclk_fimd";
+			power-domain = <&clocks DOMAIN_F>;
+			status = "disabled";
+		};
+
 		sdhci0: sdhci@7c200000 {
 			compatible = "samsung,s3c6410-sdhci";
 			reg = <0x7c200000 0x100>;
-- 
1.8.5.2

