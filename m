Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab3KNSIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:08:17 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:3172 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999Ab3KNSIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:08:11 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Christian Daudt" <bcm@fixthebug.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>
cc: "Tim Kryger" <tim.kryger@linaro.org>,
        "Broadcom Kernel Feedback List" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "Device Tree List" <devicetree@vger.kernel.org>,
        "Linux Arm Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Linaro Patches" <patches@linaro.org>
Subject: [PATCH] ARM: dts: bcm28155-ap: Fix Card Detection GPIO
Date: Thu, 14 Nov 2013 10:07:30 -0800
Message-ID: <1384452450-26308-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
X-WSS-ID: 7E9BCED91SC8073253-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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


