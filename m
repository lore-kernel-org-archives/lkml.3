Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269Ab3GQQqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:46:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57820 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933143Ab3GQQqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:46:18 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <benoit.cousson@linaro.org>,
        Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        J Keerthy <j-keerthy@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 4/9] ARM: dts: omap5-uevm: update LDO1 voltage to 1.5V and settings
Date: Wed, 17 Jul 2013 11:45:33 -0500
Message-ID: <1374079538-19548-5-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374079538-19548-1-git-send-email-nm@ti.com>
References: <1374079538-19548-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e00c27ef3b4c23e39d0a77b7c8e5be44c28001c7
(ARM: dts: OMAP5: Add Palmas MFD node and regulator nodes)
introduced regulator entries for OMAP5uEVM.

However, The regulator information is based on an older temporary
pre-production board variant and does not reflect production board
750-2628-XXX boards.

LDO1 supplies VDDAPHY_CAM which is OMAP5's vdda_csiporta/b/c. This
can only be supplied at 1.5V or 1.8V and we currently supply 2.8V.

To prevent any potential device damage risk, use the specified
1.5V-1.8V supply.

Remove 'always-on' and 'boot-on' settings here as it is
a 'on need' supply to SoC IP and is not enabled by PMIC by
default at boot.

Reported-by: Marc Jüttner <m-juettner@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/omap5-uevm.dts |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index 87b3e9e..a55f4d8 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -346,10 +346,8 @@
 				ldo1_reg: ldo1 {
 					/* VDDAPHY_CAM: vdda_csiport */
 					regulator-name = "ldo1";
-					regulator-min-microvolt = <2800000>;
-					regulator-max-microvolt = <2800000>;
-					regulator-always-on;
-					regulator-boot-on;
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <1800000>;
 				};
 
 				ldo2_reg: ldo2 {
-- 
1.7.9.5

