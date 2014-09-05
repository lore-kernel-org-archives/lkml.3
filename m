Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732AbaIEOpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:45:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60851 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932272AbaIEOpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:45:17 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] ARM: at91/dt: rm9200: fix usb clock definition
Date: Fri,  5 Sep 2014 16:45:12 +0200
Message-Id: <1409928312-24235-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atmel,clk-divisors property is taking 4 divisors, if less are
provided, the clock registration will fail.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91rm9200.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
index 65ccf564b9a5..6c97d4af61ee 100644
--- a/arch/arm/boot/dts/at91rm9200.dtsi
+++ b/arch/arm/boot/dts/at91rm9200.dtsi
@@ -149,7 +149,7 @@
 				usb: usbck {
 					compatible = "atmel,at91rm9200-clk-usb";
 					#clock-cells = <0>;
-					atmel,clk-divisors = <1 2>;
+					atmel,clk-divisors = <1 2 0 0>;
 					clocks = <&pllb>;
 				};
 
-- 
1.9.1

