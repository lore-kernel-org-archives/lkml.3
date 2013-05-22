Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab3EVHMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:12:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36950 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab3EVHMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:12:52 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, KV Sujith <sujithkv@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 11/11] ARM: davinci: da850 evm: add GPIO DT data
Date: Wed, 22 May 2013 12:40:34 +0530
Message-ID: <1369206634-6778-12-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KV Sujith <sujithkv@ti.com>

- Add GPIO DT Data and pinmux for DA850 EVM. GPIO is configurable differently
  on different boards. So add GPIO pinmuxing in dts file.
- Dependency: This patch is dependent on Grab-pin-control patch;
  https://patchwork.kernel.org/patch/2013751/

Signed-off-by: KV Sujith <sujithkv@ti.com>
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/boot/dts/da850-evm.dts |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index c914357..ab59e60 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -17,6 +17,20 @@
 	soc {
 		pmx_core: pinmux@1c14120 {
 			status = "okay";
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
@@ -90,6 +104,11 @@
 				};
 			};
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

