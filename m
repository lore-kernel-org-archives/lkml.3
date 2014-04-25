Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaDYLcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:32:22 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:52095 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaDYLbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:31:39 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, stern@rowland.harvard.edu, kishon@ti.com,
        k.debski@samsung.com, jg1.han@samsung.com, p.paneri@samsung.com
Subject: [PATCH v7 1/2] ARM: dts: Add sysreg sytem controller node to exynos5250 and exynos5420
Date: Fri, 25 Apr 2014 17:01:24 +0530
Message-Id: <1398425485-20574-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398425485-20574-1-git-send-email-gautam.vivek@samsung.com>
References: <1398425485-20574-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds sysreg-syscon node to exynos5250 and exynos5420 device
tree, to access System Register's registers using syscon driver.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
[gautam.vivek@samsung.com: Split this syreg-syscon dts entry from
dts: Add usb2phy to Exynos 5250 patch]
[gautam.vivek@samsung.com: added similar syscon entry for exynos5420]
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |    5 +++++
 arch/arm/boot/dts/exynos5420.dtsi |    5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 3742331..70f0cd5 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -175,6 +175,11 @@
 		reg = <0x10040000 0x5000>;
 	};
 
+	sysreg_system_controller: syscon@10050000 {
+		compatible = "samsung,exynos5250-sys", "syscon";
+		reg = <0x10050000 0x5000>;
+	};
+
 	watchdog@101D0000 {
 		compatible = "samsung,exynos5250-wdt";
 		reg = <0x101D0000 0x100>;
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index c3a9a66..cfa3755 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -675,6 +675,11 @@
 		reg = <0x10040000 0x5000>;
 	};
 
+	sysreg_system_controller: syscon@10050000 {
+		compatible = "samsung,exynos5420-sys", "syscon";
+		reg = <0x10050000 0x5000>;
+	};
+
 	tmu_cpu0: tmu@10060000 {
 		compatible = "samsung,exynos5420-tmu";
 		reg = <0x10060000 0x100>;
-- 
1.7.10.4

