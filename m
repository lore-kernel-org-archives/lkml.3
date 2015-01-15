Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbbAOBvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:51:15 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:58732 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbbAOBvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:51:08 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-d6-54b71d0894f2
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v4 2/9] devfreq: exynos: Add documentation for generic exynos
 memory bus frequency driver
Date: Thu, 15 Jan 2015 10:50:50 +0900
Message-id: <1421286657-4720-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
References: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSosshuz3E4N08VYvHaxYzWWycsZ7V
	4vqX56wWk+5PYLF4/cLQov/xa2aLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Sx9PpFJovb
	jSvYLB6veMtu0br3CLvFql1/GB0EPNbMW8PosXPWXXaPxXteMnlsWtXJ5rF5Sb1H35ZVjB6f
	N8kFsEdx2aSk5mSWpRbp2yVwZWw5s5O9YKNuxYvzC5gbGCcrdTFycEgImEj8W1HRxcgJZIpJ
	XLi3nq2LkYtDSGApo8TZG7fZIBImEtfPPoFKTGeUOLPrOCNIQkigiUniaVM2iM0moCWx/8UN
	sAYRAT2JzmN72EFsZoE/TBJNm1hAbGGBbInJ93tYQWwWAVWJfZOnMoPYvAIuEtc+rWaCWKYg
	sWz5TLAaTgFXiZ5f+9khdrlIrLo7mRHkCAmBl+wSC/bMZYYYJCDxbfIhFohvZCU2HWCGmCMp
	cXDFDZYJjMILGBlWMYqmFiQXFCelF5noFSfmFpfmpesl5+duYgTG0+l/zybsYLx3wPoQowAH
	oxIPr8ORrSFCrIllxZW5hxhNgTZMZJYSTc4HRm1eSbyhsZmRhamJqbGRuaWZkjjva6mfwUIC
	6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYU3jnnO7QX/Uj5eGFxK2GRbsvvCpebqquxaCgclvs
	q6XP5969foLxH5kO6tYsZBfsnr6/WPU/33TfEobn7D/3rr9zwjswf8vpR4bNpQf9bVsv74sy
	zL8ja7X7/8qywwfMIrdX9P0/lCznpi5nab5nwWVvk9R/j4MZP73Z9vr+LadKfmlV/vxGJZbi
	jERDLeai4kQAeM60JKICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQV0O2e0hBmdXy1g8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtVu36w+gg4LFm3hpGj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvT4
	vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGljM72Qs26la8OL+A
	uYFxslIXIyeHhICJxPWzT9ggbDGJC/fWA9lcHEIC0xklzuw6zgiSEBJoYpJ42pQNYrMJaEns
	f3EDrEFEQE+i89gedhCbWeAPk0TTJhYQW1ggW2Ly/R5WEJtFQFVi3+SpzCA2r4CLxLVPq5kg
	lilILFs+E6yGU8BVoufXfnaIXS4Sq+5OZpzAyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5y
	fu4mRnC8PpPawbiyweIQowAHoxIPr8ORrSFCrIllxZW5hxglOJiVRHjfftoWIsSbklhZlVqU
	H19UmpNafIjRFOiqicxSosn5wFSSVxJvaGxiZmRpZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQ
	WgTTx8TBKdXAuHzaR47J9xsPN2fsuCmdZRtpePa3xAtJ7qCD8QcP70tj/fHGuKvJluOZReGZ
	xH3ZeSdYr+mV82XlJy38vE4k7HOuu8arZX+y15+OmvTPOe1tSMr79Tv8BI/WrHu942v/u9zJ
	ey99E9ZZs1PGx3l53yS7yyIMrmFs54NFalmef9qs0Stu81Z7vhJLcUaioRZzUXEiAGu0YsDt	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the documentation for generic exynos memory bus frequency
driver.

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 .../devicetree/bindings/devfreq/exynos-bus.txt     | 188 +++++++++++++++++++++
 1 file changed, 188 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/devfreq/exynos-bus.txt

