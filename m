Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbbAOIly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:41:54 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47411 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbbAOIlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:41:51 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-84-54b77d497008
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/3] ARM: dts: exynos4412-trats2: Add Maxim 77693 fuel gauge
 node
Date: Thu, 15 Jan 2015 09:41:33 +0100
Message-id: <1421311295-18960-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421311295-18960-1-git-send-email-k.kozlowski@samsung.com>
References: <1421311295-18960-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFJMWRmVeSWpSXmKPExsVy+t/xq7qetdtDDC7857WYf+Qcq8XrF4YW
	/Y9fM1tsenyN1eLyrjlsFjPO72NyYPPYtKqTzWPzknqPvi2rGD0+b5ILYInisklJzcksSy3S
	t0vgyjh9bj5zwROeiov7pzA2MK7i6mLk5JAQMJE4M2ETC4QtJnHh3nq2LkYuDiGBpYwSr+Z9
	Y4Jw+pgk7h2YDVbFJmAssXn5EjYQW0RgBaPExSZLEJtZwFDi57s/7CC2sECwxL1DM8BqWARU
	JS6v+MEKYvMKuEusuvaXDWKbnMTJY5PB4pwCHhJ9J6eD9QoB1fQsmcE+gZF3ASPDKkbR1NLk
	guKk9FwjveLE3OLSvHS95PzcTYyQ8Pm6g3HpMatDjAIcjEo8vAx+20OEWBPLiitzDzFKcDAr
	ifB25gCFeFMSK6tSi/Lji0pzUosPMTJxcEo1MObsfuGTvS11VrnkN3mLn8sfTliYvrMoJ79N
	UfZ4leK7iNRfVy91+fgsmuJ94MKvf+qFUWqndyutqJBwY7kXu6Sk6qOenXY20713Ylfe3xBy
	Ydu+L4XPr/T1Rbfq+n5323aJqqI7zGfV+fLfaB//fiBr+s/kKYLzL+3iuq2732t7qGz5igca
	JUosxRmJhlrMRcWJAMT2R3v9AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add node for fuel gauge present in Maxim 77693 PMIC. This allows control
over battery charging state on Trats2 board.

The fuel gauge is compatible with max17042 battery driver (Maxim
17042/17047/17050).  Although datasheet rev 2.2 for MAX77693 describes
fuel gauge as Maxim 17042-like, the chip on Trats2 board identifies
itself as Maxim 17047-like.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 29231b452643..595ad4ba6977 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -15,6 +15,7 @@
 /dts-v1/;
 #include "exynos4412.dtsi"
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/irq.h>
 
 / {
 	model = "Samsung Trats 2 based on Exynos4412";
@@ -24,6 +25,7 @@
 		i2c9 = &i2c_ak8975;
 		i2c10 = &i2c_cm36651;
 		i2c11 = &i2c_max77693;
+		i2c12 = &i2c_max77693_fuel;
 	};
 
 	memory {
@@ -552,6 +554,22 @@
 		};
 	};
 
+	i2c_max77693_fuel: i2c-gpio-3 {
+		compatible = "i2c-gpio";
+		gpios = <&gpf1 5 GPIO_ACTIVE_HIGH>, <&gpf1 4 GPIO_ACTIVE_HIGH>;
+		i2c-gpio,delay-us = <2>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "okay";
+
+		max77693-fuel-gauge@36 {
+			compatible = "maxim,max17047";
+			interrupt-parent = <&gpx2>;
+			interrupts = <3 IRQ_TYPE_EDGE_FALLING>;
+			reg = <0x36>;
+		};
+	};
+
 	mmc@12550000 {
 		num-slots = <1>;
 		broken-cd;
-- 
1.9.1

