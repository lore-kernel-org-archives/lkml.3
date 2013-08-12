Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3HLJhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 05:37:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57181 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab3HLJhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 05:37:45 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <benoit.cousson@linaro.org>, <tony@atomide.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ian.campbell@citrix.com>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>, <balbi@ti.com>
Subject: [PATCH] arm: omap5: dts: split SMPS10 dt node
Date: Mon, 12 Aug 2013 15:07:01 +0530
Message-ID: <1376300221-15172-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMPS10 has two outputs OUT1 and OUT2. Hence SMPS10 is modeled as
two regulators. The dt node is split to reflect it.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap5-uevm.dts |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index 65d7b60..05b9b12 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -334,9 +334,18 @@
 					ti,smps-range = <0x80>;
 				};
 
-				smps10_reg: smps10 {
+				smps10_out2_reg: smps10_out2 {
 					/* VBUS_5V_OTG */
-					regulator-name = "smps10";
+					regulator-name = "smps10_out2";
+					regulator-min-microvolt = <5000000>;
+					regulator-max-microvolt = <5000000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				smps10_out1_reg: smps10_out1 {
+					/* VBUS_5V_OTG */
+					regulator-name = "smps10_out1";
 					regulator-min-microvolt = <5000000>;
 					regulator-max-microvolt = <5000000>;
 					regulator-always-on;
-- 
1.7.10.4