diff --git a/Documentation/devicetree/bindings/devfreq/exynos-bus.txt b/Documentation/devicetree/bindings/devfreq/exynos-bus.txt
new file mode 100644
index 0000000..6323dcf
--- /dev/null
+++ b/Documentation/devicetree/bindings/devfreq/exynos-bus.txt
@@ -0,0 +1,188 @@
+
+* Generic Exynos Memory Bus device
+
+The Samsung Exynos SoCs have many memory buses for data transfer between DRAM
+memory and MMC/sub-IP in SoC. Almost Exynos SoCs have the common architecture
+for memory buses. Generally, Exynos SoC express the memory bus by using memory
+bus group and block. The memory bus group has one more memory bus blocks and
+OPP table (including frequency and voltage for DVFS), regulator, devfreq-event
+devices. Each memory bus block has a clock for own memory bus speen and
+frequency table for DVFS. There are a little different among Exynos SoCs
+because each Exynos SoC has the different sub-IP and differnt memory bus.
+So, this difference should be specified in devicetree file.
+
+Required properties for memory bus group:
+- compatible: Should be "samsung,exynos-memory-bus".
+- operating-points: the OPP table including frequency/voltage information to
+                  support DVFS (Dynamic Voltage/Frequency Scaling) feature.
+- devfreq-events: the devfreq-event device to monitor the curret state of
+                  memory bus group.
+- vdd-mem-supply: the regulator to provide memory bus group with the voltage.
+
+Optional properties for memory bus group:
+- exynos,saturation-ratio: the percentage value which is used to calibrate
+                   the memory performance count againt memory cycle count.
+
+Required properties for memory bus block:
+- clock-names : the name of clock used by the memory bus, "memory-bus".
+- clocks : phandles for clock specified in "clock-names" property.
+- #clock-cells: should be 1.
+- frequency: the frequency table to support DVFS feature.
+
+Example1 : Memory bus group/block in exynos3250.dtsi are listed below.
+	Exynos3250 has two memory bus group (MIF, INT group). MIF (Memory
+	Interface) memory bus group includes one memory bus block between
+	DRAM and eMMC. Also, INT (Internal) memory bus group includes eight
+	memory bus blocks which support each sub-IP between DRAM and sub-IP.
+
+	memory_bus_mif: memory_bus@0 {
+		compatible = "samsung,exynos-memory-bus";
+
+		operating-points = <
+			400000 875000
+			200000 800000
+			133000 800000
+			100000 800000
+			50000  800000>;
+		status = "disabled";
+
+		blocks {
+			dmc_block: memory_bus_block1 {
+				clocks = <&cmu_dmc CLK_DIV_DMC>;
+				clock-names = "memory-bus";
+				frequency = <
+					400000
+					200000
+					133000
+					100000
+					50000>;
+			};
+		};
+	};
+
+	memory_bus_int: memory_bus@1 {
+		compatible = "samsung,exynos-memory-bus";
+
+		operating-points = <
+			400000 950000
+			200000 950000
+			133000 925000
+			100000 850000
+			80000  850000
+			50000  850000>;
+
+		status = "disabled";
+
+		blocks {
+			peri_block: memory_bus_block1 {
+				clocks = <&cmu CLK_DIV_ACLK_100>;
+				clock-names = "memory-bus";
+				frequency = <
+					100000
+					100000
+					100000
+					100000
+					50000
+					50000>;
+			};
+
+			display_block: memory_bus_block2 {
+				clocks = <&cmu CLK_DIV_ACLK_160>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					160000
+					100000
+					80000
+					80000
+					50000>;
+			};
+
+			isp_block: memory_bus_block3 {
+				clocks = <&cmu CLK_DIV_ACLK_200>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					200000
+					100000
+					80000
+					50000
+					50000>;
+			};
+
+			gps_block: memory_bus_block4 {
+				clocks = <&cmu CLK_DIV_ACLK_266>;
+				clock-names = "memory-bus";
+				frequency = <
+					300000
+					200000
+					133000
+					100000
+					50000
+					50000>;
+			};
+
+			mcuisp_block: memory_bus_block5 {
+				clocks = <&cmu CLK_DIV_ACLK_400_MCUISP>;
+				clock-names = "memory-bus";
+				frequency = <
+					400000
+					200000
+					50000
+					50000
+					50000
+					50000>;
+			};
+
+			leftbus_block: memory_bus_block6 {
+				clocks = <&cmu CLK_DIV_GDL>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					200000
+					133000
+					100000
+					100000
+					100000>;
+			};
+
+			rightbus_block: memory_bus_block7 {
+				clocks = <&cmu CLK_DIV_GDR>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					200000
+					133000
+					100000
+					100000
+					100000>;
+			};
+
+			mfc_block: memory_bus_block8 {
+				clocks = <&cmu CLK_SCLK_MFC>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					200000
+					200000
+					133000
+					100000
+					80000>;
+			};
+		};
+	};
+
+Example2 : Usage case to handle the frequency/voltage of memory bus on runtime
+	in exynos3250-rinato.dts are listed below.
+
+	&memory_bus_mif {
+		devfreq-events = <&ppmu_dmc0_3>, <&ppmu_dmc1_3>;
+		vdd-mem-supply = <&buck1_reg>;
+		status = "okay";
+	};
+
+	&memory_bus_int {
+		devfreq-events = <&ppmu_leftbus_3>, <&ppmu_rightbus_3>;
+		vdd-mem-supply = <&buck3_reg>;
+		status = "okay";
+	};
-- 
1.8.5.5

