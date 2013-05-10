Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3EJKaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:30:12 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:24765 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab3EJKaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:30:10 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: dts: request only spi cs-gpios used on sama5d3x cpu module
Date: Fri, 10 May 2013 12:30:07 +0200
Message-ID: <1368181807-15182-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@atmel.com>

Instead of requesting all available spi cs-gpios, request only the ones used on
the board, in our case on the cpu module.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/sama5d3.dtsi    | 10 ----------
 arch/arm/boot/dts/sama5d3xcm.dtsi |  4 ++++
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 2e643ea..dee5e2f 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -75,11 +75,6 @@
 				compatible = "atmel,at91sam9x5-spi";
 				reg = <0xf0004000 0x100>;
 				interrupts = <24 4 3>;
-				cs-gpios = <&pioD 13 0
-					    &pioD 14 0 /* conflicts with SCK0 and CANRX0 */
-					    &pioD 15 0 /* conflicts with CTS0 and CANTX0 */
-					    &pioD 16 0 /* conflicts with RTS0 and PWMFI3 */
-					   >;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
 				status = "disabled";
@@ -203,11 +198,6 @@
 				compatible = "atmel,at91sam9x5-spi";
 				reg = <0xf8008000 0x100>;
 				interrupts = <25 4 3>;
-				cs-gpios = <&pioC 25 0
-					    &pioC 26 0 /* conflitcs with TWD1 and ISI_D11 */
-					    &pioC 27 0 /* conflitcs with TWCK1 and ISI_D10 */
-					    &pioC 28 0 /* conflitcs with PWMFI0 and ISI_D9 */
-					   >;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
 				status = "disabled";
diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
index 1f8ed40..b336e77 100644
--- a/arch/arm/boot/dts/sama5d3xcm.dtsi
+++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
@@ -32,6 +32,10 @@
 
 	ahb {
 		apb {
+			spi0: spi@f0004000 {
+				cs-gpios = <&pioD 13 0>, <0>, <0>, <0>;
+			};
+
 			macb0: ethernet@f0028000 {
 				phy-mode = "rgmii";
 			};
-- 
1.8.0

