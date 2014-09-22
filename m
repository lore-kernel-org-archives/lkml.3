Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbaIVR6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:58:48 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4389 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbaIVR6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:58:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 22 Sep 2014 10:58:57 -0700
From: Vidya Sagar <vidyas@nvidia.com>
To: <thierry.reding@gmail.com>, <swarren@wwwdotorg.org>,
        <ldewangan@nvidia.com>
CC: <kthota@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        Vidya Sagar <vidyas@nvidia.com>
Subject: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1 device tree
Date: Mon, 22 Sep 2014 23:27:55 +0530
Message-ID: <1411408675-32315-1-git-send-email-vidyas@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sd4 is an always on regulator which is turned on at boot time.
It is externally controller through gpio. This change
reflects the same in Jetson TK1 device tree

Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
---
 arch/arm/boot/dts/tegra124-jetson-tk1.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index 029c9a02..5c2201a 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -1550,6 +1550,9 @@
 					regulator-name = "+1.05V_RUN";
 					regulator-min-microvolt = <1050000>;
 					regulator-max-microvolt = <1050000>;
+					regulator-always-on;
+					regulator-boot-on;
+					ams,ext-control = <1>;
 				};
 
 				vddio_1v8: sd5 {
-- 
1.8.1.5

