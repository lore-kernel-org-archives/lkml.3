Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaBRUhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:37:04 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46720 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbaBRUdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:33:12 -0500
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [RFC PATCH 4/6] devicetree: bindings: add documentation for voltagedomain
Date: Tue, 18 Feb 2014 14:32:21 -0600
Message-ID: <1392755543-28335-5-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392755543-28335-1-git-send-email-nm@ti.com>
References: <1392755543-28335-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for voltage domain binding format. Specific
voltage domains will have bindings corresponding to them.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 .../bindings/power/voltdm/voltage_domain.txt       |   65 ++++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/voltdm/voltage_domain.txt

diff --git a/Documentation/devicetree/bindings/power/voltdm/voltage_domain.txt b/Documentation/devicetree/bindings/power/voltdm/voltage_domain.txt
new file mode 100644
index 0000000..da48a19
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/voltdm/voltage_domain.txt
@@ -0,0 +1,65 @@
+Specifying Voltage Domain information for devices
+=================================================
+
+1. Specifying a voltage domain.
+
+SoCs may have multiple voltage domains under which various clocks operate.
+
+Mandatory Properties:
+- #voltdm-cells - indicates if there are specifiers needed to reference the
+  voltage domain
+
+Optional Properties:
+- voltage-tolerance: Specify the voltage tolerance in percentage
+
+2. Voltage domain consumer
+consumer nodes can be reference using the below binding:
+- <name>-voltdm: phandle to the voltage domain node.
+
+Examples:
+
+A. Voltage Domain controlling multiple regulator
+voltage_domain_mpu: voltdm@1 {
+	compatible = "xyz";
+	#voltdm-cells = <0>;
+	vdd-supply = <&vcc>;
+	vbb-supply = <&abb_mpu>;
+	...
+};
+
+voltage_domain_gpu: voltdm@2 {
+	compatible = "xyz";
+	#voltdm-cells = <0>;
+	vdd-supply = <&dcdc2>;
+	vbb-supply = <&abb_gpu>;
+	...
+};
+...
+&cpu0 {
+	cpu0-voltdm = <&voltage_domain_mpu>;
+	voltage-tolerance = <1>;
+};
+
+&gpu {
+	gpu-voltdm = <&voltage_domain_gpu>;
+};
+
+B. Indexed voltage domain device
+
+#define SOC_XYZ_VOLTAGE_DOMAIN_MPU	0
+#define SOC_XYZ_VOLTAGE_DOMAIN_GFX	1
+
+voltage_domain_socx: voltdm@1 {
+	compatible = "abc";
+	#voltdm-cells = <1>;
+	...
+};
+...
+&cpu0 {
+	cpu0-voltdm = <&voltage_domain_socx SOC_XYZ_VOLTAGE_DOMAIN_MPU>;
+	voltage-tolerance = <1>;
+};
+
+&gpu {
+	gpu-voltdm = <&voltage_domain_socx SOC_XYZ_VOLTAGE_DOMAIN_GFX>;
+};
-- 
1.7.9.5

