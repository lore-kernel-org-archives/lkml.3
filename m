Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaLVQ2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:28:43 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53627 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaLVQ2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:28:39 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-78-549846b5cafb
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
Subject: [PATCH v2 3/8] hwmon: dts: Doc: Add DTS doc to explain how to use PWM
 FAN as a cooling device
Date: Mon, 22 Dec 2014 17:27:43 +0100
Message-id: <1419265668-32283-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jAd2tbjNCDD62GVg8XrOYyWL+kXOs
	FvOvXGO1WHr3E5vFj9cX2CzW/FWy6F1wlc3izSNuizcPNzNaXN41h83ic+8RRosZ5/cxWTxZ
	eIbJ4s60vWwWh9+0szrwe+ycdZfd48HE3Wwe66a9ZfbY+b2B3aNvyypGj82nqz0+b5ILYI/i
	sklJzcksSy3St0vgyvj/pI29YApvxZtr29kbGHdxdTFyckgImEhcWdLEAmGLSVy4t56ti5GL
	Q0hgEaPEl6fH2EASQgJdTBL/94SC2GwCehKf7z5lAikSEZjBKLG/6Rs7iMMscIVZ4tupRrBR
	wgIZEpd6H7J2MXJwsAioSjw75A8S5hVwk2jfcoYJYpuiRPezCWwgJZwC7hK/X/FCLG5mlDi1
	oJF5AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBQftMegfjqgaLQ4wCHIxKPLyc
	adNDhFgTy4orcw8xSnAwK4nwXrWcESLEm5JYWZValB9fVJqTWnyIUZqDRUmcV8m+LURIID2x
	JDU7NbUgtQgmy8TBKdXAOPnQ349OHfO6lj2e6Vy34nWQnMLmDauO5dnfkwtu2NsVplvkuTvm
	+IXJ2ysWtH/67vXnkOUvgeCdHjGqzpsnvG25fX5pxNzqI4v4/O71Ot/be93vu3ZJoXerhFdt
	SfCxeKPNScKJ/XZ3Ihvm3Fn/sZD9K89ruY+vbVVNcvWV7YtzLZ9etXRtVGIpzkg01GIuKk4E
	AFt32n9WAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several new properties to allow PWM fan working as a cooling device have been
combined into this single commit.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
Changes for v2:
- Rename cooling-pwm-values to cooling-levels
- Remove default-pulse-width property and stick to default hwmon policy
---
 .../devicetree/bindings/hwmon/pwm-fan.txt          | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
index 610757c..001446a 100644
--- a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
+++ b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
@@ -3,10 +3,33 @@ Bindings for a fan connected to the PWM lines
 Required properties:
 - compatible	: "pwm-fan"
 - pwms		: the PWM that is used to control the PWM fan
+- cooling-levels      : PWM duty cycle values in a range from 0 to 255
+			which correspond to thermal cooling states
+
+Thorough description of the following bindings:
+		cooling-min-state = <0>;
+		cooling-max-state = <3>;
+		#cooling-cells = <2>;
+		thermal-zone {
+			cpu_thermal: cpu-thermal {
+			cooling-maps {
+				map0 {
+				     trip = <&cpu_alert1>;
+				     cooling-device = <&fan0 0 1>;
+				};
+			};
+		};
+
+for PWM FAN used as cooling device can be found at:
+./Documentation/devicetree/bindings/thermal/thermal.txt
 
 Example:
 	pwm-fan {
 		compatible = "pwm-fan";
 		status = "okay";
 		pwms = <&pwm 0 10000 0>;
+		cooling-min-state = <0>;
+		cooling-max-state = <3>;
+		#cooling-cells = <2>;
+		cooling-levels = <0 102 170 255>;
 	};
-- 
2.0.0.rc2

