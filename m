Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaBZRB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:01:29 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39833 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753483AbaBZRB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:01:26 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        b.brezillon@overkiz.com,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 6/7] ARM: at91/dt: at91sam9x5: remove useless adc properties
Date: Wed, 26 Feb 2014 18:01:13 +0100
Message-Id: <1393434074-15600-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393434074-15600-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1393434074-15600-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the properties that are not used anymore by the at91_adc driver.

Also, stop using unit-addresses for the triggers as suggested by Mark
Rutland in
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-February/234184.html

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9x5.dtsi | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 174219de92fa..a535c905d9d4 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -627,35 +627,30 @@
 				atmel,adc-use-external;
 				atmel,adc-channels-used = <0xffff>;
 				atmel,adc-vref = <3300>;
-				atmel,adc-num-channels = <12>;
 				atmel,adc-startup-time = <40>;
-				atmel,adc-channel-base = <0x50>;
-				atmel,adc-drdy-mask = <0x1000000>;
-				atmel,adc-status-register = <0x30>;
-				atmel,adc-trigger-register = <0xc0>;
 				atmel,adc-res = <8 10>;
 				atmel,adc-res-names = "lowres", "highres";
 				atmel,adc-use-res = "highres";
 
-				trigger@0 {
+				trigger0 {
 					trigger-name = "external-rising";
 					trigger-value = <0x1>;
 					trigger-external;
 				};
 
-				trigger@1 {
+				trigger1 {
 					trigger-name = "external-falling";
 					trigger-value = <0x2>;
 					trigger-external;
 				};
 
-				trigger@2 {
+				trigger2 {
 					trigger-name = "external-any";
 					trigger-value = <0x3>;
 					trigger-external;
 				};
 
-				trigger@3 {
+				trigger3 {
 					trigger-name = "continuous";
 					trigger-value = <0x6>;
 				};
-- 
1.8.3.2

