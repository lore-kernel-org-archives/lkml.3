Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3H1Kl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:41:26 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13330 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3H1KlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:41:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 28 Aug 2013 03:41:22 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <thierry.reding@gmail.com>
CC: <tbergstrom@nvidia.com>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 5/5] ARM: tegra: Add hdmi to Tegra114 Dalmore device tree
Date: Wed, 28 Aug 2013 13:40:59 +0300
Message-ID: <1377686459-16634-6-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1377686459-16634-1-git-send-email-mperttunen@nvidia.com>
References: <1377686459-16634-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add hdmi node to Dalmore device tree to supply Dalmore-specific
data: VDD and PLL regulators for HDMI port, DDC bus and HDMI
cable hotplug GPIO.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 arch/arm/boot/dts/tegra114-dalmore.dts | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index 6023028..50e6fb4 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -713,6 +713,17 @@
 		};
 	};
 
+	host1x {
+		hdmi {
+			status = "okay";
+
+			vdd-supply = <&vdd_hdmi_reg>;
+			pll-supply = <&palmas_smps3_reg>;
+			nvidia,ddc-i2c-bus = <&hdmi_ddc>;
+			nvidia,hpd-gpio = <&gpio TEGRA_GPIO(N, 7) GPIO_ACTIVE_HIGH>;
+		};
+	};
+
 	serial@70006300 {
 		status = "okay";
 	};
@@ -740,6 +751,10 @@
 		};
 	};
 
+	hdmi_ddc: i2c@7000c700 {
+		status = "okay";
+	};
+
 	i2c@7000d000 {
 		status = "okay";
 		clock-frequency = <400000>;
@@ -1169,6 +1184,8 @@
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			enable-active-high;
+			regulator-always-on;
+			regulator-boot-on;
 			gpio = <&gpio TEGRA_GPIO(K, 1) GPIO_ACTIVE_HIGH>;
 			vin-supply = <&tps65090_dcdc1_reg>;
 		};
-- 
1.8.1.5

