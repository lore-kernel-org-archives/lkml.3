Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaKJNNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:13:23 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:53254 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbaKJNNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:13:17 -0500
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, wni@nvidia.com,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v4 REPOST 1/5] of: Add descriptions of thermtrip properties to Tegra PMC bindings
Date: Mon, 10 Nov 2014 15:12:13 +0200
Message-Id: <1415625137-4791-2-git-send-email-mikko.perttunen@kapsi.fi>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415625137-4791-1-git-send-email-mikko.perttunen@kapsi.fi>
References: <1415625137-4791-1-git-send-email-mikko.perttunen@kapsi.fi>
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
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
 .../bindings/arm/tegra/nvidia,tegra20-pmc.txt      | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
index 68ac65f..dc13fb0 100644
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
@@ -69,6 +84,15 @@ pmc@7000f400 {
 / Tegra board dts file
 {
 	...
+	pmc@7000f400 {
+		i2c-thermtrip {
+			nvidia,i2c-bus = <&pmic_bus>;
+			nvidia,bus-addr = <0x40>;
+			nvidia,reg-addr = <0x36>;
+			nvidia,reg-data = <0x2>;
+		};
+	};
+	...
 	clocks {
 		compatible = "simple-bus";
 		#address-cells = <1>;
-- 
2.1.3

