Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3GCLAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:00:54 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:54701 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab3GCLAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:00:53 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <giometti@enneenne.com>, Bo Shen <voice.shen@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91/DT: at91sam9x5ek: fix USB host property to enable port C
Date: Wed, 3 Jul 2013 13:00:50 +0200
Message-ID: <1372849250-14715-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device Tree "num-ports" property of USB host node has to be
set to maximum number of ports available.
The possibility to activate a particular port is done by specifying the proper
gpio configuration for its vbus.

This patch fixes the USB host node by configuring the 3 ports available on the
product and letting "port A" available for USB gadget usage.

Reported-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Bo Shen <voice.shen@atmel.com>
---
 arch/arm/boot/dts/at91sam9x5ek.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
index b753855..49e3c45 100644
--- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
@@ -94,8 +94,9 @@
 
 		usb0: ohci@00600000 {
 			status = "okay";
-			num-ports = <2>;
-			atmel,vbus-gpio = <&pioD 19 GPIO_ACTIVE_LOW
+			num-ports = <3>;
+			atmel,vbus-gpio = <0 /* &pioD 18 GPIO_ACTIVE_LOW *//* Activate to have access to port A */
+					   &pioD 19 GPIO_ACTIVE_LOW
 					   &pioD 20 GPIO_ACTIVE_LOW
 					  >;
 		};
-- 
1.8.2.2

