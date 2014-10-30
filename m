Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176AbaJ3NYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:24:16 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:53827 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727AbaJ3NYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:24:13 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanpaul@google.com, ajaykumar.rs@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH v2 2/2] arm: dts: Exynos5: Use pmu_system_controller phandle for dp phy
Date: Thu, 30 Oct 2014 18:54:02 +0530
Message-Id: <1414675442-3471-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414675442-3471-1-git-send-email-gautam.vivek@samsung.com>
References: <1414675442-3471-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DP PHY now require pmu-system-controller to handle PMU register
to control PHY's power isolation. Adding the same to dp-phy
node.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
---

Changes from V1:
 - none.

 arch/arm/boot/dts/exynos5250.dtsi |    2 +-
 arch/arm/boot/dts/exynos5420.dtsi |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 012b021..69f5eb0 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -732,7 +732,7 @@
 
 	dp_phy: video-phy@10040720 {
 		compatible = "samsung,exynos5250-dp-video-phy";
-		reg = <0x10040720 4>;
+		samsung,pmu-syscon = <&pmu_system_controller>;
 		#phy-cells = <0>;
 	};
 
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 8617a03..1353a09 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -503,8 +503,8 @@
 	};
 
 	dp_phy: video-phy@10040728 {
-		compatible = "samsung,exynos5250-dp-video-phy";
-		reg = <0x10040728 4>;
+		compatible = "samsung,exynos5420-dp-video-phy";
+		samsung,pmu-syscon = <&pmu_system_controller>;
 		#phy-cells = <0>;
 	};
 
-- 
1.7.10.4

