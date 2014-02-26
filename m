Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbaBZRCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:02:19 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39825 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753421AbaBZRBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:01:25 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        b.brezillon@overkiz.com,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 4/7] ARM: at91/dt: at91sam9260: remove useless adc properties
Date: Wed, 26 Feb 2014 18:01:11 +0100
Message-Id: <1393434074-15600-4-git-send-email-alexandre.belloni@free-electrons.com>
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
 arch/arm/boot/dts/at91sam9260.dtsi | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index 997901f7ed73..ac1533368cb5 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -614,31 +614,26 @@
 				atmel,adc-use-external-triggers;
 				atmel,adc-channels-used = <0xf>;
 				atmel,adc-vref = <3300>;
-				atmel,adc-num-channels = <4>;
 				atmel,adc-startup-time = <15>;
-				atmel,adc-channel-base = <0x30>;
-				atmel,adc-drdy-mask = <0x10000>;
-				atmel,adc-status-register = <0x1c>;
-				atmel,adc-trigger-register = <0x04>;
 				atmel,adc-res = <8 10>;
 				atmel,adc-res-names = "lowres", "highres";
 				atmel,adc-use-res = "highres";
 
-				trigger@0 {
+				trigger0 {
 					trigger-name = "timer-counter-0";
 					trigger-value = <0x1>;
 				};
-				trigger@1 {
+				trigger1 {
 					trigger-name = "timer-counter-1";
 					trigger-value = <0x3>;
 				};
 
-				trigger@2 {
+				trigger2 {
 					trigger-name = "timer-counter-2";
 					trigger-value = <0x5>;
 				};
 
-				trigger@3 {
+				trigger3 {
 					trigger-name = "external";
 					trigger-value = <0x13>;
 					trigger-external;
-- 
1.8.3.2

