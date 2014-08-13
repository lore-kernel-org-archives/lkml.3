Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaHMMmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:42:20 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7797 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaHMMmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:42:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 13 Aug 2014 05:29:00 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <wni@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v2 1/5] of: Add descriptions of thermtrip properties to Tegra PMC bindings
Date: Wed, 13 Aug 2014 15:41:21 +0300
Message-ID: <1407933685-12404-2-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1407933685-12404-1-git-send-email-mperttunen@nvidia.com>
References: <1407933685-12404-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware-triggered thermal reset requires configuring the I2C
reset procedure. This configuration is read from the device tree,
so document the relevant properties in the binding documentation.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 .../bindings/arm/tegra/nvidia,tegra20-pmc.txt       | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
index 68ac65f..ae6aef8 100644
--- a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
+++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
@@ -47,6 +47,19 @@ Required properties when nvidia,suspend-mode=<0>:
   sleep mode, the warm boot code will restore some PLLs, clocks and then
   bring up CPU0 for resuming the system.
 
+Hardware-triggered thermal reset:
+On Tegra30, Tegra114 and Tegra124, if the 'i2c-thermtrip' subnode exists,
+hardware-triggered thermal reset will be enabled.
+
+Required properties for hardware-triggered thermal reset (inside 'i2c-thermtrip'):
+- nvidia,pmu : Phandle to power management unit / PMIC handling poweroff
+- nvidia,reg-addr : I2C register address to write poweroff command to
+- nvidia,reg-data : Poweroff command to write to PMU
+
+Optional properties for hardware-triggered thermal reset (inside 'i2c-thermtrip'):
+- nvidia,pinmux-id : Pinmux used by the hardware when issuing poweroff command.
+                     Defaults to 0.
+
 Example:
 
 / SoC dts including file
@@ -69,6 +82,14 @@ pmc@7000f400 {
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
1.8.1.5

