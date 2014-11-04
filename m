Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaKDKYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:24:00 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:18229 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaKDKX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:23:57 -0500
X-AuditID: cbfee61a-f79c06d000004e71-d3-5458a93bf245
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, afaerber@suse.de,
        Kamil Debski <k.debski@samsung.com>
Subject: [PATCH v2] ARM: dts: Add pwm-fan node to the Odroid-U3 board
Date: Tue, 04 Nov 2014 11:23:41 +0100
Message-id: <1415096622-20550-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJMWRmVeSWpSXmKPExsVy+t9jQV3rlREhBleniVo0byq2+PH6AptF
	74KrbBaXd81hs5hxfh+TA6tH35ZVjB6bT1d7fN4kF8AcxWWTkpqTWZZapG+XwJXx+exploLp
	vBV9a26zNDCe5epi5OSQEDCR+Hanlw3CFpO4cG89kM3FISQwnVFi29IWVging0niwZWr7F2M
	HBxsApoSq+55gDSICDhL3P7wjQXEZhYIkPg/6wqYLSzgKtG47z8TiM0ioCox++hqRhCbV8BF
	YtuPP0wgYyQEFCTmTLKZwMi9gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkaw359J7WBc
	2WBxiFGAg1GJhzdCMiJEiDWxrLgy9xCjBAezkgjv6iqgEG9KYmVValF+fFFpTmrxIUZpDhYl
	cd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBkanKj0Rg0fLXyt039eYsMpvbWaT70QBkVqX/6Wn
	dy9Ilvm1e4n6u64lDiULl7w12dqqs5bJa5rQI6OFmyUe2Ca8kVDzCd7i5z3ryRyxHx9PBNv+
	XxS2trkgI1NQcN+jLRNT9O+7/160fIIm7/drrN39HvlNJ5v5hPWnCD+TEV/+oUV61bRtb9SV
	WIozEg21mIuKEwFiFJbN9wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pwm-fan node to the Odroid-U3 board file to enable PWM control of the
cooling fan. In addition, add the "pwm" label to the pwm@139D0000 node
in the exynos4412.dtsi.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
Changes since v1:
- added pwm label to the pwm@139D0000 node in exynos4.dtsi
- use the pwm label in the exynos4412-odroidu3.dts
- change order or properties in the pwn-fan node, to be sorted
  in alphabetical order
---
 arch/arm/boot/dts/exynos4.dtsi            |    2 +-
 arch/arm/boot/dts/exynos4412-odroidu3.dts |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index e0278ec..2843b1a 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -582,7 +582,7 @@
 		status = "disabled";
 	};
 
-	pwm@139D0000 {
+	pwm: pwm@139D0000 {
 		compatible = "samsung,exynos4210-pwm";
 		reg = <0x139D0000 0x1000>;
 		interrupts = <0 37 0>, <0 38 0>, <0 39 0>, <0 40 0>, <0 41 0>;
diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dts/exynos4412-odroidu3.dts
index c8a64be..973349b 100644
--- a/arch/arm/boot/dts/exynos4412-odroidu3.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidu3.dts
@@ -31,8 +31,22 @@
 			linux,default-trigger = "heartbeat";
 		};
 	};
+
+	pwm-fan {
+		compatible = "pwm-fan";
+		pwms = <&pwm 0 10000 0>;
+		status = "okay";
+	};
 };
 
+&pwm {
+	pinctrl-0 = <&pwm0_out>;
+	pinctrl-names = "default";
+	samsung,pwm-outputs = <0>;
+	status = "okay";
+};
+
+
 &usb3503 {
 	clock-names = "refclk";
 	clocks = <&pmu_system_controller 0>;
-- 
1.7.9.5

