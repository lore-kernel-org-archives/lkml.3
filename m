Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3GANX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:23:56 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:40896 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3GANXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:23:43 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>, jimwall@q.com,
        brian@crystalfontz.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv4 8/8] ARM: mxs: dt: cfa10036: make hogpins grabbed by respective drivers
Date: Mon,  1 Jul 2013 15:23:29 +0200
Message-Id: <1372685009-15564-9-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372685009-15564-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1372685009-15564-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/imx28-cfa10036.dts | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx28-cfa10036.dts b/arch/arm/boot/dts/imx28-cfa10036.dts
index 94c4476..1ec8c94 100644
--- a/arch/arm/boot/dts/imx28-cfa10036.dts
+++ b/arch/arm/boot/dts/imx28-cfa10036.dts
@@ -23,10 +23,7 @@
 	apb@80000000 {
 		apbh@80000000 {
 			pinctrl@80018000 {
-				pinctrl-names = "default";
-				pinctrl-0 = <&hog_pins_cfa10036>;
-
-				hog_pins_cfa10036: hog-10036@0 {
+				ssd1306_cfa10036: ssd1306-10036@0 {
 					reg = <0>;
 					fsl,pinmux-ids = <
 						0x2073 /* MX28_PAD_SSP0_D7__GPIO_2_7 */
@@ -83,6 +80,8 @@
 
 				ssd1306: oled@3c {
 					compatible = "solomon,ssd1306fb-i2c";
+					pinctrl-names = "default";
+					pinctrl-0 = <&ssd1306_cfa10036>;
 					reg = <0x3c>;
 					reset-gpios = <&gpio2 7 0>;
 					solomon,height = <32>;
-- 
1.8.1.2

