Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbaHZMOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:14:08 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15570 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaHZMN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:13:57 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-0e-53fc7a02160d
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 7/7] ARM: DTS: exynos4412-odroid*: enable MFC device
Date: Tue, 26 Aug 2014 14:09:48 +0200
Message-id: <1409054988-32758-8-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1409054988-32758-1-git-send-email-m.szyprowski@samsung.com>
References: <1409054988-32758-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/xa7pMVX+CDTp+iVn8nXSM3eLAnx2M
	Fiu7m9ksdq57x2hxtukNu8X2zhnsFl+uPGSy2PT4GqvF5V1z2Cx6NmxltZhxfh+Txdojd9kt
	FhxvYbVYP+M1iwOfx+9fkxg9Lvf1Mnl0vb3C5HHn2h42j81L6j1u/3vM7LHuzysmj74tqxg9
	Pm+SC+CM4rJJSc3JLEst0rdL4MqYdmMaY0E/V8X5NYeZGhhncnQxcnJICJhITJu9kR3CFpO4
	cG89WxcjF4eQwFJGia0bJ7BDOH1MEnOWzmQEqWITMJToetvFBmKLCGRL/Pg2mQXEZhZYyiwx
	b5ZUFyMHh7CAi8SdZi6QMIuAqsSR6y1MIDavgIfEksbDrBDL5CT+v1zBBFLOKeApcW5KNUhY
	CKhk4/T3LBMYeRcwMqxiFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECAnfrzsYlx6zOsQowMGo
	xMP7IO13sBBrYllxZe4hRgkOZiUR3h9Jf4KFeFMSK6tSi/Lji0pzUosPMTJxcEo1MMaYyBsZ
	f5glfv92okDJjRx3ZePX/lHefAeirodFSqod+q/ItlpskwWT2xdb0VuyFy7sWL7/SbGG9tPb
	y6zKFS4fe/WOwVBjedB+pqRTTy2eH+Jarirf8Ok6x+qH3n38JbMkw6pOu+TOiNyqWWQksdPL
	5bXwq2qRu11Z0yIfz1aRvfqm6NSjv0osxRmJhlrMRcWJAM0aEiM9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable support for Multimedia Codec (MFC) device for all Exynos4412-based
Odroid boards.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
index adadaf97ac01..3728c667e7ec 100644
--- a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
+++ b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
@@ -11,6 +11,24 @@
 #include "exynos4412.dtsi"
 
 / {
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@77000000 {
+			compatible = "shared-dma-pool";
+			reusable;
+			reg = <0x77000000 0x1000000>;
+		};
+
+		mfc_right: region@78000000 {
+			compatible = "shared-dma-pool";
+			reusable;
+			reg = <0x78000000 0x1000000>;
+		};
+	};
+
 	firmware@0204F000 {
 		compatible = "samsung,secure-firmware";
 		reg = <0x0204F000 0x1000>;
@@ -367,6 +385,12 @@
 	ehci: ehci@12580000 {
 		status = "okay";
 	};
+
+	codec@13400000 {
+		status = "okay";
+		memory-region = <&mfc_left>, <&mfc_right>;
+		memory-region-names = "left", "right";
+	};
 };
 
 &pinctrl_1 {
-- 
1.9.2

