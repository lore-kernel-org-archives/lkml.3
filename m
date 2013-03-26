Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab3CZLfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 07:35:17 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53281 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932951Ab3CZLfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 07:35:04 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 9/9] ARM: dts: Add device tree node for exynos5440 TMU controller
Date: Tue, 26 Mar 2013 17:04:02 +0530
Message-Id: <1364297642-2746-10-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1364297642-2746-1-git-send-email-amit.daniel@samsung.com>
References: <1364297642-2746-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device node for TMU controller. There are 3
instances of the controllers so 3 nodes are created.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/boot/dts/exynos5440.dtsi |   43 +++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index 5f3562a..b74ce9f 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -16,6 +16,12 @@
 
 	interrupt-parent = <&gic>;
 
+	aliases {
+		tmuctrl0 = &tmuctrl_0;
+		tmuctrl1 = &tmuctrl_1;
+		tmuctrl2 = &tmuctrl_2;
+	};
+
 	gic:interrupt-controller@2E0000 {
 		compatible = "arm,cortex-a15-gic";
 		#interrupt-cells = <3>;
@@ -156,4 +162,41 @@
 		reg = <0x130000 0x1000>;
 		interrupts = <0 17 0>, <0 16 0>;
 	};
+
+	tmu_ctrl_info: tmu-ctrl-info {
+		gain = <5>;
+		reference-voltage = <16>;
+		noise-cancel-mode = <4>;
+		cal-type = <2>;
+		cal-mode = <0>;
+		efuse-value = <0x5b2c>;
+		threshold-falling = <5>;
+	};
+
+	tmuctrl_0: tmuctrl@160118 {
+		compatible = "samsung,exynos5440-tmu";
+		reg = <0x160118 0x300>;
+		interrupts = <0 58 0>;
+		clocks = <&clock 8>;
+		clock-names = "tmu_apbif";
+		tmu-ctrl-data = <&tmu_ctrl_info>;
+	};
+
+	tmuctrl_1: tmuctrl@16011C {
+		compatible = "samsung,exynos5440-tmu";
+		reg = <0x16011C 0x300>;
+		interrupts = <0 58 0>;
+		clocks = <&clock 8>;
+		clock-names = "tmu_apbif";
+		tmu-ctrl-data = <&tmu_ctrl_info>;
+	};
+
+	tmuctrl_2: tmuctrl@160120 {
+		compatible = "samsung,exynos5440-tmu";
+		reg = <0x160120 0x300>;
+		interrupts = <0 58 0>;
+		clocks = <&clock 8>;
+		clock-names = "tmu_apbif";
+		tmu-ctrl-data = <&tmu_ctrl_info>;
+	};
 };
-- 
1.7.1

