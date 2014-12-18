Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaLRKOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:14:23 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21532 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaLRKOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:14:19 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-23-5492a8f886cc
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
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH 4/9] hwmon: thermal: dts: Add properties to use pwm-fan device
 as a cooling device in Odroid U3
Date: Thu, 18 Dec 2014 11:13:06 +0100
Message-id: <1418897591-18332-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jQd0fKyaFGNyermMx/8g5Vov5V66x
	Wiy9+4nN4sfrC2wWvQuuslm8ecRt8ebhZkaLy7vmsFl87j3CaDHj/D4miycLzzBZ3Jm2l83i
	8Jt2Vgdej52z7rJ7PJi4m81j3bS3zB47vzewe/RtWcXosfl0tcfnTXIB7FFcNimpOZllqUX6
	dglcGevPeRR0c1ecfreaqYGxkaOLkZNDQsBEYvn7S8wQtpjEhXvr2boYuTiEBKYzSqx7dpcF
	wulikvh4bCkbSBWbgJ7E57tPmUASIgIzGCX2N31jB3GYBb4zSTRtXcoCUiUsUChxquE9WAeL
	gKrElj3N7CA2r4CbxIrFX6H2KUp0P5sAVsMp4C4x5zmELQRU0/T3EvMERt4FjAyrGEVTC5IL
	ipPSc430ihNzi0vz0vWS83M3MYKD9Jn0DsZVDRaHGAU4GJV4eCX0JoUIsSaWFVfmHmKU4GBW
	EuGNzgEK8aYkVlalFuXHF5XmpBYfYpTmYFES51WybwsREkhPLEnNTk0tSC2CyTJxcEo1MEqE
	rFt0kevhAkeP5kv6u2xvhf7tKOK6mcLAdtflw8ntUaYFuwW1XqUvTNiWIG0vEm4smW8tpebR
	MPHTlCfd4tpLnyyRrn0h8So/+MvrpQzqwsuaXTO6Tj7SMLZzuPjTm23uPRupZ3PX7z0eJPsx
	dP3+3x+EfExmXMnguKE8v/mm29vJetPcbZRYijMSDbWYi4oTAVOgEWVOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With those bindings it is possible to use pwm-fan device available at
Odroid U3 as a cooling device.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-odroidu3.dts | 33 ++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dts/exynos4412-odroidu3.dts
index 60bd1e4..cc50e96 100644
--- a/arch/arm/boot/dts/exynos4412-odroidu3.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidu3.dts
@@ -32,11 +32,42 @@
 		};
 	};
 
-	pwm-fan {
+	fan0: pwm-fan {
 		compatible = "pwm-fan";
 		pwms = <&pwm 0 10000 0>;
+		cooling-min-state = <0>;
+		cooling-max-state = <3>;
+		#cooling-cells = <2>;
+		cooling-pwm-values = <0 102 170 255>;
 		status = "okay";
 	};
+
+	thermal-zones {
+		cpu_thermal: cpu-thermal {
+			cooling-maps {
+				map0 {
+				     trip = <&cpu_alert1>;
+				     cooling-device = <&cpu0 7 7>;
+				};
+				map1 {
+				     trip = <&cpu_alert2>;
+				     cooling-device = <&cpu0 13 13>;
+				};
+				map2 {
+				     trip = <&cpu_alert0>;
+				     cooling-device = <&fan0 0 1>;
+				};
+				map3 {
+				     trip = <&cpu_alert1>;
+				     cooling-device = <&fan0 1 2>;
+				};
+				map4 {
+				     trip = <&cpu_alert2>;
+				     cooling-device = <&fan0 2 3>;
+				};
+			};
+		};
+	};
 };
 
 &pwm {
-- 
2.0.0.rc2

