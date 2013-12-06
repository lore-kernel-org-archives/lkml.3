Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab3LFKen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 05:34:43 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:48336 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803Ab3LFKek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 05:34:40 -0500
X-AuditID: cbfee61b-b7f006d000003e1f-03-52a1a83a0024
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, k.debski@samsung.com
Subject: [PATCH 9/9] dts: Add usb2phy to Exynos 5250
Date: Fri, 06 Dec 2013 11:34:18 +0100
Message-id: <1386326058-27403-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t9jQV3rFQuDDNbeZ7dYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i8sJLrBY/Xl9gs7jwtIfN4mzTG6DYrjlsFjPO72OyWLSsldli7ZG77BZn
	+2+zWUxsmsZucX5LJ5PF4TftrBbrZ7xmseg4e5DdQcjjcl8vk8fOWXfZPe5c28Pm0bdlFaPH
	8RvbmTw+b5ILYIvisklJzcksSy3St0vgyvj07CV7wQ6+iuXb37E1MK7k7mLk4JAQMJF4etW4
	i5ETyBSTuHBvPVsXIxeHkMB0Romu94fZQBJCAh1MEg9uFoHUswloSqy65wESFhGokZhy6wo7
	iM0scI5J4uZCZhBbGGjkmY4XLCA2i4CqxO0nlxlBWnkFXCS29HhBbFWQmDPJBqSCU8BVYuVE
	kEUcQItcJNZc0ZzAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAIP5PewbiqweIQ
	owAHoxIPL8eqBUFCrIllxZW5hxglOJiVRHhtli8MEuJNSaysSi3Kjy8qzUktPsQozcGiJM57
	sNU6UEggPbEkNTs1tSC1CCbLxMEp1cC4UHsqg7nX4ie5LuaSNetvGq0K6bE5/2v/wj1Vcfzz
	1r4+sGz3dI1rons2BeZx2hT0zRFnWX5KsyklL/igb/XGI3w617m+aD3JlmWxeRUZ6jx9Sur3
	cDnrDO13O8sLVogzJPKlR8q8UtzJ+tFBX0kvt+Pt3J9lyXd8N3WYHvkjsfrVgqx68XAlluKM
	REMt5qLiRAAWSjyBXQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support of new USB 2.0 phy driver to the Exynos 5250 SoC device tree.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 2f264ad..922e0ed 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -163,6 +163,11 @@
 		interrupts = <0 47 0>;
 	};
 
+	sys_syscon: syscon@10040000 {
+		compatible = "samsung,exynos5250-sys", "syscon";
+		reg = <0x10050000 0x5000>;
+	};
+
 	pmu_syscon: syscon@10040000 {
 		compatible = "samsung,exynos5250-pmu", "syscon";
 		reg = <0x10040000 0x5000>;
@@ -505,6 +510,14 @@
 
 		clocks = <&clock 285>;
 		clock-names = "usbhost";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		port@0 {
+			reg = <0>;
+			phys = <&usb2_phy 1>;
+			phy-names = "host";
+			status = "ok";
+		};
 	};
 
 	usb@12120000 {
@@ -516,19 +529,15 @@
 		clock-names = "usbhost";
 	};
 
-	usb2_phy: usbphy@12130000 {
-		compatible = "samsung,exynos5250-usb2phy";
+	usb2_phy: phy@12130000 {
+		compatible = "samsung,exynos5250-usb2-phy";
 		reg = <0x12130000 0x100>;
-		clocks = <&clock 1>, <&clock 285>;
-		clock-names = "ext_xtal", "usbhost";
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		usbphy-sys {
-			reg = <0x10040704 0x8>,
-			      <0x10050230 0x4>;
-		};
+		clocks = <&clock 285>, <&clock 1>, <&clock 1>, <&clock 1>,
+								<&clock 1>;
+		clock-names = "phy", "device", "host", "hsic0", "hsic1";
+		#phy-cells = <1>;
+		samsung,sysreg-phandle = <&sys_syscon>;
+		samsung,pmureg-phandle = <&pmu_syscon>;
 	};
 
 	amba {
-- 
1.7.9.5

