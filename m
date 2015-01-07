Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751039AbbAGJur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:50:47 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55886 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbbAGJul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:50:41 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-0a-54ad016e70fb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: dts: exynos4412-trats2: Add Maxim 77693 fuel gauge node
Date: Wed, 07 Jan 2015 10:50:32 +0100
Message-id: <1420624232-31238-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEJMWRmVeSWpSXmKPExsVy+t/xK7p5jGtDDA5cMbSYf+Qcq8XrF4YW
	/Y9fM1tsenyN1eLyrjlsFjPO72NyYPPYtKqTzWPzknqPvi2rGD0+b5ILYInisklJzcksSy3S
	t0vgyjg5bQdrwROeimXHjjE3MK7i6mLk5JAQMJFY2fyaEcIWk7hwbz1bFyMXh5DAUkaJa/8m
	M0I4fUwSvf9nsoJUsQkYS2xevoQNxBYRWMEocbHJEsRmFjCU+PnuDzuILSzgK7H31CUwm0VA
	VWLGkX9gG3gF3CWO7O1ngtgmJ3Hy2GTWCYzcCxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefn
	bmKEhMOXHYyLj1kdYhTgYFTi4S3oWxMixJpYVlyZe4hRgoNZSYT3zS+gEG9KYmVValF+fFFp
	TmrxIUYmDk6pBsbV1TMUdpqv3zG7z3mWwattK2LnX+s4VvRG0zJq38Ld6368PXhYPc6CNz3B
	2Nz+7ORdjUx7ckQ3Pp4dvfz43D1HZr94ts12WYnuPrNe/wb+ZetbrIyeP7v56rbbE89fe52b
	ngU/SmhXeJU7kaPv2Pwjf9lyc6NKbnrVnlr+N8t+gsGNgh5N1tWTlViKMxINtZiLihMBNz/+
	1eUBAAA=
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
index 496a05faca37..7b3e58d781d8 100644
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
@@ -562,6 +564,22 @@
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

