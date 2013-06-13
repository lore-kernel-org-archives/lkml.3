Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab3FMNpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:45:10 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50140 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab3FMNnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:43:55 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Lilly <brian@crystalfontz.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/4] ARM: cfa10049: Switch the chip select pin of the LCD controller
Date: Thu, 13 Jun 2013 15:43:43 +0200
Message-Id: <1371131025-12200-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371131025-12200-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1371131025-12200-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Lilly <brian@crystalfontz.com>

The early prototypes had the chip select pin for the LCD controller
wired on the GPIO 3-23, while the production run of the CFA-10049 have
this chip select on the GPIO 3-5.

Signed-off-by: Brian Lilly <brian@crystalfontz.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/imx28-cfa10049.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx28-cfa10049.dts b/arch/arm/boot/dts/imx28-cfa10049.dts
index 063e620..fa91af5 100644
--- a/arch/arm/boot/dts/imx28-cfa10049.dts
+++ b/arch/arm/boot/dts/imx28-cfa10049.dts
@@ -33,7 +33,7 @@
 						0x1163 /* MX28_PAD_LCD_D22__GPIO_1_22 */
 						0x1173 /* MX28_PAD_LCD_D22__GPIO_1_23 */
 						0x2153 /* MX28_PAD_SSP2_D5__GPIO_2_21 */
-						0x3173 /* MX28_PAD_LCD_RESET__GPIO_3_23 */
+						0x3053 /* MX28_PAD_AUART1_TX__GPIO_3_5 */
 					>;
 					fsl,drive-strength = <0>;
 					fsl,voltage = <1>;
@@ -265,7 +265,7 @@
 		gpio-sck = <&gpio2 16 0>;
 		gpio-mosi = <&gpio2 17 0>;
 		gpio-miso = <&gpio2 18 0>;
-		cs-gpios = <&gpio3 23 0>;
+		cs-gpios = <&gpio3 5 0>;
 		num-chipselects = <1>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
1.8.3

