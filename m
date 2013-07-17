Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab3GQQqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:46:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40589 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab3GQQqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:46:10 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <benoit.cousson@linaro.org>,
        Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        J Keerthy <j-keerthy@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 8/9] ARM: dts: omap5-uevm: update LDO7 voltage to 2V and settings
Date: Wed, 17 Jul 2013 11:45:37 -0500
Message-ID: <1374079538-19548-9-git-send-email-nm@ti.com>
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

LDO4 supplies VDD_VPP which is vpp1. This is currently configured for
1.5V which as per data manual "A pulse width of 1000 ns and an amplitude
of 2V is required to program each eFuse bit. Otherwise, VPP1 must not
be supplied".

So, fix the voltage to 2V. and disable the supply since we have no plans
of programming efuse bits - it can only be done once - in factory.

Further it is not enabled by default by PMIC so, 'boot-on' must be
removed, and the 'always-on' needs to be removed to achieve pulsing
if efuse needs to be programmed.

Reported-by: Marc Jüttner <m-juettner@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/omap5-uevm.dts |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index 3ff5874..ef05676 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -397,10 +397,10 @@
 				ldo7_reg: ldo7 {
 					/* VDD_VPP: vpp1 */
 					regulator-name = "ldo7";
-					regulator-min-microvolt = <1500000>;
-					regulator-max-microvolt = <1500000>;
-					regulator-always-on;
-					regulator-boot-on;
+					regulator-min-microvolt = <2000000>;
+					regulator-max-microvolt = <2000000>;
+					/* Only for efuse reprograming! */
+					status = "disabled";
 				};
 
 				ldo8_reg: ldo8 {
-- 
1.7.9.5

