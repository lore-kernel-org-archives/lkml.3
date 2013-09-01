Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3IAUCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 16:02:08 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:41871 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab3IAUCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 16:02:06 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/4] ARM: nomadik: register VMMC regulator
Date: Sun,  1 Sep 2013 22:01:52 +0200
Message-Id: <1378065712-18195-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the STw481x VMMC regulator to the Nomadik
device tree.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
index 9169d30..0e543e0 100644
--- a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
+++ b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
@@ -707,8 +707,14 @@
 		pinctrl-0 = <&i2c0_default_mux>, <&i2c0_default_mode>;
 
 		stw4811@2d {
-			   compatible = "st,stw4811";
-			   reg = <0x2d>;
+			compatible = "st,stw4811";
+			reg = <0x2d>;
+			vmmc_regulator: vmmc {
+				compatible = "st,stw481x-vmmc";
+				regulator-name = "VMMC";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+			};
 		};
 	};
 
@@ -839,6 +845,7 @@
 			cd-inverted;
 			pinctrl-names = "default";
 			pinctrl-0 = <&mmcsd_default_mux>, <&mmcsd_default_mode>;
+			vmmc-supply = <&vmmc_regulator>;
 		};
 	};
 };
-- 
1.8.1.4

