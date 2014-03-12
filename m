Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaCLNOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:14:47 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:65530 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaCLNOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:14:45 -0400
From: Matt Porter <mporter@linaro.org>
To: Alex Elder <elder@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Cc: Mark Brown <broonie@kernel.org>, Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: dts: bcm28155-ap: leave camldo1 on to fix reboot
Date: Wed, 12 Mar 2014 09:14:39 -0400
Message-Id: <1394630079-12063-1-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BCM28155-AP board has a bootloader that expects the camldo1
regulator to be enabled on entry. Currently, the camldo1 regulator
is disabled when no longer in use as is the case during a reboot /
warm reset. This causes the early bootloader to hang upon entry. Add
regulator-always-on to the camldo1 constraint to fix reboot.

Reported-by: Alex Elder <elder@linaro.org>
Signed-off-by: Matt Porter <mporter@linaro.org>
---
[Depends on BCM59056 regulator series dts support:
 http://www.gossamer-threads.com/lists/linux/kernel/1885489]

 arch/arm/boot/dts/bcm28155-ap.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
index 99ff0c1..cc1303c 100644
--- a/arch/arm/boot/dts/bcm28155-ap.dts
+++ b/arch/arm/boot/dts/bcm28155-ap.dts
@@ -94,6 +94,7 @@
 		camldo1_reg: camldo1 {
 			regulator-min-microvolt = <3300000>;
 			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
 		};
 
 		sdldo_reg: sdldo {
-- 
1.8.4

