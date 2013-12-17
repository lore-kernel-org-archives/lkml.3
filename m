Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3LQPrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:47:31 -0500
Received: from 9.mo3.mail-out.ovh.net ([87.98.184.141]:58443 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754826Ab3LQPrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:47:24 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Landley <rob@landley.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH] drivers/misc: atmel_tclib: document clock properties
Date: Tue, 17 Dec 2013 16:47:14 +0100
Message-Id: <1387295234-7123-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 8222728495901735010
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the clock properties required by the atmel_tclib driver.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 .../devicetree/bindings/arm/atmel-at91.txt         |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
index 1196290..78530e6 100644
--- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
+++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
@@ -20,6 +20,10 @@ TC/TCLIB Timer required properties:
 - interrupts: Should contain all interrupts for the TC block
   Note that you can specify several interrupt cells if the TC
   block has one interrupt per channel.
+- clock-names: tuple listing input clock names.
+	Required elements: "t0_clk"
+	Optional elements: "t1_clk", "t2_clk"
+- clocks: phandles to input clocks.
 
 Examples:
 
@@ -28,6 +32,8 @@ One interrupt per TC block:
 		compatible = "atmel,at91rm9200-tcb";
 		reg = <0xfff7c000 0x100>;
 		interrupts = <18 4>;
+		clocks = <&tcb0_clk>;
+		clock-names = "t0_clk";
 	};
 
 One interrupt per TC channel in a TC block:
@@ -35,6 +41,8 @@ One interrupt per TC channel in a TC block:
 		compatible = "atmel,at91rm9200-tcb";
 		reg = <0xfffdc000 0x100>;
 		interrupts = <26 4 27 4 28 4>;
+		clocks = <&tcb1_clk>;
+		clock-names = "t0_clk";
 	};
 
 RSTC Reset Controller required properties:
-- 
1.7.9.5

