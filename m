Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3ILPmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:42:52 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45002 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab3ILPm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:42:27 -0400
From: Koen Kooi <koen@dominion.thruhere.net>
To: linux-kernel@vger.kernel.org
Cc: bcousson@baylibre.com, tony@atomide.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Koen Kooi <koen@dominion.thruhere.net>
Subject: [PATCH 4/4] ARM: dts: am335x-bone-common: add cpu0 and mmc1 triggers
Date: Thu, 12 Sep 2013 17:42:12 +0200
Message-Id: <1379000532-27376-5-git-send-email-koen@dominion.thruhere.net>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1379000532-27376-1-git-send-email-koen@dominion.thruhere.net>
References: <1379000532-27376-1-git-send-email-koen@dominion.thruhere.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This matches the vendor 3.8.x configuration that is shipping with the boards.

The LED layout is now:

USR0: heartbeat
USR1: mmc0 (micro-SD slot)
USR2: cpu0
USR3: mmc1 (eMMC)

The cpu0 triggers was put inbetween the mmc triggers to make is easier to see
where the disk activity is.

Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
---
 arch/arm/boot/dts/am335x-bone-common.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
index 80407ff..3057f30 100644
--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -203,12 +203,14 @@
 		led@4 {
 			label = "beaglebone:green:usr2";
 			gpios = <&gpio1 23 GPIO_ACTIVE_HIGH>;
+			linux,default-trigger = "cpu0";
 			default-state = "off";
 		};
 
 		led@5 {
 			label = "beaglebone:green:usr3";
 			gpios = <&gpio1 24 GPIO_ACTIVE_HIGH>;
+			linux,default-trigger = "mmc1";
 			default-state = "off";
 		};
 	};
-- 
1.8.2.1

