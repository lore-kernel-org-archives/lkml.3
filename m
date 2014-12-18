Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaLRKN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:13:56 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36396 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaLRKNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:13:53 -0500
X-AuditID: cbfee61a-f79c06d000004e71-52-5492a8ded71c
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
Subject: [PATCH 2/9] hwmon: dts: Doc: Add DTS doc to explain how to use PWM FAN
 as a cooling device
Date: Thu, 18 Dec 2014 11:13:04 +0100
Message-id: <1418897591-18332-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jQd17KyaFGMxbZWox/8g5Vov5V66x
	Wiy9+4nN4sfrC2wWvQuuslm8ecRt8ebhZkaLy7vmsFl87j3CaDHj/D4miycLzzBZ3Jm2l83i
	8Jt2Vgdej52z7rJ7PJi4m81j3bS3zB47vzewe/RtWcXosfl0tcfnTXIB7FFcNimpOZllqUX6
	dglcGZPbVzIVPOOtWLd+NVMD4wuuLkYODgkBE4lpty27GDmBTDGJC/fWs3UxcnEICUxnlNj8
	ZSYjSEJIoItJ4uYhNxCbTUBP4vPdp0wgRSICMxgl9jd9YwdxmAW+M0k0bV3KAlIlLJAq8e3b
	eWaQDSwCqhJzfpuBhHkF3CR+3r/EDrFNUaL72QQ2EJtTwF1iznMIWwiopunvJeYJjLwLGBlW
	MYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQH6DOpHYwrGywOMQpwMCrx8EroTQoRYk0sK67M
	PcQowcGsJMIbnQMU4k1JrKxKLcqPLyrNSS0+xCjNwaIkzqtk3xYiJJCeWJKanZpakFoEk2Xi
	4JRqYPQ5nmMqk3Rq6kS/+C1nbkoHVc2vm5hRuDhP2vLn21dPNC5m+e4XbX0sd7HddsPu8JVP
	Vzi/jHxb3pqk+7/vYS7PgocrViy7mX7/hNu8eUpGp45v+nlyA5vnjsMPv697Plv0ldqyC+o2
	wRYpkhk+cQaRZ/k9NtaZeTya/TRf4ELxWY5tpz91MzkpsRRnJBpqMRcVJwIAcN+70EwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several new properties to allow PWM fan working as a cooling device have been
combined into this single commit.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 .../devicetree/bindings/hwmon/pwm-fan.txt          | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
index 610757c..3877810 100644
--- a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
+++ b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
@@ -3,10 +3,38 @@ Bindings for a fan connected to the PWM lines
 Required properties:
 - compatible	: "pwm-fan"
 - pwms		: the PWM that is used to control the PWM fan
+- cooling-pwm-values      : PWM duty cycle values relative to
+			    cooling-max-pwm-value correspondig to
+			    proper cooling states
+- default-pulse-width     : Property specifying default pulse width for FAN
+			    at system boot (zero to disable FAN on boot).
+			    Allowed range is 0 to 255
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
+		cooling-pwm-values = <0 102 170 255>;
+		default-pulse-width = <0>;
 	};
-- 
2.0.0.rc2

