Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3H1Ptd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:49:33 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19845 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab3H1Psz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:48:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 28 Aug 2013 08:48:54 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <thierry.reding@gmail.com>
CC: <tbergstrom@nvidia.com>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v2 6/6] ARM: tegra: Add HDMI to Tegra114 Dalmore device tree
Date: Wed, 28 Aug 2013 18:48:42 +0300
Message-ID: <1377704922-2824-7-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1377704922-2824-1-git-send-email-mperttunen@nvidia.com>
References: <1377704922-2824-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add HDMI node to Dalmore device tree to supply Dalmore-specific
data: VDD and PLL regulators for HDMI port, DDC bus and HDMI
cable hotplug GPIO.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 arch/arm/boot/dts/tegra114-dalmore.dts | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index 6023028..f979e74 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -713,6 +713,19 @@
 		};
 	};
 
+	host1x {
+		hdmi {
+			status = "okay";
+
+			vdd-supply = <&vdd_hdmi_reg>;
+			pll-supply = <&palmas_smps3_reg>;
+
+			nvidia,ddc-i2c-bus = <&hdmi_ddc>;
+			nvidia,hpd-gpio = <&gpio TEGRA_GPIO(N, 7)
+					   GPIO_ACTIVE_HIGH>;
+		};
+	};
+
 	serial@70006300 {
 		status = "okay";
 	};
@@ -740,6 +753,10 @@
 		};
 	};
 
+	hdmi_ddc: i2c@7000c700 {
+		status = "okay";
+	};
+
 	i2c@7000d000 {
 		status = "okay";
 		clock-frequency = <400000>;
-- 
1.8.1.5

