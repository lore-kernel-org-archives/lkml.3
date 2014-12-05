Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaLEQrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:47:06 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30166 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaLEQql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:46:41 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-07-5481e16e89b5
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC 3/3] ARM: dts: Add devfreq to Exynos3250 and Rinato board
Date: Fri, 05 Dec 2014 17:46:28 +0100
Message-id: <1417797988-29225-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417797988-29225-1-git-send-email-k.kozlowski@samsung.com>
References: <1417797988-29225-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t/xa7p5DxtDDA6tUbDYOGM9q8X1L89Z
	LeYfOcdq8fqFoUX/49fMFmeb3rBbbHp8jdXi8q45bBafe48wWsw4v4/J4vZlXou1R+6yW9xu
	XMFmsWrXH0YHPo+W5h42j52z7rJ7bFrVyeaxeUm9R9+WVYwenzfJBbBFcdmkpOZklqUW6dsl
	cGUc3raarWC+QMW8u99YGxi7ebsYOTkkBEwk5k7dzwxhi0lcuLeerYuRi0NIYCmjRM/9a2AJ
	IYE+Jolbs+VAbDYBY4nNy5eAFYkIvGSSaNnWzwjiMAvsZ5Ro2fSNBaRKWMBd4u2FHawgNouA
	qsTvy88YQWxeoPjFL8tYINbJSZw8NhmshlPAQ6JzznagbRxA29wlWhrTJzDyLmBkWMUomlqa
	XFCclJ5rpFecmFtcmpeul5yfu4kREqBfdzAuPWZ1iFGAg1GJh/dHXGOIEGtiWXFl7iFGCQ5m
	JRHe5NlAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzrE97+zblwJHRiST7boXWeGeohj81Cuw9u
	3WfOzsjfpHHM+JxD3elZh2Y+W1UovGCFtImAeNrx4/z9X44FT5DtkXm13ipmohLzNmN2T1M1
	/uJloRlCrzYxO5692eXp82kFY6Ni4R6rOWt8Txb08srPeHfzfoT1k9qWoBmrYqJ8lzzO3hHa
	OFGJpTgj0VCLuag4EQAgv9/xLgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devfreq to Exynos3250 common file and enable it for Rinato board.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 10 ++++++++++
 arch/arm/boot/dts/exynos3250.dtsi       | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 80aa8b4c4a3d..713b6a5c3f85 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -527,6 +527,16 @@
 	clock-frequency = <24000000>;
 };
 
+&busfreq_mif {
+	vdd_mif-supply = <&buck1_reg>;
+	status = "okay";
+};
+
+&busfreq_int {
+	vdd_int-supply = <&buck3_reg>;
+	status = "okay";
+};
+
 &pinctrl_0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&sleep0>;
diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 22465494b796..8f8d674a8748 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -175,6 +175,38 @@
 			#clock-cells = <1>;
 		};
 
+		busfreq_mif: busfreq@106A0000 {
+			compatible = "samsung,exynos3250-busfreq-mif";
+			reg = <0x106A0000 0x2000>, <0x106B0000 0x2000>;
+			clocks = <&cmu_dmc CLK_DIV_DMC>;
+			clock-names = "dmc";
+			status = "disabled";
+		};
+
+		busfreq_int: busfreq@116A0000 {
+			compatible = "samsung,exynos3250-busfreq-int";
+			reg = <0x116A0000 0x2000>, <0x112A0000 0x2000>;
+			clocks = <&cmu CLK_PPMULEFT>,
+				<&cmu CLK_PPMURIGHT>,
+				<&cmu CLK_DIV_ACLK_400_MCUISP>,
+				<&cmu CLK_DIV_ACLK_266>,
+				<&cmu CLK_DIV_ACLK_200>,
+				<&cmu CLK_DIV_ACLK_160>,
+				<&cmu CLK_DIV_GDL>,
+				<&cmu CLK_DIV_GDR>,
+				<&cmu CLK_DIV_MFC>;
+			clock-names = "ppmu_left",
+				"ppmu_right",
+				"aclk_400",
+				"aclk_266",
+				"aclk_200",
+				"aclk_160",
+				"aclk_gdl",
+				"aclk_gdr",
+				"mfc";
+			status = "disabled";
+		};
+
 		rtc: rtc@10070000 {
 			compatible = "samsung,exynos3250-rtc";
 			reg = <0x10070000 0x100>;
-- 
1.9.1

