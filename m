Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaJIGM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 02:12:28 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15495 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaJIGMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 02:12:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 08 Oct 2014 23:12:01 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/2] ARM: tegra: jetson-tk1: add GK20A GPU DT node
Date: Thu, 9 Oct 2014 15:11:52 +0900
Message-ID: <1412835112-7209-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1412835112-7209-1-git-send-email-acourbot@nvidia.com>
References: <1412835112-7209-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device-tree node for the GK20A GPU and leave it disabled by
default. It is the responsability of the bootloader to enable it if the
VPR registers have been programmed such as the GPU can operate.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/boot/dts/tegra124-jetson-tk1.dts | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index 029c9a021541..6f84c7e231a0 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -50,6 +50,12 @@
 		};
 	};
 
+	gpu@0,57000000 {
+		status = "disabled";
+
+		vdd-supply = <&vdd_gpu>;
+	};
+
 	pinmux: pinmux@0,70000868 {
 		pinctrl-names = "boot";
 		pinctrl-0 = <&state_boot>;
@@ -1560,7 +1566,7 @@
 					regulator-always-on;
 				};
 
-				sd6 {
+				vdd_gpu: sd6 {
 					regulator-name = "+VDD_GPU_AP";
 					regulator-min-microvolt = <650000>;
 					regulator-max-microvolt = <1200000>;
-- 
2.1.2

