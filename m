Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaA2Ran (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:30:43 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:9455 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaA2RaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:30:09 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-6d-52e93a9f5082
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
Subject: [PATCH v6 3/8] dts: Add usb2phy to Exynos 4
Date: Wed, 29 Jan 2014 18:29:29 +0100
Message-id: <1391016574-25237-4-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1391016574-25237-1-git-send-email-k.debski@samsung.com>
References: <1391016574-25237-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jAd35Vi+DDH7u0rBYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i8sJLrBY/Xl9gs7jwtIfN4mzTG6DYrjlsFjPO72OyWLSsldli7ZG77BZn
	+2+zWUxsmsZucX5LJ5PF4TftrBYTfgO1rZ/xmsWibfUHVouOswfZHUQ8Lvf1MnnsnHWX3ePO
	tT1sHv+OsXvMvvuD0aNvyypGj+M3tjN5fN4kF8ARxWWTkpqTWZZapG+XwJUx4foKtoKvshWb
	Vr9mbGA8Lt7FyMkhIWAi8eLiJHYIW0ziwr31bF2MXBxCAosYJVYtf8YK4XQwSdy48wSoioOD
	TUBTYtU9D5AGEYEaiSm3rrCD1DALdDFLTNh2mg0kIQw0tXPzEVYQm0VAVeLKvTfMIDavgIvE
	38M3WUHmSAgoSMyZZAMS5hRwleiYcRGsVQioZHXPGrYJjLwLGBlWMYqmFiQXFCel5xrpFSfm
	Fpfmpesl5+duYgSH/DPpHYyrGiwOMQpwMCrx8K64+DxIiDWxrLgy9xCjBAezkghvlOHLICHe
	lMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE0hNLUrNTUwtSi2CyTBycUg2M7DNzL8n/tWzj
	Df6w4dQ7HQF9leLZ98R93+2YbMg576/JxiQ5y/bPnFH9XAvX3W+6c+Hz3kceEvyVqlJMq4wl
	Tp3RMF/K0HN+clj0MqZlh8OKja4zpfy8ecbIuqqk9Y5PiH3DxIdNm39/FfjDV1ydJxfY2vWj
	8uq/PLVm1eBaEc6VSx1vmDkqsRRnJBpqMRcVJwIAq9rlpnUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to PHY of USB2 of the Exynos 4 SoC.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 .../devicetree/bindings/arm/samsung/pmu.txt        |    2 ++
 arch/arm/boot/dts/exynos4.dtsi                     |   31 ++++++++++++++++++++
 arch/arm/boot/dts/exynos4210.dtsi                  |   17 +++++++++++
 arch/arm/boot/dts/exynos4x12.dtsi                  |   17 +++++++++++
 4 files changed, 67 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/samsung/pmu.txt b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
index 307e727..a76f91d 100644
--- a/Documentation/devicetree/bindings/arm/samsung/pmu.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
@@ -3,6 +3,8 @@ SAMSUNG Exynos SoC series PMU Registers
 Properties:
  - name : should be 'syscon';
  - compatible : should contain two values. First value must be one from following list:
+		   - "samsung,exynos4210-pmu" - for Exynos4210 SoC,
+		   - "samsung,exynos4x12-pmu" - for Exynos4212 SoC,
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
index ad531fe..63b0fe5 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -176,4 +176,21 @@
 			};
 		};
 	};
+
+	pmu_reg: syscon@10020000 {
+		compatible = "samsung,exynos4x12-pmu", "syscon";
+		reg = <0x10020000 0x4000>;
+	};
+
+	usb2phy: phy@125B0000 {
+		compatible = "samsung,exynos4x12-usb2-phy";
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

