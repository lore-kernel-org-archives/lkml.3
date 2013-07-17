Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563Ab3GQQrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:47:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57821 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab3GQQqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:46:19 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <benoit.cousson@linaro.org>,
        Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        J Keerthy <j-keerthy@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 3/9] ARM: dts: omap5-uevm: update and disable unused regulators LDO[28]
Date: Wed, 17 Jul 2013 11:45:32 -0500
Message-ID: <1374079538-19548-4-git-send-email-nm@ti.com>
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
750-2628-XXX boards - On production boards, LDO2 and 8 are unused.

LDO2 and LDO8 do not go to any peripheral or connector on the board.
Further, these unused regulators should have been 2.8V for LDO2 and
3.0V for LDO8. Mark these LDOs as disabled in the dts until needed.

Reported-by: Marc Jüttner <m-juettner@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/omap5-uevm.dts |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index 6709f1e..87b3e9e 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -355,10 +355,10 @@
 				ldo2_reg: ldo2 {
 					/* VCC_2V8_DISP: Does not go anywhere */
 					regulator-name = "ldo2";
-					regulator-min-microvolt = <2900000>;
-					regulator-max-microvolt = <2900000>;
-					regulator-always-on;
-					regulator-boot-on;
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					/* Unused */
+					status = "disabled";
 				};
 
 				ldo3_reg: ldo3 {
@@ -409,10 +409,11 @@
 				ldo8_reg: ldo8 {
 					/* VDD_3v0: Does not go anywhere */
 					regulator-name = "ldo8";
-					regulator-min-microvolt = <1500000>;
-					regulator-max-microvolt = <1500000>;
-					regulator-always-on;
+					regulator-min-microvolt = <3000000>;
+					regulator-max-microvolt = <3000000>;
 					regulator-boot-on;
+					/* Unused */
+					status = "disabled";
 				};
 
 				ldo9_reg: ldo9 {
-- 
1.7.9.5

