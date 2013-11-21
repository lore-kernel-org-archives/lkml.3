Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3KUSQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:16:42 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62820 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab3KUSQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:16:36 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v6 6/6] ARM: davinci: da850 evm: add GPIO pinumux entries DT node
Date: Thu, 21 Nov 2013 23:45:31 +0530
Message-Id: <1385057731-4348-7-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>
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

