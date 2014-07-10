Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaGJVpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:45:20 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13318 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbaGJVnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:43:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 Jul 2014 14:32:55 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, <devicetree@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 10/13] ARM: tegra: Enable the DFLL on the Jetson TK1
Date: Fri, 11 Jul 2014 00:42:46 +0300
Message-ID: <1405028569-14253-11-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the board-specific properties of the DFLL for the Jetson TK1 board.
On this board, the DFLL will take control of the sd0 regulator on the
on-board AS3722 PMIC.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 arch/arm/boot/dts/tegra124-jetson-tk1.dts | 83 ++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index 89a772d..2dfd516 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -1453,7 +1453,7 @@
 				vin-ldo9-10-supply = <&vdd_5v0_sys>;
 				vin-ldo11-supply = <&vdd_3v3_run>;
 
-				sd0 {
+				vdd_cpu: sd0 {
 					regulator-name = "+VDD_CPU_AP";
 					regulator-min-microvolt = <700000>;
 					regulator-max-microvolt = <1400000>;
@@ -1636,6 +1636,87 @@
 		non-removable;
 	};
 
+	dfll@0,70110000 {
+		status = "okay";
+		vdd_cpu-supply = <&vdd_cpu>;
+		nvidia,i2c-fs-rate = <400000>;
+		nvidia,pmic-i2c-address = <0x40>;
+		nvidia,pmic-i2c-voltage-register = <0x00>;
+
+		nvidia,pmic-voltage-table =
+			<0x1e 700000>,
+			<0x1f 710000>,
+			<0x20 720000>,
+			<0x21 730000>,
+			<0x22 740000>,
+			<0x23 750000>,
+			<0x24 760000>,
+			<0x25 770000>,
+			<0x26 780000>,
+			<0x27 790000>,
+			<0x28 800000>,
+			<0x29 810000>,
+			<0x2a 820000>,
+			<0x2b 830000>,
+			<0x2c 840000>,
+			<0x2d 850000>,
+			<0x2e 860000>,
+			<0x2f 870000>,
+			<0x30 880000>,
+			<0x31 890000>,
+			<0x32 900000>,
+			<0x33 910000>,
+			<0x34 920000>,
+			<0x35 930000>,
+			<0x36 940000>,
+			<0x37 950000>,
+			<0x38 960000>,
+			<0x39 970000>,
+			<0x3a 980000>,
+			<0x3b 990000>,
+			<0x3c 1000000>,
+			<0x3d 1010000>,
+			<0x3e 1020000>,
+			<0x3f 1030000>,
+			<0x40 1040000>,
+			<0x41 1050000>,
+			<0x42 1060000>,
+			<0x43 1070000>,
+			<0x44 1080000>,
+			<0x45 1090000>,
+			<0x46 1100000>,
+			<0x47 1110000>,
+			<0x48 1120000>,
+			<0x49 1130000>,
+			<0x4a 1140000>,
+			<0x4b 1150000>,
+			<0x4c 1160000>,
+			<0x4d 1170000>,
+			<0x4e 1180000>,
+			<0x4f 1190000>,
+			<0x50 1200000>,
+			<0x51 1210000>,
+			<0x52 1220000>,
+			<0x53 1230000>,
+			<0x54 1240000>,
+			<0x55 1250000>,
+			<0x56 1260000>,
+			<0x57 1270000>,
+			<0x58 1280000>,
+			<0x59 1290000>,
+			<0x5a 1300000>,
+			<0x5b 1310000>,
+			<0x5c 1320000>,
+			<0x5d 1330000>,
+			<0x5e 1340000>,
+			<0x5f 1350000>,
+			<0x60 1360000>,
+			<0x61 1370000>,
+			<0x62 1380000>,
+			<0x63 1390000>,
+			<0x64 1400000>;
+	};
+
 	ahub@0,70300000 {
 		i2s@0,70301100 {
 			status = "okay";
-- 
1.8.1.5

