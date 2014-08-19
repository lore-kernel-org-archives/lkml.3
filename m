Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaHSDke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 23:40:34 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:41461 "EHLO
	script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaHSDjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 23:39:48 -0400
X-DKIM: Courier DKIM Filter v0.50+pk-2014-03-23 mail.cs.helsinki.fi Tue, 19 Aug 2014 06:34:10 +0300
From: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
To: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, Vince Hsu <vinceh@nvidia.com>,
        devicetree@vger.kernel.org, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v3 11/15] cpufreq: tegra124: Add device tree bindings
Date: Tue, 19 Aug 2014 06:33:21 +0300
Message-Id: <1408419205-10048-12-git-send-email-tuomas.tynkkynen@iki.fi>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>
References: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

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

