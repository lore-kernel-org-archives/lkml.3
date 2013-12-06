Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161011Ab3LFKds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 05:33:48 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:29453 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab3LFKdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 05:33:46 -0500
X-AuditID: cbfee61a-b7f796d000004313-5f-52a1a809714a
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, k.debski@samsung.com
Subject: [PATCH 8/9] dts: Add usb2phy to Exynos 4
Date: Fri, 06 Dec 2013 11:33:33 +0100
Message-id: <1386326013-27362-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAV3OFQuDDHp+iVss2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDVBs1xw2ixnn9zFZLFrWymyx9shddouz
	/bfZLCY2TWO3OL+lk8ni8Jt2Vov1M16zWHScPcjuIORxua+XyWPnrLvsHneu7WHz6NuyitHj
	+I3tTB6fN8kFsEVx2aSk5mSWpRbp2yVwZUy+952l4JBcRft0xQbGHokuRk4OCQETic7NJ1kh
	bDGJC/fWs3UxcnEICSxilGjaNJUJwulgkrjy7BxzFyMHB5uApsSqex4gDSICNRJTbl1hB7GZ
	Bc4xSdxcyAxiCwsYSvT1H2UCsVkEVCUmXn/MAmLzCrhITHr7mxFkjISAgsScSTYgYU4BV4mV
	Ew+zgYSFgErWXNGcwMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwGD+T2sG4ssHi
	EKMAB6MSDy/HqgVBQqyJZcWVuYcYJTiYlUR4e+YtDBLiTUmsrEotyo8vKs1JLT7EKM3BoiTO
	e6DVOlBIID2xJDU7NbUgtQgmy8TBKdXAyJW0vfPxMxeLHiXzTcarEyT73/rwKWZ/UUybsXpK
	JIdS7PM70rvynkpUnlQROXla6Xa5sqNp946Th1In/+JjSDz6+d3CDa8Z/zN9idPamNI4MVe2
	Odph5atvS64a7PBy/DepLF1EatfX8tdvpDf5PI3h/Cjxm7Voitzzfe6zcu4XyMy04nwgr8RS
	nJFoqMVcVJwIAA7zn41fAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support of new USB 2.0 phy driver to Exynos 4 SoC device tree.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/arm/samsung/pmu.txt        |    2 ++
 arch/arm/boot/dts/exynos4.dtsi                     |   31 ++++++++++++++++++++
 arch/arm/boot/dts/exynos4210.dtsi                  |   17 +++++++++++
 arch/arm/boot/dts/exynos4x12.dtsi                  |   17 +++++++++++
 4 files changed, 67 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/samsung/pmu.txt b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
index 307e727..bfccab0 100644
--- a/Documentation/devicetree/bindings/arm/samsung/pmu.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
@@ -3,6 +3,8 @@ SAMSUNG Exynos SoC series PMU Registers
 Properties:
  - name : should be 'syscon';
  - compatible : should contain two values. First value must be one from following list:
+		   - "samsung,exynos4210-pmu" - for Exynos4210 SoC,
+		   - "samsung,exynos4212-pmu" - for Exynos4212 SoC,
 		   - "samsung,exynos5250-pmu" - for Exynos5250 SoC,
 		   - "samsung,exynos5420-pmu" - for Exynos5420 SoC.
 		second value must be always "syscon".
diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index a73eeb5..031d07a 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -253,6 +253,17 @@
 		status = "disabled";
 	};
 
+	usbotg@12480000 {
+		compatible = "samsung,s3c6400-hsotg";
+		reg = <0x12480000 0x20000>;
+		interrupts = <0 71 0>;
+		clocks = <&clock 305>;
+		clock-names = "otg";
+		phys = <&usb2phy 0>;
+		phy-names = "usb2-phy";
+		status = "disabled";
+	};
+
 	ehci@12580000 {
 		compatible = "samsung,exynos4210-ehci";
 		reg = <0x12580000 0x100>;
@@ -260,6 +271,26 @@
 		clocks = <&clock 304>;
 		clock-names = "usbhost";
 		status = "disabled";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		port@0 {
+			phys = <&usb2phy 1>;
+			phy-names = "host";
+			reg = <0>;
+			status = "disabled";
+		};
+		port@1 {
+			phys = <&usb2phy 2>;
+			phy-names = "hsic0";
+			reg = <1>;
+			status = "disabled";
+		};
+		port@2 {
+			phys = <&usb2phy 3>;
+			phy-names = "hsic1";
+			reg = <2>;
+			status = "disabled";
+		};
 	};
 
 	ohci@12590000 {
diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 057d682..f9d06bb 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -155,4 +155,21 @@
 			samsung,lcd-wb;
 		};
 	};
+
+	pmu_reg: syscon@10020000 {
+		compatible = "samsung,exynos4210-pmu", "syscon";
+		reg = <0x10020000 0x4000>;
+	};
+
+	usb2phy: phy@125B0000 {
+		compatible = "samsung,exynos4210-usb2-phy";
+		reg = <0x125B0000 0x100>;
+		clocks = <&clock 305>, <&clock 2>, <&clock 2>, <&clock 2>,
+								<&clock 2>;
+		clock-names = "phy", "device", "host", "hsic0", "hsic1";
+		status = "disabled";
+		#phy-cells = <1>;
+		samsung,sysreg-phandle = <&sys_reg>;
+		samsung,pmureg-phandle = <&pmu_reg>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index ad531fe..7121111 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -176,4 +176,21 @@
 			};
 		};
 	};
+
+	pmu_reg: syscon@10020000 {
+		compatible = "samsung,exynos4212-pmu", "syscon";
+		reg = <0x10020000 0x4000>;
+	};
+
+	usb2phy: phy@125B0000 {
+		compatible = "samsung,exynos4212-usb2-phy";
+		reg = <0x125B0000 0x100>;
+		clocks = <&clock 305>, <&clock 2>, <&clock 2>, <&clock 2>,
+								<&clock 2>;
+		clock-names = "phy", "device", "host", "hsic0", "hsic1";
+		status = "disabled";
+		#phy-cells = <1>;
+		samsung,sysreg-phandle = <&sys_reg>;
+		samsung,pmureg-phandle = <&pmu_reg>;
+	};
 };
-- 
1.7.9.5

