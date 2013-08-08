Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769Ab3HHG5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 02:57:04 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19113 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab3HHG5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 02:57:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 07 Aug 2013 23:57:00 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>, <swarren@wwwdotorg.org>
CC: <MLongnecker@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v2 2/3] ARM: dt: t114 dalmore: add dt entry for nct1008
Date: Thu, 8 Aug 2013 14:56:30 +0800
Message-ID: <1375944991-29182-3-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375944991-29182-1-git-send-email-wni@nvidia.com>
References: <1375944991-29182-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable thermal sensor nct1008 for t114 dalmore.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/boot/dts/tegra114-dalmore.dts |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index b5a42f0..9d4d2b2 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -738,6 +738,14 @@
 			realtek,ldo1-en-gpios =
 				<&gpio TEGRA_GPIO(V, 3) GPIO_ACTIVE_HIGH>;
 		};
+
+		nct1008 {
+			compatible = "onnn,nct1008";
+			reg = <0x4c>;
+			vdd-supply = <&palmas_ldo6_reg>;
+			interrupt-parent = <&gpio>;
+			interrupts = <TEGRA_GPIO(O, 4) IRQ_TYPE_LEVEL_LOW>;
+		};
 	};
 
 	i2c@7000d000 {
@@ -945,7 +953,7 @@
 						regulator-max-microvolt = <1800000>;
 					};
 
-					ldo6 {
+					palmas_ldo6_reg: ldo6 {
 						regulator-name = "vdd-sensor-2v85";
 						regulator-min-microvolt = <2850000>;
 						regulator-max-microvolt = <2850000>;
-- 
1.7.9.5

