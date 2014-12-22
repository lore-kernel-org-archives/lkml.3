Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbaLVQ2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:28:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53637 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaLVQ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:28:44 -0500
X-AuditID: cbfee61a-f79c06d000004e71-90-549846bab59c
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>,
        Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: [PATCH v2 4/8] ARM: dts: Add pwm-fan node to the Odroid-U3 board
Date: Mon, 22 Dec 2014 17:27:44 +0100
Message-id: <1419265668-32283-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jAd1dbjNCDB5eVrJ4vGYxk8X8I+dY
	LeZfucZqsfTuJzaLH68vsFms+atk0bvgKpvFm0fcFpd3zWGz+Nx7hNFixvl9TBZPFp5hsrgz
	bS+bxeE37awOfB47Z91l93gwcTebx7ppb5k9dn5vYPfo27KK0WPz6WqPz5vkAtijuGxSUnMy
	y1KL9O0SuDK+Pj3IXLCTt+LT4z7mBsaPXF2MnBwSAiYSre93sULYYhIX7q1n62Lk4hASWMQo
	0f71CCOE08UkMWfOJGaQKjYBPYnPd58ygSREBGYwSuxv+sYO4jALrGCWmHLjFRNIlbCAp8SU
	y/NYQGwWAVWJl4+egO3gFXCTOLNgDjvEPkWJ7mcTgPZxcHAKuEv8fsULsa2ZUeLUgkbmCYy8
	CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEh+szqR2MKxssDjEKcDAq8fBypE0PEWJN
	LCuuzD3EKMHBrCTCe9VyRogQb0piZVVqUX58UWlOavEhRmkOFiVxXiX7thAhgfTEktTs1NSC
	1CKYLBMHp1QD40xtzTvWXWtvz/+zrDP0M4d4Tm3kgpxZl4/PqSjtPpIfm9P554ZQYsfK0tsZ
	i+f1TXjacTyUcYb1+UMbdO4kXtTdPvWVx35tcwaenA+XWy/GeO+vZj0Z0fNRbJFiHEtWlZyb
	g/5MwQ0m/TpbpHa4/0h5J/CL8beape0smZN/wpNMClPX9h/TVmIpzkg01GIuKk4EAMMNTrtT	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kamil Debski <k.debski@samsung.com>

Add pwm-fan node to the Odroid-U3 board file to enable PWM control of the
cooling fan. In addition, add the "pwm" label to the pwm@139D0000 node
in the exynos4412.dtsi.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
[Rebased on the newest mainline by l.majewski@samsung.com]
---
Changes since v1:
- added pwm label to the pwm@139D0000 node in exynos4.dtsi
- use the pwm label in the exynos4412-odroidu3.dts
- change order or properties in the pwn-fan node, to be sorted
  in alphabetical order

---
 arch/arm/boot/dts/exynos4.dtsi            |  2 +-
 arch/arm/boot/dts/exynos4412-odroidu3.dts | 13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 1735bb3..f227a39 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -583,7 +583,7 @@
 		status = "disabled";
 	};
 
-	pwm@139D0000 {
+	pwm: pwm@139D0000 {
 		compatible = "samsung,exynos4210-pwm";
 		reg = <0x139D0000 0x1000>;
 		interrupts = <0 37 0>, <0 38 0>, <0 39 0>, <0 40 0>, <0 41 0>;
diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dts/exynos4412-odroidu3.dts
index c8a64be..60bd1e4 100644
--- a/arch/arm/boot/dts/exynos4412-odroidu3.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidu3.dts
@@ -31,6 +31,19 @@
 			linux,default-trigger = "heartbeat";
 		};
 	};
+
+	pwm-fan {
+		compatible = "pwm-fan";
+		pwms = <&pwm 0 10000 0>;
+		status = "okay";
+	};
+};
+
+&pwm {
+	pinctrl-0 = <&pwm0_out>;
+	pinctrl-names = "default";
+	samsung,pwm-outputs = <0>;
+	status = "okay";
 };
 
 &usb3503 {
-- 
2.0.0.rc2

