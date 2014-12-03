Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaLCLc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:32:29 -0500
Received: from down.free-electrons.com ([37.187.137.238]:39391 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752628AbaLCLcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:32:25 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 11/11] ARM: at91/dt: fix at91 udc compatible strings
Date: Wed,  3 Dec 2014 12:32:10 +0100
Message-Id: <1417606330-17753-12-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417606330-17753-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417606330-17753-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The at91rm9200, at91sam9260, at91sam9261 and at91sam9263 SoCs have slightly
different UDC IPs.
Those differences were previously handled with cpu_is_at91xx macro which
are about to be dropped for multi-platform support, thus we need to
change compatible strings.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9260.dtsi | 2 +-
 arch/arm/boot/dts/at91sam9261.dtsi | 3 ++-
 arch/arm/boot/dts/at91sam9263.dtsi | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index cb100b0..b43de88 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -848,7 +848,7 @@
 			};
 
 			usb1: gadget@fffa4000 {
-				compatible = "atmel,at91rm9200-udc";
+				compatible = "atmel,at91sam9260-udc";
 				reg = <0xfffa4000 0x4000>;
 				interrupts = <10 IRQ_TYPE_LEVEL_HIGH 2>;
 				clocks = <&udc_clk>, <&udpck>;
diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
index e52ae97..90f0b59 100644
--- a/arch/arm/boot/dts/at91sam9261.dtsi
+++ b/arch/arm/boot/dts/at91sam9261.dtsi
@@ -119,11 +119,12 @@
 			};
 
 			usb1: gadget@fffa4000 {
-				compatible = "atmel,at91rm9200-udc";
+				compatible = "atmel,at91sam9261-udc";
 				reg = <0xfffa4000 0x4000>;
 				interrupts = <10 IRQ_TYPE_LEVEL_HIGH 2>;
 				clocks = <&udc_clk>, <&udpck>;
 				clock-names = "pclk", "hclk";
+				atmel,matrix = <&matrix>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index 51416c7d..2c7ed05 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -817,7 +817,7 @@
 			};
 
 			usb1: gadget@fff78000 {
-				compatible = "atmel,at91rm9200-udc";
+				compatible = "atmel,at91sam9263-udc";
 				reg = <0xfff78000 0x4000>;
 				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 2>;
 				clocks = <&udc_clk>, <&udpck>;
-- 
1.9.1

