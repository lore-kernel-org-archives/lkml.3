Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800Ab3GQQsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:48:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46275 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933056Ab3GQQqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:46:15 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <benoit.cousson@linaro.org>,
        Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        J Keerthy <j-keerthy@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 5/9] ARM: dts: omap5-uevm: update LDO3 voltage to 1.5V and settings
Date: Wed, 17 Jul 2013 11:45:34 -0500
Message-ID: <1374079538-19548-6-git-send-email-nm@ti.com>
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

LDO3 supplies Low Latency Interface(LLI) hardware module which is a
special hardware to communicate with Modem. However since uEVM is
not setup by default for this communication, this should be disabled
by default.

Further, vdda_lli is supposed to be 1.5V and not 3V.

Reported-by: Marc Jüttner <m-juettner@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/omap5-uevm.dts |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index a55f4d8..c6d560b 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -362,10 +362,11 @@
 				ldo3_reg: ldo3 {
 					/* VDDAPHY_MDM: vdda_lli */
 					regulator-name = "ldo3";
-					regulator-min-microvolt = <3000000>;
-					regulator-max-microvolt = <3000000>;
-					regulator-always-on;
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <1500000>;
 					regulator-boot-on;
+					/* Only if Modem is used */
+					status = "disabled";
 				};
 
 				ldo4_reg: ldo4 {
-- 
1.7.9.5

