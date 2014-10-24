Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbaJXOoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:44:37 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:58116 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756539AbaJXOlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:41:01 -0400
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com,
        pdeschrijver@nvidia.com, rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: mturquette@linaro.org, pwalmsley@nvidia.com, vinceh@nvidia.com,
        pgaikwad@nvidia.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tuomas.tynkkynen@iki.fi,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>
Subject: [PATCH v5 11/16] cpufreq: tegra124: Add device tree bindings
Date: Fri, 24 Oct 2014 17:39:18 +0300
Message-Id: <1414161563-16812-12-git-send-email-mikko.perttunen@kapsi.fi>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414161563-16812-1-git-send-email-mikko.perttunen@kapsi.fi>
References: <1414161563-16812-1-git-send-email-mikko.perttunen@kapsi.fi>
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

The cpufreq driver for Tegra124 will be a different one than the old
Tegra20 cpufreq driver (tegra-cpufreq), which does not use the device
tree.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Signed-off-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
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
2.1.0

