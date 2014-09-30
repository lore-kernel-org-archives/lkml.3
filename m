Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaI3QUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:20:01 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56828 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752472AbaI3QT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:19:56 -0400
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
Subject: [PATCH 5/6] ARM: at91/dt: add trng node
Date: Tue, 30 Sep 2014 18:19:46 +0200
Message-Id: <1412093987-30241-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412093987-30241-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1412093987-30241-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a DT node for the TRNG (True Random Number Generator) block.

Keep this block enabled as it does not depend on any external connection,
and thus should be available on all boards.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9g45.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index 932a669..790c890 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -934,6 +934,13 @@
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
1.9.1

