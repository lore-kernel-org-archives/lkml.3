Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3FRIwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:52:23 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:61487 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab3FRIwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:52:14 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/3] ARM: ux500: Correct the EN_3v3 regulator's on/off GPIO
Date: Tue, 18 Jun 2013 09:51:58 +0100
Message-Id: <1371545519-27119-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371545519-27119-1-git-send-email-lee.jones@linaro.org>
References: <1371545519-27119-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When this node was added, the AB8500 GPIO driver was pretty broken.
As a hack, we pretended that NOMADIK GPIO 26 was the correct on/off
pin, as it was unused. It worked because AB8500 GPIO 26 was in an
'always on from boot' state. Now the AB8500 GPIO driver is working,
the default state for all the pins is 'off'. Let's flip back over to
use the correct GPIO which is _actually_ attached to the regulator.

We're also taking the opportunity to straighten out some formatting
misdemeanours, swapping spaces for tabs.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/snowball.dts | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index fb9dce5..49824be 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -22,12 +22,13 @@
 
 	en_3v3_reg: en_3v3 {
 		compatible = "regulator-fixed";
-                regulator-name = "en-3v3-fixed-supply";
-                regulator-min-microvolt = <3300000>;
-                regulator-max-microvolt = <3300000>;
-                gpios = <&gpio0 26  0x4>; // 26
-                startup-delay-us = <5000>;
-                enable-active-high;
+		regulator-name = "en-3v3-fixed-supply";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		/* AB8500 GPIOs start from 1 - offset 25 is GPIO26. */
+		gpio = <&ab8500_gpio 25 0x4>;
+		startup-delay-us = <5000>;
+		enable-active-high;
 	};
 
 	gpio_keys {
-- 
1.8.1.2

