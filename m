Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaA2Raq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:30:46 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39150 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbaA2RaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:30:15 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-77-52e93aa6277e
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, k.debski@samsung.com,
        tjakobi@math.uni-bielefeld.de, stern@rowland.harvard.edu
Subject: [PATCH v6 4/8] dts: Add usb2phy to Exynos 5250
Date: Wed, 29 Jan 2014 18:29:30 +0100
Message-id: <1391016574-25237-5-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1391016574-25237-1-git-send-email-k.debski@samsung.com>
References: <1391016574-25237-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jAd1lVi+DDLZMErNYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i8sJLrBY/Xl9gs7jwtIfN4mzTG6DYrjlsFjPO72OyWLSsldli7ZG77BZn
	+2+zWUxsmsZucX5LJ5PF4TftrBYTfgO1rZ/xmsWibfUHVouOswfZHUQ8Lvf1MnnsnHWX3ePO
	tT1sHv+OsXvMvvuD0aNvyypGj+M3tjN5fN4kF8ARxWWTkpqTWZZapG+XwJXx4s9XxoL93BWn
	1j9kbWD8w9HFyMkhIWAicX/BI0YIW0ziwr31bF2MXBxCAosYJZ483MQM4XQwSVy+9om1i5GD
	g01AU2LVPQ+QBhGBGokpt66wg9QwC3QxS0zYdpoNJCEsYC5xf3U/K4jNIqAqsXbCbWYQm1fA
	ReL6k4VsIHMkBBQk5kyyAQlzCrhKdMy4CNYqBFSyumcN2wRG3gWMDKsYRVMLkguKk9JzjfSK
	E3OLS/PS9ZLzczcxgkP+mfQOxlUNFocYBTgYlXh4V1x8HiTEmlhWXJl7iFGCg1lJhDfK8GWQ
	EG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBka5J090co/W
	eBQUWkgeDmlzdQt49tX8E5PS20VrZ2Z9sthmHiu9/X7QzH/Ov++8zn/g6Fh7ZaHsZMkw1zo2
	46SQP4bLdF6Lhq1UCP4w9Yxr/6ctvi1704t4dnQEc6QW7TuTZH7Rrn8ra2L106qSWLEz0xvu
	HBO4u86qev9hnTQF59CCLb5fZJVYijMSDbWYi4oTAQT6bX11AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to PHY of USB2 of the Exynos 5250 SoC.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index c4480a1..efeaf87 100644
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
+			phys = <&usb2_phy_new 1>;
+			phy-names = "host";
+			status = "ok";
+		};
 	};
 
 	usb@12120000 {
@@ -531,6 +544,17 @@
 		};
 	};
 
+	usb2_phy_new: phy@12130000 {
+		compatible = "samsung,exynos5250-usb2-phy";
+		reg = <0x12130000 0x100>;
+		clocks = <&clock 285>, <&clock 1>, <&clock 1>, <&clock 1>,
+								<&clock 1>;
+		clock-names = "phy", "device", "host", "hsic0", "hsic1";
+		#phy-cells = <1>;
+		samsung,sysreg-phandle = <&sys_syscon>;
+		samsung,pmureg-phandle = <&pmu_syscon>;
+	};
+
 	amba {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.7.9.5

