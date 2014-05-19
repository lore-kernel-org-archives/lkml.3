Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaESJYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:24:47 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5161 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaESJYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:24:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 19 May 2014 02:18:44 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 5/5] ARM: tegra: jetson-tk1: enable GK20A GPU
Date: Mon, 19 May 2014 18:24:10 +0900
Message-ID: <1400491450-19223-6-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400491450-19223-1-git-send-email-acourbot@nvidia.com>
References: <1400491450-19223-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/boot/dts/tegra124-jetson-tk1.dts | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index e31fb61a81d3..15a194d1277f 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -30,6 +30,12 @@
 		};
 	};
 
+	gpu@0,57000000 {
+		status = "okay";
+
+		vdd-supply = <&vdd_gpu>;
+	};
+
 	pinmux: pinmux@0,70000868 {
 		pinctrl-names = "default";
 		pinctrl-0 = <&state_default>;
@@ -1505,7 +1511,7 @@
 					regulator-always-on;
 				};
 
-				sd6 {
+				vdd_gpu: sd6 {
 					regulator-name = "+VDD_GPU_AP";
 					regulator-min-microvolt = <650000>;
 					regulator-max-microvolt = <1200000>;
-- 
1.9.2

