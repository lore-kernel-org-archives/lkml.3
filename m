Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761368Ab3DBNXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:23:51 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:38951 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760986Ab3DBNWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:22:14 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/9] ARM: ux500: Move Snowball's thermal DT node into existing PRCMU one
Date: Tue,  2 Apr 2013 14:21:51 +0100
Message-Id: <1364908916-29803-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the thermal DT node was inserted a new PRCMU node was created;
however, one already exists in the Snowball DTS file. Here we
amalgamate the two into a single consolidated node.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/snowball.dts |   53 +++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index d3ec32f..cc99447 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -99,33 +99,6 @@
 			status = "okay";
 		};
 
-		prcmu@80157000 {
-			thermal@801573c0 {
-				num-trips = <4>;
-
-				trip0-temp = <70000>;
-				trip0-type = "active";
-				trip0-cdev-num = <1>;
-				trip0-cdev-name0 = "thermal-cpufreq-0";
-
-				trip1-temp = <75000>;
-				trip1-type = "active";
-				trip1-cdev-num = <1>;
-				trip1-cdev-name0 = "thermal-cpufreq-0";
-
-				trip2-temp = <80000>;
-				trip2-type = "active";
-				trip2-cdev-num = <1>;
-				trip2-cdev-name0 = "thermal-cpufreq-0";
-
-				trip3-temp = <85000>;
-				trip3-type = "critical";
-				trip3-cdev-num = <0>;
-
-				status = "okay";
-			 };
-		};
-
 		external-bus@50000000 {
 			status = "okay";
 
@@ -296,7 +269,31 @@
 				db8500_esram34_ret_reg: db8500_esram34_ret {
 					regulator-name = "db8500-esram34-ret";
 				};
-			};
+
+			thermal@801573c0 {
+				num-trips = <4>;
+
+				trip0-temp = <70000>;
+				trip0-type = "active";
+				trip0-cdev-num = <1>;
+				trip0-cdev-name0 = "thermal-cpufreq-0";
+
+				trip1-temp = <75000>;
+				trip1-type = "active";
+				trip1-cdev-num = <1>;
+				trip1-cdev-name0 = "thermal-cpufreq-0";
+
+				trip2-temp = <80000>;
+				trip2-type = "active";
+				trip2-cdev-num = <1>;
+				trip2-cdev-name0 = "thermal-cpufreq-0";
+
+				trip3-temp = <85000>;
+				trip3-type = "critical";
+				trip3-cdev-num = <0>;
+
+				status = "okay";
+			 };
 
 			ab8500 {
 				ab8500-regulators {
-- 
1.7.10.4

