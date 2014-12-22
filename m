Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbaLVQ25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:28:57 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53647 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbaLVQ2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:28:49 -0500
X-AuditID: cbfee61a-f79c06d000004e71-94-549846bf6e7e
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
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH v2 5/8] hwmon: thermal: dts: Add properties to use pwm-fan
 device as a cooling device in Odroid U3
Date: Mon, 22 Dec 2014 17:27:45 +0100
Message-id: <1419265668-32283-6-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jAd39bjNCDHqvKlk8XrOYyWL+kXOs
	FvOvXGO1WHr3E5vFj9cX2CzW/FWy6F1wlc3izSNuizcPNzNaXN41h83ic+8RRosZ5/cxWTxZ
	eIbJ4s60vWwWh9+0szrwe+ycdZfd48HE3Wwe66a9ZfbY+b2B3aNvyypGj82nqz0+b5ILYI/i
	sklJzcksSy3St0vgyvjwNrTgKnfFhPYHjA2M+zi6GDk5JARMJD4eX80MYYtJXLi3nq2LkYtD
	SGARo0Tjo6+sEE4Xk8TiCedZQarYBPQkPt99ygSSEBGYwSixv+kbO4jDLHCFWeLbqUYWkCph
	gRKJ6Z1PGEFsFgFVicf/TrOB2LwCbhKXu5+wQ+xTlOh+NgEozsHBKeAu8fsVL8S2ZkaJUwsa
	mScw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERy2z6R2MK5ssDjEKMDBqMTDy5E2
	PUSINbGsuDL3EKMEB7OSCO9VyxkhQrwpiZVVqUX58UWlOanFhxilOViUxHmV7NtChATSE0tS
	s1NTC1KLYLJMHJxSDYwXPCe5Jqad+3pl5m3rc8zVFgH2V7oa/sydK8l9eHZIxDypewuZd9/q
	C7Zl/JkR2cX3WfGxzpKbe724N32buua1bObV9V6/XL8eZ3zIwm2zn1NT4qHWVwebWl/b6/aP
	pFl2Caza5LhLOathHttFlR7/H2/mNDM9/qf6h+tuesoPE9WNs/J3v9usxFKckWioxVxUnAgA
	F2CaGVcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With those bindings it is possible to use pwm-fan device available in
Odroid U3 as a cooling device.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
Changes for v2:
- Rename cooling-pwm-values property to cooling-levels
---
 arch/arm/boot/dts/exynos4412-odroidu3.dts | 33 ++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dts/exynos4412-odroidu3.dts
index 60bd1e4..380035d 100644
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
+		cooling-levels = <0 102 170 255>;
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

