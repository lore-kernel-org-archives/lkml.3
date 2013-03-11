Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab3CKSMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:12:37 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:36085 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab3CKSLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:11:22 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v2 2/5] ARM: at91/dts: add RTC nodes
Date: Mon, 11 Mar 2013 19:07:56 +0100
Message-Id: <1363025279-17615-3-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363025279-17615-1-git-send-email-jhovold@gmail.com>
References: <20130311180611.GF8797@localhost>
 <1363025279-17615-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add RTC nodes for Atmel SOCs.

Use two different compatible properties to reflect the fact that the
RTC-peripherals are backup powered (VDDBU) and are thus not reset on
wake-up, user, watchdog or software reset on all SOCs but at91rm9200.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 arch/arm/boot/dts/at91rm9200.dtsi  | 5 +++++
 arch/arm/boot/dts/at91sam9g45.dtsi | 5 +++++
 arch/arm/boot/dts/at91sam9n12.dtsi | 5 +++++
 arch/arm/boot/dts/at91sam9x5.dtsi  | 5 +++++
 4 files changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
index 222047f..96b4e30 100644
--- a/arch/arm/boot/dts/at91rm9200.dtsi
+++ b/arch/arm/boot/dts/at91rm9200.dtsi
@@ -326,6 +326,11 @@
 			status = "disabled";
 		};
 
+		rtc@fffffe00 {
+			compatible = "atmel,at91rm9200-rtc";
+			reg = <0xfffffe00 0x30>;
+		};
+
 		usb0: ohci@00300000 {
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00300000 0x100000>;
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index 6b1d4ca..c1ad522 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -526,6 +526,11 @@
 				status = "disabled";
 			};
 
+			rtc@fffffdb0 {
+				compatible = "atmel,at91sam9g45-rtc";
+				reg = <0xfffffdb0 0x30>;
+			};
+
 			watchdog@fffffd40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffd40 0x10>;
diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index 4801717..802e92f 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -311,6 +311,11 @@
 				status = "disabled";
 			};
 
+			rtc@fffffeb0 {
+				compatible = "atmel,at91sam9g45-rtc";
+				reg = <0xfffffeb0 0x30>;
+			};
+
 			ssc0: ssc@f0010000 {
 				compatible = "atmel,at91sam9g45-ssc";
 				reg = <0xf0010000 0x4000>;
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index c461e11..432fbfb 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -362,6 +362,11 @@
 				};
 			};
 
+			rtc@fffffeb0 {
+				compatible = "atmel,at91sam9g45-rtc";
+				reg = <0xfffffeb0 0x30>;
+			};
+
 			ssc0: ssc@f0010000 {
 				compatible = "atmel,at91sam9g45-ssc";
 				reg = <0xf0010000 0x4000>;
-- 
1.8.1.5

