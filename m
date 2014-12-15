Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaLOO5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:57:18 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27069 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaLOO5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:57:12 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-b5-548ef6c6badf
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 1/3] devfreq: dt-bindings: Document bindings for Exynos3250
 bus DVFS driver
Date: Mon, 15 Dec 2014 15:56:51 +0100
Message-id: <1418655413-25410-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418655413-25410-1-git-send-email-k.kozlowski@samsung.com>
References: <1418655413-25410-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xq7rHvvWFGNz+ym+xccZ6VovrX56z
	Wsw/co7V4vULQ4v+x6+ZLc42vWG32PT4GqvF5V1z2Cw+9x5htJhxfh+Txdojd9ktll6/yGRx
	u3EFmwOvx5p5axg9Nq3qZPPYvKTeo2/LKkaPz5vkAlijuGxSUnMyy1KL9O0SuDJ2HvrEXnBK
	rKLnYBNbA+NvoS5GTg4JAROJa41djBC2mMSFe+vZuhi5OIQEljJKHHswnR3C6WOSWH7sAztI
	FZuAscTm5UvAqkQEnjNJ7Jz1hgXEYRaYwShxb+EuFpAqYYEEiUnXfoPNZRFQlXh4tpsJxOYV
	cJe4fegzE8Q+OYmTxyazgticAh4SV143gm0QAqpZf3op2wRG3gWMDKsYRVNLkwuKk9JzDfWK
	E3OLS/PS9ZLzczcxQkLyyw7GxcesDjEKcDAq8fAm7O0NEWJNLCuuzD3EKMHBrCTCO+tdX4gQ
	b0piZVVqUX58UWlOavEhRiYOTqkGxqaZ2Z+/nZep3C8597NQ7IrlC2/d+xer/eZ14ypOM6u1
	yttmWF9Q4fK/Nz11W+hblyM6PXXStjfXyR7Zfrr5wNTmphnb1HvmSe98LHy96+DpvWybUs5v
	3x54Z2Jb+LFN2n/3TjidZLLhn0Fd8hyTKS+Lngk/fzVlwTbLyW9Xi/xb9+WgW5b0l1Y+JZbi
	jERDLeai4kQAmNLbxScCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for bindings used by Exynos3250 Dynamic Voltage
and Frequency Scaling (DVFS) driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 .../bindings/arm/samsung/exynos3250-devfreq.txt    | 62 ++++++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt b/Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt
new file mode 100644
index 000000000000..162498ec0da8
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt
@@ -0,0 +1,62 @@
+Samsung Exynos3250 bus frequency scaling driver
+===============================================
+
+The Exynos3250 SoC allows Dynamic Voltage and Frequency Scaling (DVFS)
+for certain system buses:
+ - memory controller and bus,
+ - peripheral buses (leftbus, rightbus).
+
+DVFS for memory controller and bus
+==================================
+Required properties:
+ - compatible : should be "samsung,exynos3250-busfreq-mif"
+ - clock-names : one clock of name "dmc" to manage frequency
+ - clocks : phandle and specifier for clock listed in clock-names property
+ - vdd-mif-supply : phandle to MIF voltage regulator
+ - devfreq-events : two phandles to devfreq event devices providing
+	raw data for bus utilization
+
+DVFS for peripheral buses
+=========================
+Required properties:
+ - compatible : should be "samsung,exynos3250-busfreq-int"
+ - clock-names : names for bus clocks to manage frequencies;
+	All following clock names (and corresponding phandles) must be
+	provided: "aclk_400", "aclk_266", "aclk_200", "aclk_160", "aclk_gdl",
+	"aclk_gdr", "mfc";
+ - clocks : phandles and specifiers for clocks listed in clock-names property
+ - vdd-int-supply : phandle to INT voltage regulator
+ - devfreq-events : two phandles to devfreq event devices providing
+	raw data for bus utilization
+
+Example
+=======
+	busfreq_mif: busfreq@106A0000 {
+		compatible = "samsung,exynos3250-busfreq-mif";
+		clocks = <&cmu_dmc CLK_DIV_DMC>;
+		clock-names = "dmc";
+		vdd-mif-supply = <&buck1_reg>;
+		devfreq-events = <&ppmu_dmc0_3>, <&ppmu_dmc1_3>;
+		status = "okay";
+	};
+
+	busfreq_int: busfreq@116A0000 {
+		compatible = "samsung,exynos3250-busfreq-int";
+		clocks = <&cmu CLK_DIV_ACLK_400_MCUISP>,
+			<&cmu CLK_DIV_ACLK_266>,
+			<&cmu CLK_DIV_ACLK_200>,
+			<&cmu CLK_DIV_ACLK_160>,
+			<&cmu CLK_DIV_GDL>,
+			<&cmu CLK_DIV_GDR>,
+			<&cmu CLK_DIV_MFC>;
+		clock-names = "aclk_400",
+			"aclk_266",
+			"aclk_200",
+			"aclk_160",
+			"aclk_gdl",
+			"aclk_gdr",
+			"mfc";
+		vdd-int-supply = <&buck3_reg>;
+		devfreq-events = <&ppmu_leftbus_3>, <&ppmu_rightbus_3>;
+		status = "okay";
+	};
-- 
1.9.1

