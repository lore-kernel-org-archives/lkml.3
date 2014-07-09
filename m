Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbaGISx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:53:29 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2797 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbaGISx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:53:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 09 Jul 2014 11:42:36 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH] ARM: tegra: Fix typoed ams,ext-control properties
Date: Wed, 9 Jul 2014 21:53:17 +0300
Message-ID: <1404931997-7118-1-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The property for enabling external rail control on the AS3722 is
ams,ext-control, not ams,external-control. Since the external rail
control property was previously being ignored, LP1 suspend on these
boards wasn't actually turning the CPU rail off at all.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
So here's a dilemma, either change the existing DTs, change the
binding + driver, or make the driver recognize both properties.
I chose the first one since the old behaviour was broken in the
first place and the old DTs stay as buggy as they were before.

 arch/arm/boot/dts/tegra124-jetson-tk1.dts | 6 +++---
 arch/arm/boot/dts/tegra124-venice2.dts    | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index 16082c0..89a772d 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -1461,7 +1461,7 @@
 					regulator-max-microamp = <3500000>;
 					regulator-always-on;
 					regulator-boot-on;
-					ams,external-control = <2>;
+					ams,ext-control = <2>;
 				};
 
 				sd1 {
@@ -1472,7 +1472,7 @@
 					regulator-max-microamp = <2500000>;
 					regulator-always-on;
 					regulator-boot-on;
-					ams,external-control = <1>;
+					ams,ext-control = <1>;
 				};
 
 				vdd_1v35_lp0: sd2 {
@@ -1521,7 +1521,7 @@
 					regulator-max-microvolt = <1050000>;
 					regulator-boot-on;
 					regulator-always-on;
-					ams,external-control = <1>;
+					ams,ext-control = <1>;
 				};
 
 				ldo1 {
diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index f1a5bac..70ad91d 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -682,7 +682,7 @@
 					regulator-max-microamp = <3500000>;
 					regulator-always-on;
 					regulator-boot-on;
-					ams,external-control = <2>;
+					ams,ext-control = <2>;
 				};
 
 				sd1 {
@@ -693,7 +693,7 @@
 					regulator-max-microamp = <2500000>;
 					regulator-always-on;
 					regulator-boot-on;
-					ams,external-control = <1>;
+					ams,ext-control = <1>;
 				};
 
 				vdd_1v35_lp0: sd2 {
@@ -742,7 +742,7 @@
 					regulator-max-microvolt = <1050000>;
 					regulator-boot-on;
 					regulator-always-on;
-					ams,external-control = <1>;
+					ams,ext-control = <1>;
 				};
 
 				ldo1 {
-- 
1.8.1.5

