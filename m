Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaLRKOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:14:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36430 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaLRKOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:14:04 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-de-5492a8ea1829
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>,
        Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/9] ARM: dts: Add pwm-fan node to the Odroid-U3 board
Date: Thu, 18 Dec 2014 11:13:05 +0100
Message-id: <1418897591-18332-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t9jQd1XKyaFGJxqk7CYf+Qcq8X8K9dY
	LZbe/cRm8eP1BTaL3gVX2SzePOK2uLxrDpvF594jjBYzzu9jsniy8AyTxZ1pe9ksDr9pZ3Xg
	8dg56y67x4OJu9k81k17y+yx83sDu0ffllWMHptPV3t83iQXwB7FZZOSmpNZllqkb5fAlfH1
	6UHmgp28FZ8e9zE3MH7k6mLk5JAQMJE4t/cjG4QtJnHh3nogm4tDSGA6o8T0lyvYIZwuJok9
	y+YzglSxCehJfL77lAkkISIwg1Fif9M3sCpmgdNMEk8mP2UHqRIWcJN4+f8TE4jNIqAqsa65
	gxXE5gWK7+/9wgSxT1Gi+9kEsN2cAu4Sc55D2EJANU1/LzFPYORdwMiwilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyM4OJ9J72Bc1WBxiFGAg1GJh1dCb1KIEGtiWXFl7iFGCQ5mJRHe6Byg
	EG9KYmVValF+fFFpTmrxIUZpDhYlcV4l+7YQIYH0xJLU7NTUgtQimCwTB6dUA6Nr6NN8p7Mn
	nDRUrnTMW9y8jrv+aciEzfu5K/3X1zqviDnBlG6TLPfzbd6dvN2HptYocjlLH3eazvvUsqpQ
	4rR/T1a2TcTnHuU/Dya519k+eCQsFzzLT6XmSN3s1f0KIlvln5zctvNXpbNpE+Pzvn+7OLPO
	Fr7VV7y4rVK170POn2cCTRv+ZCixFGckGmoxFxUnAgDzQRGeSgIAAA==
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

