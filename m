Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3JUOTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:19:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49960 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab3JUOTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:19:40 -0400
X-AuditID: cbfee61a-b7f836d0000025d7-3f-526537fb13a9
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, kyungmin.park@samsung.com,
        t.figa@samsung.com, kishon@ti.com, sw0312.kim@samsung.com,
        inki.dae@samsung.com, rahul.sharma@samsung.com, kgene.kim@samsung.com,
        s.nawrocki@samsung.com, thomas.abraham@linaro.org,
        mturquette@linaro.org, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 10/12] arm: dts: exynos4: add i2c controller for HDMIPHY
Date: Mon, 21 Oct 2013 16:18:29 +0200
Message-id: <1382365111-6533-11-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t9jAd3f5qlBBit+m1jMP3KO1eLK1/ds
	FpPuT2Cx6F1wlc3iwtMeNouzTW/YLS7vmsNmMeP8PiaLpxMusllMWXSY1eLwm3ZWixmTX7JZ
	rJ/xmsViXvtLVotjM5YwOvB73Lm2h83jfvdxJo++LasYPY7f2M7k8XmTXABrFJdNSmpOZllq
	kb5dAlfGnm/vGAu2cFR0vpjG0sB4iq2LkYNDQsBEYv45nS5GTiBTTOLCvfVAYS4OIYFFjBIz
	z+9hhHC6mCSOnDrIClLFBtRwbMlnRhBbRCBR4lfzXWaQImaBQ0wSu1umMIMkhAXcJF609rOD
	2CwCqhJ7uv6C2bwCHhKzD01nglgnL/H0fh8biM0JFD/1ci3YUCEBd4l33+axTGDkXcDIsIpR
	NLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOEyfSe1gXNlgcYhRgINRiYc3wCUlSIg1say4MvcQ
	owQHs5IIb5VpapAQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt1oFCAumJJanZqakFqUUwWSYO
	TqkGRufvrwv7FkfsMpkg/UDmpE343oLzwj+cRcobAzq0P5W4SB+LM9m57+RPo0LL39OfXHpi
	vWhdXTD3nMVJmwS0z93eujLs79kPlrtjrtVEC/26oZVQaP3n97zaW3NnPG2yvdp60oZfysb0
	+8UyPd+mJzKfBc3C9z+N/HRh4wQBtT4ZfpaHdwoUjyqxFGckGmoxFxUnAgAvAob1TwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT nodes for I2C controller dedicated for HDMIPHY.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index caadc02..a5f6b8b 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -36,6 +36,7 @@
 		i2c5 = &i2c_5;
 		i2c6 = &i2c_6;
 		i2c7 = &i2c_7;
+		i2c8 = &i2c_8;
 		csis0 = &csis_0;
 		csis1 = &csis_1;
 		fimc0 = &fimc_0;
@@ -399,6 +400,21 @@
 		status = "disabled";
 	};
 
+	i2c_8: i2c@138E0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-hdmiphy-i2c";
+		reg = <0x138E0000 0x100>;
+		interrupts = <0 93 0>;
+		clocks = <&clock 325>;
+		clock-names = "i2c";
+
+		hdmiphy@38 {
+			compatible = "samsung,exynos5-hdmiphy";
+			reg = <0x38>;
+		};
+	};
+
 	spi_0: spi@13920000 {
 		compatible = "samsung,exynos4210-spi";
 		reg = <0x13920000 0x100>;
-- 
1.7.9.5

