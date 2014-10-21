Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbaJUOig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:38:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58920 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932841AbaJUOie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:38:34 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH] ARM: dts: dra7-evm: Keep all VDD rails always-on
Date: Tue, 21 Oct 2014 09:38:10 -0500
Message-ID: <1413902290-304-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRA7 Data Manual (SPRS857L - August 2014) section 4.1.1 states: "All
unused power supply balls must be supplied with the voltages specified
in the Section 5.2, Recommended Operating Conditions".

This implies that all unused voltage rails for Vayu can never be
switched off even if the hardware blocks inside that voltage domain is
unused. Switching off these unused rails may result in stability issues
on other domains and increased leakage and power-on-hour impacts.

J6eco-evm dts file already considers this, however j6evm-dts file needs
to be fixed to consider this constraint of the SoC.

Signed-off-by: Nishanth Menon <nm@ti.com>
---

Patch is based on v3.18-rc1 tag.

 arch/arm/boot/dts/dra7-evm.dts |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index c6ce625..4f4c469 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -201,6 +201,7 @@
 					regulator-name = "smps45";
 					regulator-min-microvolt = < 850000>;
 					regulator-max-microvolt = <1150000>;
+					regulator-always-on;
 					regulator-boot-on;
 				};
 
@@ -209,6 +210,7 @@
 					regulator-name = "smps6";
 					regulator-min-microvolt = <850000>;
 					regulator-max-microvolt = <12500000>;
+					regulator-always-on;
 					regulator-boot-on;
 				};
 
@@ -226,6 +228,7 @@
 					regulator-name = "smps8";
 					regulator-min-microvolt = < 850000>;
 					regulator-max-microvolt = <1250000>;
+					regulator-always-on;
 					regulator-boot-on;
 				};
 
@@ -252,6 +255,7 @@
 					regulator-name = "ldo2";
 					regulator-min-microvolt = <3300000>;
 					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
 					regulator-boot-on;
 				};
 
@@ -269,6 +273,7 @@
 					regulator-name = "ldo9";
 					regulator-min-microvolt = <1050000>;
 					regulator-max-microvolt = <1050000>;
+					regulator-always-on;
 					regulator-boot-on;
 				};
 
-- 
1.7.9.5

