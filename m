Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3LPPn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:43:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35555 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab3LPPnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:43:49 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 3/4] arm: dts: keystone-evm: add LEDs supports
Date: Mon, 16 Dec 2013 18:39:39 +0200
Message-ID: <1387211981-26045-4-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387211981-26045-1-git-send-email-grygorii.strashko@ti.com>
References: <1387211981-26045-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keystone EVMK2HX supports 4 debug LEDs controlled by GPIO lines as
following (active level is high);

DBG_D1 green gpio12
DBG_D1 red   gpio13
DBG_D1 blue  gpio14
DBG_D1 blue  gpio15

For more information see schematics:
 http://wfcache.advantech.com/www/support/TI-EVM/download/Schematics/PDF/K2H_K2EVM-HK_SCH_A102_Rev1_0.pdf

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm/boot/dts/k2hk-evm.dts |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/k2hk-evm.dts b/arch/arm/boot/dts/k2hk-evm.dts
index 15b3a95..07bf1e9 100644
--- a/arch/arm/boot/dts/k2hk-evm.dts
+++ b/arch/arm/boot/dts/k2hk-evm.dts
@@ -52,4 +52,27 @@
 			};
 		};
 	};
+
+	leds {
+		compatible = "gpio-leds";
+		debug1_1 {
+			label = "keystone:green:debug1";
+			gpios = <&gpio0 12 GPIO_ACTIVE_HIGH>; /* 12 */
+		};
+
+		debug1_2 {
+			label = "keystone:red:debug1";
+			gpios = <&gpio0 13 GPIO_ACTIVE_HIGH>; /* 13 */
+		};
+
+		debug2 {
+			label = "keystone:blue:debug2";
+			gpios = <&gpio0 14 GPIO_ACTIVE_HIGH>; /* 14 */
+		};
+
+		debug3 {
+			label = "keystone:blue:debug3";
+			gpios = <&gpio0 15 GPIO_ACTIVE_HIGH>; /* 15 */
+		};
+	};
 };
-- 
1.7.9.5

