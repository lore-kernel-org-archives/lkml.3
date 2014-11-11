Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaKKMFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:05:14 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:49322 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaKKMFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:05:08 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/3] regulator: max77802: Document binding for regulator operating modes
Date: Tue, 11 Nov 2014 13:04:43 +0100
Message-Id: <1415707485-28563-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415707485-28563-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1415707485-28563-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some regulators from the max77802 PMIC support to be configured in one
of two operating mode: Output ON (normal) and Output On Low Power Mode.
Not all regulators support these two modes and for some of them, the
mode can be changed while the system is running in normal operation
while others only support their mode to be changed on system suspend.

Extend the max77802 PMIC binding by documenting the possible operating
modes values so the regulators modes can be configured correctly.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 .../devicetree/bindings/regulator/max77802.txt     | 35 ++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/max77802.txt b/Documentation/devicetree/bindings/regulator/max77802.txt
index 5aeaffc..79e5476 100644
--- a/Documentation/devicetree/bindings/regulator/max77802.txt
+++ b/Documentation/devicetree/bindings/regulator/max77802.txt
@@ -25,6 +25,29 @@ with their hardware counterparts as follow. The valid names are:
 			example: LDO1, LDO2, LDO35.
 	-BUCKn 	:	for BUCKs, where n can lie in range 1 to 10.
 			example: BUCK1, BUCK5, BUCK10.
+
+The max77802 regulator supports two different operating modes: Normal and Low
+Power Mode. Some regulators support the modes to be changed at startup or by
+the consumers during normal operation while others only support to change the
+mode during system suspend. The standard regulator suspend states binding can
+be used to configure the regulator operating mode.
+
+The regulators that support the standard "regulator-initial-mode" property,
+changing their mode during normal operation are: LDOs 1, 3, 20 and 21.
+
+The possible values for "regulator-initial-mode" and "regulator-mode" are:
+	1: Normal regulator voltage output mode.
+	3: Low Power which reduces the quiescent current down to only 1uA
+
+The list of valid modes are defined in the dt-bindings/clock/maxim,max77802.h
+header and can be included by device tree source files.
+
+The standard "regulator-mode" property can only be used for regulators that
+support changing their mode to Low Power Mode during suspend. These regulators
+are: BUCKs 2-4 and LDOs 1-35. Also, it only takes effect if the regulator has
+been enabled for the given suspend state using "regulator-on-in-suspend" and
+has not been disabled for that state using "regulator-off-in-suspend".
+
 Example:
 
 	max77802@09 {
@@ -36,11 +59,23 @@ Example:
 		#size-cells = <0>;
 
 		regulators {
+			ldo1_reg: LDO1 {
+				regulator-name = "vdd_1v0";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+				regulator-initial-mode = <MAX77802_OPMODE_LP>;
+			};
+
 			ldo11_reg: LDO11 {
 				regulator-name = "vdd_ldo11";
 				regulator-min-microvolt = <1900000>;
 				regulator-max-microvolt = <1900000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-mode = <MAX77802_OPMODE_LP>;
+				};
 			};
 
 			buck1_reg: BUCK1 {
-- 
2.1.0

