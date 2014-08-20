Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaHTVHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 17:07:42 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17856 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaHTVFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 17:05:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Aug 2014 13:51:56 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, Vince Hsu <vinceh@nvidia.com>,
        <devicetree@vger.kernel.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v4 11/16] cpufreq: tegra124: Add device tree bindings
Date: Thu, 21 Aug 2014 00:04:39 +0300
Message-ID: <1408568684-11016-12-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1408568684-11016-1-git-send-email-ttynkkynen@nvidia.com>
References: <1408568684-11016-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq driver for Tegra124 will be a different one than the old
Tegra20 cpufreq driver (tegra-cpufreq), which does not use the device
tree.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
v3: vdd-cpu-supply property added
---
 .../bindings/cpufreq/tegra124-cpufreq.txt          | 44 ++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/cpufreq/tegra124-cpufreq.txt

diff --git a/Documentation/devicetree/bindings/cpufreq/tegra124-cpufreq.txt b/Documentation/devicetree/bindings/cpufreq/tegra124-cpufreq.txt
new file mode 100644
index 0000000..b1669fb
--- /dev/null
+++ b/Documentation/devicetree/bindings/cpufreq/tegra124-cpufreq.txt
@@ -0,0 +1,44 @@
+Tegra124 CPU frequency scaling driver bindings
+----------------------------------------------
+
+Both required and optional properties listed below must be defined
+under node /cpus/cpu@0.
+
+Required properties:
+- clocks: Must contain an entry for each entry in clock-names.
+  See ../clocks/clock-bindings.txt for details.
+- clock-names: Must include the following entries:
+  - cpu_g: Clock mux for the fast CPU cluster.
+  - cpu_lp: Clock mux for the low-power CPU cluster.
+  - pll_x: Fast PLL clocksource.
+  - pll_p: Auxiliary PLL used during fast PLL rate changes.
+  - dfll: Fast DFLL clocksource that also automatically scales CPU voltage.
+- vdd-cpu-supply: Regulator for CPU voltage
+
+Optional properties:
+- clock-latency: Specify the possible maximum transition latency for clock,
+  in unit of nanoseconds.
+
+Example:
+--------
+cpus {
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	cpu@0 {
+		device_type = "cpu";
+		compatible = "arm,cortex-a15";
+		reg = <0>;
+
+		clocks = <&tegra_car TEGRA124_CLK_CCLK_G>,
+			 <&tegra_car TEGRA124_CLK_CCLK_LP>,
+			 <&tegra_car TEGRA124_CLK_PLL_X>,
+			 <&tegra_car TEGRA124_CLK_PLL_P>,
+			 <&dfll>;
+		clock-names = "cpu_g", "cpu_lp", "pll_x", "pll_p", "dfll";
+		clock-latency = <300000>;
+		vdd-cpu-supply: <&vdd_cpu>;
+	};
+
+	<...>
+};
-- 
1.8.1.5

