Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaAGSyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:54:51 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:2591 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaAGSyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:54:41 -0500
X-IronPort-AV: E=Sophos;i="4.95,620,1384329600"; 
   d="scan'208";a="7861846"
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Arm Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [RESEND PATCH] ARM: dts: bcm28155-ap: Fix Card Detection GPIO
Date: Tue, 7 Jan 2014 10:53:41 -0800
Message-ID: <1389120821-12007-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The board schematic states that the "SD_CARD_DET_N gets pulled to GND
when card is inserted" so the polarity has been updated to active low.

Polarity is now specified with a GPIO define instead of a magic number.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 arch/arm/boot/dts/bcm28155-ap.dts | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
index 08e47c2..27dd110 100644
--- a/arch/arm/boot/dts/bcm28155-ap.dts
+++ b/arch/arm/boot/dts/bcm28155-ap.dts
@@ -13,6 +13,8 @@
 
 /dts-v1/;
 
+#include <dt-bindings/gpio/gpio.h>
+
 #include "bcm11351.dtsi"
 
 / {
@@ -40,7 +42,7 @@
 
 	sdio4: sdio@3f1b0000 {
 		max-frequency = <48000000>;
-		cd-gpios = <&gpio 14 0>;
+		cd-gpios = <&gpio 14 GPIO_ACTIVE_LOW>;
 		status = "okay";
 	};
 };
-- 
1.8.0.1

