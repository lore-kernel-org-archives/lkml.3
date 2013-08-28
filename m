Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3H1Mjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:39:40 -0400
Received: from 7.mo3.mail-out.ovh.net ([46.105.57.200]:46840 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753130Ab3H1Mjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:39:39 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [PATCH 9/9] ARM: at91/dt: add new at91rm9200ek_dataflash board
Date: Wed, 28 Aug 2013 14:38:55 +0200
Message-Id: <1377693535-11171-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 17248786573035403488
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new at91rm9200ek_dataflash board (based on at91rm9200ek board) which
enables dataflash connected to cs3 of spi0.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91rm9200ek_dataflash.dts |   33 ++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 arch/arm/boot/dts/at91rm9200ek_dataflash.dts

diff --git a/arch/arm/boot/dts/at91rm9200ek_dataflash.dts b/arch/arm/boot/dts/at91rm9200ek_dataflash.dts
new file mode 100644
index 0000000..a43412e
--- /dev/null
+++ b/arch/arm/boot/dts/at91rm9200ek_dataflash.dts
@@ -0,0 +1,33 @@
+/*
+ * at91rm9200ek.dts - Device Tree file for Atmel AT91RM9200 evaluation kit with
+ *                    2 SPI dataflash
+ *
+ *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Licensed under GPLv2 only
+ */
+/dts-v1/;
+#include "at91rm9200ek.dts"
+
+/ {
+	model = "Atmel AT91RM9200 evaluation kit with 2 SPI dataflash";
+	compatible = "atmel,at91rm9200ek-dataflash", "atmel,at91rm9200ek", "atmel,at91rm9200";
+
+	ahb {
+		apb {
+			spi0: spi@fffe0000 {
+				pinctrl-0 = <&pinctrl_spi0 &pinctrl_spi0_cs0
+					     &pinctrl_spi0_cs3
+					     &pinctrl_spi0_cs3_switch>;
+				cs-gpios = <&pioA 3 GPIO_ACTIVE_HIGH>, <0>,
+					   <0>, <&pioA 6 GPIO_ACTIVE_HIGH>;
+
+				mtd_dataflash@3 {
+					compatible = "atmel,at45", "atmel,dataflash";
+					spi-max-frequency = <15000000>;
+					reg = <3>;
+				};
+			};
+		};
+	};
+};
-- 
1.7.9.5

