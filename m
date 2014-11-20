Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbaKTJoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:44:25 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:38972 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbaKTJoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:44:21 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <mpm@selenic.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <peter@korsgaard.com>
Subject: [PATCH RESEND v2 4/4] ARM: at91/dt: add trng node to at91sam9g45
Date: Thu, 20 Nov 2014 10:43:25 +0100
Message-ID: <575b40c1f59408602161bb459ba5c90e5a1c19c3.1416475860.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1416475860.git.nicolas.ferre@atmel.com>
References: <cover.1416475860.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Brezillon <boris.brezillon@free-electrons.com>

Add a DT node for the TRNG (True Random Number Generator) block.

Keep this block enabled as it does not depend on any external connection,
and thus should be available on all boards.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9g45.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index d3f65130a1f8..6c0637a4bda5 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -940,6 +940,13 @@
 				status = "disabled";
 			};
 
+			trng@fffcc000 {
+				compatible = "atmel,at91sam9g45-trng";
+				reg = <0xfffcc000 0x4000>;
+				interrupts = <6 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&trng_clk>;
+			};
+
 			i2c0: i2c@fff84000 {
 				compatible = "atmel,at91sam9g10-i2c";
 				reg = <0xfff84000 0x100>;
-- 
2.1.3

