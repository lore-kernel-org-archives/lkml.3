Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab3FEOtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:49:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17427 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab3FEOtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:49:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 05 Jun 2013 07:48:39 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>,
        <thierry.reding@avionic-design.de>, <bhelgaas@google.com>,
        <ldewangan@nvidia.com>, <olof@lixom.net>, <hdoyu@nvidia.com>,
        <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <pdeschrijver@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <jtukkinen@nvidia.com>, <kthota@nvidia.com>, <jagarwal@nvidia.com>
Subject: [PATCH V2] ARM: dts: tegra: Move PCIe node to correct place
Date: Wed, 5 Jun 2013 20:20:02 +0530
Message-ID: <1370443802-11189-1-git-send-email-jagarwal@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving PCIe controller node to correct place so
that it is sorted by register address in .dtsi file

Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
---
This patch is based on remotes/gitorious_thierryreding_linux/tegra/next and should be applied on top of this.

changes in V2:
Corrected patch synopsis

 arch/arm/boot/dts/tegra30.dtsi |  132 ++++++++++++++++++++--------------------
 1 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 5c1f7c0..a242b2e 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -12,6 +12,72 @@
 		serial4 = &uarte;
 	};
 
+	pcie-controller {
+		compatible = "nvidia,tegra30-pcie";
+		device_type = "pci";
+		reg = <0x00003000 0x00000800   /* PADS registers */
+		       0x00003800 0x00000200   /* AFI registers */
+		       0x10000000 0x10000000>; /* configuration space */
+		reg-names = "pads", "afi", "cs";
+		interrupts = <0 98 0x04   /* controller interrupt */
+		              0 99 0x04>; /* MSI interrupt */
+
+		bus-range = <0x00 0xff>;
+		#address-cells = <3>;
+		#size-cells = <2>;
+
+		ranges = <0x82000000 0 0x00000000 0x00000000 0 0x00001000   /* port 0 configuration space */
+			  0x82000000 0 0x00001000 0x00001000 0 0x00001000   /* port 1 configuration space */
+			  0x82000000 0 0x00004000 0x00004000 0 0x00001000   /* port 2 configuration space */
+			  0x81000000 0 0          0x02000000 0 0x00010000   /* downstream I/O */
+			  0x82000000 0 0x20000000 0x20000000 0 0x10000000   /* non-prefetchable memory */
+			  0xc2000000 0 0x30000000 0x30000000 0 0x10000000>; /* prefetchable memory */
+
+		clocks = <&tegra_car 70>, <&tegra_car 72>, <&tegra_car 74>,
+			 <&tegra_car 118>, <&tegra_car 215>;
+		clock-names = "pex", "afi", "pcie_xclk", "pll_e", "cml";
+		status = "disabled";
+
+		pci@1,0 {
+			device_type = "pci";
+			assigned-addresses = <0x82000800 0 0x00000000 0 0x1000>;
+			reg = <0x000800 0 0 0 0>;
+			status = "disabled";
+
+			#address-cells = <3>;
+			#size-cells = <2>;
+			ranges;
+
+			nvidia,num-lanes = <2>;
+		};
+
+		pci@2,0 {
+			device_type = "pci";
+			assigned-addresses = <0x82001000 0 0x00001000 0 0x1000>;
+			reg = <0x001000 0 0 0 0>;
+			status = "disabled";
+
+			#address-cells = <3>;
+			#size-cells = <2>;
+			ranges;
+
+			nvidia,num-lanes = <2>;
+		};
+
+		pci@3,0 {
+			device_type = "pci";
+			assigned-addresses = <0x82001800 0 0x00004000 0 0x1000>;
+			reg = <0x001800 0 0 0 0>;
+			status = "disabled";
+
+			#address-cells = <3>;
+			#size-cells = <2>;
+			ranges;
+
+			nvidia,num-lanes = <2>;
+		};
+	};
+
 	host1x {
 		compatible = "nvidia,tegra30-host1x", "simple-bus";
 		reg = <0x50000000 0x00024000>;
@@ -115,72 +181,6 @@
 		};
 	};
 
-	pcie-controller {
-		compatible = "nvidia,tegra30-pcie";
-		device_type = "pci";
-		reg = <0x00003000 0x00000800   /* PADS registers */
-		       0x00003800 0x00000200   /* AFI registers */
-		       0x10000000 0x10000000>; /* configuration space */
-		reg-names = "pads", "afi", "cs";
-		interrupts = <0 98 0x04   /* controller interrupt */
-		              0 99 0x04>; /* MSI interrupt */
-
-		bus-range = <0x00 0xff>;
-		#address-cells = <3>;
-		#size-cells = <2>;
-
-		ranges = <0x82000000 0 0x00000000 0x00000000 0 0x00001000   /* port 0 configuration space */
-			  0x82000000 0 0x00001000 0x00001000 0 0x00001000   /* port 1 configuration space */
-			  0x82000000 0 0x00004000 0x00004000 0 0x00001000   /* port 2 configuration space */
-			  0x81000000 0 0          0x02000000 0 0x00010000   /* downstream I/O */
-			  0x82000000 0 0x20000000 0x20000000 0 0x10000000   /* non-prefetchable memory */
-			  0xc2000000 0 0x30000000 0x30000000 0 0x10000000>; /* prefetchable memory */
-
-		clocks = <&tegra_car 70>, <&tegra_car 72>, <&tegra_car 74>,
-			 <&tegra_car 118>, <&tegra_car 215>;
-		clock-names = "pex", "afi", "pcie_xclk", "pll_e", "cml";
-		status = "disabled";
-
-		pci@1,0 {
-			device_type = "pci";
-			assigned-addresses = <0x82000800 0 0x00000000 0 0x1000>;
-			reg = <0x000800 0 0 0 0>;
-			status = "disabled";
-
-			#address-cells = <3>;
-			#size-cells = <2>;
-			ranges;
-
-			nvidia,num-lanes = <2>;
-		};
-
-		pci@2,0 {
-			device_type = "pci";
-			assigned-addresses = <0x82001000 0 0x00001000 0 0x1000>;
-			reg = <0x001000 0 0 0 0>;
-			status = "disabled";
-
-			#address-cells = <3>;
-			#size-cells = <2>;
-			ranges;
-
-			nvidia,num-lanes = <2>;
-		};
-
-		pci@3,0 {
-			device_type = "pci";
-			assigned-addresses = <0x82001800 0 0x00004000 0 0x1000>;
-			reg = <0x001800 0 0 0 0>;
-			status = "disabled";
-
-			#address-cells = <3>;
-			#size-cells = <2>;
-			ranges;
-
-			nvidia,num-lanes = <2>;
-		};
-	};
-
 	timer@50004600 {
 		compatible = "arm,cortex-a9-twd-timer";
 		reg = <0x50040600 0x20>;
-- 
1.7.0.4

