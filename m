Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaIFIz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 04:55:27 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:44605 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbaIFIzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 04:55:18 -0400
From: Mikko Perttunen <cyndis@kapsi.fi>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, wni@nvidia.com,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v3 1/5] of: Add descriptions of thermtrip properties to Tegra PMC bindings
Date: Sat,  6 Sep 2014 11:54:41 +0300
Message-Id: <1409993685-21911-2-git-send-email-cyndis@kapsi.fi>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409993685-21911-1-git-send-email-cyndis@kapsi.fi>
References: <1409993685-21911-1-git-send-email-cyndis@kapsi.fi>
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: cyndis@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

Hardware-triggered thermal reset requires configuring the I2C
reset procedure. This configuration is read from the device tree,
so document the relevant properties in the binding documentation.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Reviewed-by: Wei Ni <wni@nvidia.com>
Tested-by: Wei Ni <wni@nvidia.com>
---
v3
- replaced nvidia,pmu with nvidia,{i2c-bus,bus-addr}
- documented nvidia,pinmux-id

 .../bindings/arm/tegra/nvidia,tegra20-pmc.txt      | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
index 68ac65f..1d4e94a 100644
--- a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
+++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
@@ -47,6 +47,21 @@ Required properties when nvidia,suspend-mode=<0>:
   sleep mode, the warm boot code will restore some PLLs, clocks and then
   bring up CPU0 for resuming the system.
 
+Hardware-triggered thermal reset:
+On Tegra30, Tegra114 and Tegra124, if the 'i2c-thermtrip' subnode exists,
+hardware-triggered thermal reset will be enabled.
+
+Required properties for hardware-triggered thermal reset (inside 'i2c-thermtrip'):
+- nvidia,i2c-bus : Phandle to I2C bus containing the PMU
+- nvidia,bus-addr : Bus address of the PMU on the I2C bus
+- nvidia,reg-addr : I2C register address to write poweroff command to
+- nvidia,reg-data : Poweroff command to write to PMU
+
+Optional properties for hardware-triggered thermal reset (inside 'i2c-thermtrip'):
+- nvidia,pinmux-id : Pinmux used by the hardware when issuing poweroff command.
+                     Defaults to 0. Valid values are described in section 12.5.2
+                     "Pinmux Support" of the Tegra4 Technical Reference Manual.
+
 Example:
 
 / SoC dts including file
@@ -69,6 +84,14 @@ pmc@7000f400 {
 / Tegra board dts file
 {
 	...
+	pmc@7000f400 {
+		i2c-thermtrip {
+			nvidia,pmu = <&pmic>;
+			nvidia,reg-addr = <0x36>;
+			nvidia,reg-data = <0x2>;
+		};
+	};
+	...
 	clocks {
 		compatible = "simple-bus";
 		#address-cells = <1>;
-- 
2.1.0

