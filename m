Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762592Ab3DCGE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:04:59 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:14411 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762204Ab3DCGE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:04:58 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <grant.likely@secretlab.ca>, <broonie@opensource.wolfsonmicro.com>,
        <richard.genoud@gmail.com>, <plagnioj@jcrosoft.com>,
        <nicolas.ferre@atmel.com>, <JM.Lin@atmel.com>, <wenyou.yang@atmel.com>,
        <spi-devel-general@lists.sourceforge.net>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 7/8] ARM: dts: add spi nodes for the atmel boards
Date: Wed, 3 Apr 2013 14:03:05 +0800
Message-ID: <1364968986-24236-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364968581-23700-1-git-send-email-wenyou.yang@atmel.com>
References: <1364968581-23700-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
[wenyou.yang@atmel.com: added spi nodes for the sam9263ek, sam9g20ek, sam9m10g45ek and sam9n12ek boards]
[wenyou.yang@atmel.com: submit the patch]
Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/at91sam9263ek.dts         |   10 ++++++++++
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi |   10 ++++++++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts      |   10 ++++++++++
 arch/arm/boot/dts/at91sam9n12ek.dts         |   10 ++++++++++
 arch/arm/boot/dts/at91sam9x5ek.dtsi         |   10 ++++++++++
 5 files changed, 50 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9263ek.dts b/arch/arm/boot/dts/at91sam9263ek.dts
index 1eb0872..a14e424 100644
--- a/arch/arm/boot/dts/at91sam9263ek.dts
+++ b/arch/arm/boot/dts/at91sam9263ek.dts
@@ -79,6 +79,16 @@
 					};
 				};
 			};
+
+			spi0: spi@fffa4000 {
+				status = "okay";
+				cs-gpios = <&pioA 5 0>, <0>, <0>, <0>;
+				mtd_dataflash@0 {
+					compatible = "atmel,at45", "atmel,dataflash";
+					spi-max-frequency = <50000000>;
+					reg = <0>;
+				};
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
index da15e83..23d1f46 100644
--- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
@@ -96,6 +96,16 @@
 				status = "okay";
 				pinctrl-0 = <&pinctrl_ssc0_tx>;
 			};
+
+			spi0: spi@fffc8000 {
+				status = "okay";
+				cs-gpios = <0>, <&pioC 11 0>, <0>, <0>;
+				mtd_dataflash@0 {
+					compatible = "atmel,at45", "atmel,dataflash";
+					spi-max-frequency = <50000000>;
+					reg = <1>;
+				};
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
index 20c3191..92c52a7 100644
--- a/arch/arm/boot/dts/at91sam9m10g45ek.dts
+++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
@@ -102,6 +102,16 @@
 					};
 				};
 			};
+
+			spi0: spi@fffa4000{
+				status = "okay";
+				cs-gpios = <&pioB 3 0>, <0>, <0>, <0>;
+				mtd_dataflash@0 {
+					compatible = "atmel,at45", "atmel,dataflash";
+					spi-max-frequency = <13000000>;
+					reg = <0>;
+				};
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
index d400f8d..34c842b 100644
--- a/arch/arm/boot/dts/at91sam9n12ek.dts
+++ b/arch/arm/boot/dts/at91sam9n12ek.dts
@@ -67,6 +67,16 @@
 					};
 				};
 			};
+
+			spi0: spi@f0000000 {
+				status = "okay";
+				cs-gpios = <&pioA 14 0>, <0>, <0>, <0>;
+				m25p80@0 {
+					compatible = "atmel,at25df321a";
+					spi-max-frequency = <50000000>;
+					reg = <0>;
+				};
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
index 8a7cf1d..09f5e66 100644
--- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
@@ -84,6 +84,16 @@
 					};
 				};
 			};
+
+			spi0: spi@f0000000 {
+				status = "okay";
+				cs-gpios = <&pioA 14 0>, <0>, <0>, <0>;
+				m25p80@0 {
+					compatible = "atmel,at25df321a";
+					spi-max-frequency = <50000000>;
+					reg = <0>;
+				};
+			};
 		};
 
 		usb0: ohci@00600000 {
-- 
1.7.9.5

