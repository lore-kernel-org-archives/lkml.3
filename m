Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3KBPlQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 11:41:16 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52814 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab3KBPks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 11:40:48 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Alex Elder <alex.elder@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-gpio@vger.kernel.org, Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v4 6/6] ARM: davinci: da850 evm: add GPIO pinumux entries DT node
Date: Sat,  2 Nov 2013 21:09:35 +0530
Message-Id: <1383406775-14902-7-git-send-email-prabhakar.csenng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383406775-14902-1-git-send-email-prabhakar.csenng@gmail.com>
References: <1383406775-14902-1-git-send-email-prabhakar.csenng@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KV Sujith <sujithkv@ti.com>

Add GPIO DT node and pinmux entries for DA850 EVM. GPIO is
configurable differently on different boards. So add GPIO
pinmuxing in dts file.

Signed-off-by: KV Sujith <sujithkv@ti.com>
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/boot/dts/da850-evm.dts |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index 588ce58..f82c129 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -17,6 +17,21 @@
 	soc {
 		pmx_core: pinmux@1c14120 {
 			status = "okay";
+
+			gpio_pins: pinmux_gpio_pins {
+				pinctrl-single,bits = <
+					/* GPIO2_4 GPIO2_6 */
+					0x18 0x00008080 0x0000f0f0
+					/* GPIO2_8 GPIO2_15 */
+					0x14 0x80000008 0xf000000f
+					/* GPIO3_12 GPIO3_13 */
+					0x1C 0x00008800 0x0000ff00
+					/* GPIO4_0 GPIO4_1 */
+					0x28 0x88000000 0xff000000
+					/* GPIO6_9 GPIO6_10 GPIO6_13 */
+					0x34 0x08800800 0x0ff00f00
+				>;
+			};
 		};
 		serial0: serial@1c42000 {
 			status = "okay";
@@ -101,6 +116,11 @@
 			pinctrl-names = "default";
 			pinctrl-0 = <&mii_pins>;
 		};
+		gpio: gpio@1e26000 {
+			status = "okay";
+			pinctrl-names = "default";
+			pinctrl-0 = <&gpio_pins>;
+		};
 	};
 	nand_cs3@62000000 {
 		status = "okay";
-- 
1.7.9.5

