Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab3EGNDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:03:20 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:32880 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab3EGNDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:03:17 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V3 21/21] ARM: dts: Add device tree node for exynos5440 TMU controller
Date: Tue,  7 May 2013 18:31:11 +0530
Message-Id: <1367931671-3906-22-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device node for TMU controller. There are 3
instances of the controllers so 3 nodes are created.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/boot/dts/exynos5440.dtsi |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index 9a99755..433e92e 100644
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
@@ -162,4 +168,28 @@
 		reg = <0x130000 0x1000>;
 		interrupts = <0 17 0>, <0 16 0>;
 	};
+
+	tmuctrl_0: tmuctrl@160118 {
+		compatible = "samsung,exynos5440-tmu";
+		reg = <0x160118 0x230>, <0x160368 0x10>;
+		interrupts = <0 58 0>;
+		clocks = <&clock 21>;
+		clock-names = "tmu_apbif";
+	};
+
+	tmuctrl_1: tmuctrl@16011C {
+		compatible = "samsung,exynos5440-tmu";
+		reg = <0x16011C 0x230>, <0x160368 0x10>;
+		interrupts = <0 58 0>;
+		clocks = <&clock 21>;
+		clock-names = "tmu_apbif";
+	};
+
+	tmuctrl_2: tmuctrl@160120 {
+		compatible = "samsung,exynos5440-tmu";
+		reg = <0x160120 0x230>, <0x160368 0x10>;
+		interrupts = <0 58 0>;
+		clocks = <&clock 21>;
+		clock-names = "tmu_apbif";
+	};
 };
-- 
1.7.1

