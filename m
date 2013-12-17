Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3LQQC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:02:29 -0500
Received: from 18.mo3.mail-out.ovh.net ([87.98.172.162]:47541 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753356Ab3LQQC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:02:27 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Slaby <jslaby@suse.cz>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH] tty/serial: at91: document clock properties
Date: Tue, 17 Dec 2013 17:02:01 +0100
Message-Id: <1387296121-7558-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 8471270900300019810
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

Document the clock properties required by the at91 i2c bus driver.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 .../devicetree/bindings/serial/atmel-usart.txt     |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/serial/atmel-usart.txt b/Documentation/devicetree/bindings/serial/atmel-usart.txt
index 2191dcb..9c5d19a 100644
--- a/Documentation/devicetree/bindings/serial/atmel-usart.txt
+++ b/Documentation/devicetree/bindings/serial/atmel-usart.txt
@@ -6,6 +6,9 @@ Required properties:
   additional mode or an USART new feature.
 - reg: Should contain registers location and length
 - interrupts: Should contain interrupt
+- clock-names: tuple listing input clock names.
+	Required elements: "usart"
+- clocks: phandles to input clocks.
 
 Optional properties:
 - atmel,use-dma-rx: use of PDC or DMA for receiving data
@@ -26,6 +29,8 @@ Example:
 		compatible = "atmel,at91sam9260-usart";
 		reg = <0xfff8c000 0x4000>;
 		interrupts = <7>;
+		clocks = <&usart0_clk>;
+		clock-names = "usart";
 		atmel,use-dma-rx;
 		atmel,use-dma-tx;
 	};
@@ -35,6 +40,8 @@ Example:
 		compatible = "atmel,at91sam9260-usart";
 		reg = <0xf001c000 0x100>;
 		interrupts = <12 4 5>;
+		clocks = <&usart0_clk>;
+		clock-names = "usart";
 		atmel,use-dma-rx;
 		atmel,use-dma-tx;
 		dmas = <&dma0 2 0x3>,
-- 
1.7.9.5

