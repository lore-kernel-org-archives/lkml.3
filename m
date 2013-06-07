Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3FGQLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:11:47 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:38817 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3FGQLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:11:45 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, broonie@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/10] ARM: ux500: Add Device Tree nodes for AB8500 External regulators
Date: Fri,  7 Jun 2013 17:11:19 +0100
Message-Id: <1370621488-18130-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AB8500 has 3 external regulators which are used to control outside
voltage sources. Some of the core AB8500 use these external regulators
as a supply, so they must be obtainable via Device Tree.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index a082f0b..ea87fac 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -452,6 +452,33 @@
 					stericsson,earpeice-cmv = <950>; /* Units in mV. */
 				};
 
+				ext_regulators: ab8500-ext-regulators {
+					compatible = "stericsson,ab8500-ext-regulator";
+
+					ab8500_ext1_reg: ab8500_ext1 {
+						regulator-compatible = "ab8500_ext1";
+						regulator-min-microvolt = <1800000>;
+						regulator-max-microvolt = <1800000>;
+						regulator-boot-on;
+						regulator-always-on;
+					};
+
+					ab8500_ext2_reg: ab8500_ext2 {
+						regulator-compatible = "ab8500_ext2";
+						regulator-min-microvolt = <1360000>;
+						regulator-max-microvolt = <1360000>;
+						regulator-boot-on;
+						regulator-always-on;
+					};
+
+					ab8500_ext3_reg: ab8500_ext3 {
+						regulator-compatible = "ab8500_ext3";
+						regulator-min-microvolt = <3400000>;
+						regulator-max-microvolt = <3400000>;
+						regulator-boot-on;
+					};
+				};
+
 				ab8500-regulators {
 					compatible = "stericsson,ab8500-regulator";
 
-- 
1.7.10.4

