Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaKCOnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:43:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15518 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaKCOnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:43:41 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-90-5457949ba6e9
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] ARM: dts: Add pwm-fan node to the Odroid-U3 board
Date: Mon, 03 Nov 2014 15:43:24 +0100
Message-id: <1415025804-24274-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJMWRmVeSWpSXmKPExsVy+t9jAd3ZU8JDDI5eNbH48foCm0Xvgqts
	Fpd3zWGzmHF+H5MDi0ffllWMHp83yQUwRXHZpKTmZJalFunbJXBl9Oy+wFZwmK1i1uzJLA2M
	C1m7GDk4JARMJOa89e9i5AQyxSQu3FvP1sXIxSEksIhR4taWZiYIp4NJ4s3ZRhaQBjYBTYlV
	9zxAGkQEnCVuf/jGAmIzC9hJHG9dzwxiCws4STw4fJURxGYRUJXYtagDzOYVcJG49fYsI8Re
	BYk5k2wmMHIvYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRHs5WfSOxhXNVgcYhTgYFTi
	4S3YHhYixJpYVlyZe4hRgoNZSYT3X0p4iBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeg63WgUIC
	6YklqdmpqQWpRTBZJg5OqQZGuz0dN77IWE5gVZgte37Gf7Ps66KTA5bxxMgdnyh6VO8B3x/W
	ew12si8E1qXbhejcXFefNMH47VTGe2yGfJxb5Q5Kfa1Mv25aedlC49XGdAUO2c3Mt5OcuJfN
	fP20dIfu5AzRE39VjoXOa9ETnZfF+MKuy2Kv1jLTXxVlhQtnyeS+dfgk1FCoxFKckWioxVxU
	nAgAvhNKOO4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pwm-fan node to the Odroid-U3 board file to enable PWM control of the
cooling fan.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-odroidu3.dts |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dts/exynos4412-odroidu3.dts
index c8a64be..764bda4 100644
--- a/arch/arm/boot/dts/exynos4412-odroidu3.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidu3.dts
@@ -31,6 +31,19 @@
 			linux,default-trigger = "heartbeat";
 		};
 	};
+
+	pwm: pwm@139D0000 {
+		pinctrl-0 = <&pwm0_out>;
+		pinctrl-names = "default";
+		samsung,pwm-outputs = <0>;
+		status = "okay";
+	};
+
+	pwm-fan {
+		compatible = "pwm-fan";
+		status = "okay";
+		pwms = <&pwm 0 10000 0>;
+	};
 };
 
 &usb3503 {
-- 
1.7.9.5

