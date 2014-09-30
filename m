Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaI3QUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:20:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56839 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752647AbaI3QT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:19:57 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Peter Korsgaard <jacmet@sunsite.dk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 6/6] ARM: at91/dt: add ISI node
Date: Tue, 30 Sep 2014 18:19:47 +0200
Message-Id: <1412093987-30241-7-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412093987-30241-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1412093987-30241-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ISI (Image Sensor Interface) DT node.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9g45.dtsi | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index 790c890..5d8746a 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -804,6 +804,27 @@
 					};
 				};
 
+				isi {
+					pinctrl_isi: isi-0 {
+						atmel,pins = <AT91_PIOB 8 AT91_PERIPH_B AT91_PINCTRL_NONE /* D8 */
+							      AT91_PIOB 9 AT91_PERIPH_B AT91_PINCTRL_NONE /* D9 */
+							      AT91_PIOB 10 AT91_PERIPH_B AT91_PINCTRL_NONE /* D10 */
+							      AT91_PIOB 11 AT91_PERIPH_B AT91_PINCTRL_NONE /* D11 */
+							      AT91_PIOB 20 AT91_PERIPH_A AT91_PINCTRL_NONE /* D0 */
+							      AT91_PIOB 21 AT91_PERIPH_A AT91_PINCTRL_NONE /* D1 */
+							      AT91_PIOB 22 AT91_PERIPH_A AT91_PINCTRL_NONE /* D2 */
+							      AT91_PIOB 23 AT91_PERIPH_A AT91_PINCTRL_NONE /* D3 */
+							      AT91_PIOB 24 AT91_PERIPH_A AT91_PINCTRL_NONE /* D4 */
+							      AT91_PIOB 25 AT91_PERIPH_A AT91_PINCTRL_NONE /* D5 */
+							      AT91_PIOB 26 AT91_PERIPH_A AT91_PINCTRL_NONE /* D6 */
+							      AT91_PIOB 27 AT91_PERIPH_A AT91_PINCTRL_NONE /* D7 */
+							      AT91_PIOB 28 AT91_PERIPH_A AT91_PINCTRL_NONE /* PCK */
+							      AT91_PIOB 29 AT91_PERIPH_A AT91_PINCTRL_NONE /* VSYNC */
+							      AT91_PIOB 30 AT91_PERIPH_A AT91_PINCTRL_NONE /* HSYNC */
+							      AT91_PIOB 31 AT91_PERIPH_A AT91_PINCTRL_NONE /* MCK */>;
+					};
+				};
+
 				pioA: gpio@fffff200 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff200 0x200>;
@@ -1029,6 +1050,17 @@
 				};
 			};
 
+			isi@fffb4000 {
+				compatible = "atmel,at91sam9g45-isi";
+				reg = <0xfffb4000 0x4000>;
+				interrupts = <26 IRQ_TYPE_LEVEL_HIGH 5>;
+				clocks = <&isi_clk>;
+				clock-names = "isi_clk";
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_isi>;
+				status = "disabled";
+			};
+
 			pwm0: pwm@fffb8000 {
 				compatible = "atmel,at91sam9rl-pwm";
 				reg = <0xfffb8000 0x300>;
-- 
1.9.1

