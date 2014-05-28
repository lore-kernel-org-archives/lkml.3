Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaE1M4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:56:13 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19348 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbaE1M4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:56:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 28 May 2014 05:51:05 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 4/5] ARM: tegra: Add efuse and apbmisc bindings
Date: Wed, 28 May 2014 15:54:36 +0300
Message-ID: <1401281677-32110-5-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1401281677-32110-1-git-send-email-pdeschrijver@nvidia.com>
References: <1401281677-32110-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add efuse and apbmisc bindings for Tegra20, Tegra30, Tegra114 and Tegra124.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 .../devicetree/bindings/fuse/fuse-tegra.txt        |   30 ++++++++++++++++++++
 .../devicetree/bindings/misc/nvidia,apbmisc.txt    |   13 ++++++++
 arch/arm/boot/dts/tegra114.dtsi                    |   12 ++++++++
 arch/arm/boot/dts/tegra124.dtsi                    |   12 ++++++++
 arch/arm/boot/dts/tegra20.dtsi                     |   12 ++++++++
 arch/arm/boot/dts/tegra30.dtsi                     |   12 ++++++++
 6 files changed, 91 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/fuse/fuse-tegra.txt
 create mode 100644 Documentation/devicetree/bindings/misc/nvidia,apbmisc.txt

diff --git a/Documentation/devicetree/bindings/fuse/fuse-tegra.txt b/Documentation/devicetree/bindings/fuse/fuse-tegra.txt
new file mode 100644
index 0000000..831ce50
--- /dev/null
+++ b/Documentation/devicetree/bindings/fuse/fuse-tegra.txt
@@ -0,0 +1,30 @@
+NVIDIA Tegra20/Tegra30/Tegr114/Tegra124 fuse block.
+
+Required properties:
+- compatible : should be:
+	"nvidia,tegra20-efuse"
+	"nvidia,tegra30-efuse"
+	"nvidia,tegra114-efuse"
+	"nvidia,tegra124-efuse"
+  Details:
+  nvidia,tegra20-efuse: Tegra20 requires using APB DMA to read the fuse data
+	due to a hardware bug. Tegra20 also lacks certain information which is
+	available in later generations such as fab code, lot code, wafer id,..
+  nvidia,tegra30-efuse, nvidia,tegra114-efuse and nvidia,tegra124-efuse:
+	The differences between these SoCs are the size of the efuse array,
+	the location of the spare (OEM programmable) bits and the location of
+	the speedo data.
+- reg: Should contain 1 entry: the entry gives the physical address and length
+       of the fuse registers.
+- clocks: Should contain a pointer to the fuse clock.
+
+Example:
+
+        fuse@7000f800 {
+                compatible = "nvidia,tegra20-efuse";
+                reg = <0x7000F800 0x400>,
+                      <0x70000000 0x400>;
+                clocks = <&tegra_car TEGRA20_CLK_FUSE>;
+        };
+
+
diff --git a/Documentation/devicetree/bindings/misc/nvidia,apbmisc.txt b/Documentation/devicetree/bindings/misc/nvidia,apbmisc.txt
new file mode 100644
index 0000000..b97b8be
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/nvidia,apbmisc.txt
@@ -0,0 +1,13 @@
+NVIDIA Tegra20/Tegra30/Tegr114/Tegra124 apbmisc block
+
+Required properties:
+- compatible : should be:
+       "nvidia,tegra20-apbmisc"
+       "nvidia,tegra30-apbmisc"
+       "nvidia,tegra114-apbmisc"
+       "nvidia,tegra124-apbmisc"
+- reg: Should contain 2 entries: the first entry gives the physical address
+       and length of the registers which contain revision and debug features.
+       The second entry gives the physical address and length of the
+       registers indicating the strapping options.
+
diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index fdc559a..d91a601 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -220,6 +220,12 @@
 		interrupt-controller;
 	};
 
+        apbmisc@0x70000800 {
+		compatible = "nvidia,tegra114-apbmisc", "nvidia,tegra20-apbmisc";
+		reg = <0x70000800 0x64   /* Chip revision */
+		       0x70000008 0x04>; /* Strapping options */
+	};
+
 	pinmux: pinmux@70000868 {
 		compatible = "nvidia,tegra114-pinmux";
 		reg = <0x70000868 0x148		/* Pad control registers */
@@ -485,6 +491,12 @@
 		clock-names = "pclk", "clk32k_in";
 	};
 
+	fuse@7000f800 {
+		compatible = "nvidia,tegra114-efuse";
+		reg = <0x7000f800 0x400>;
+		clocks = <&tegra_car TEGRA114_CLK_FUSE>;
+	};
+
 	iommu@70019010 {
 		compatible = "nvidia,tegra114-smmu", "nvidia,tegra30-smmu";
 		reg = <0x70019010 0x02c
diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index 6d540a0..e5bd036 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -167,6 +167,12 @@
 		#dma-cells = <1>;
 	};
 
+	apbmisc@0x70000800 {
+		compatible = "nvidia,tegra124-apbmisc", "nvidia,tegra20-apbmisc";
+		reg = <0x0 0x70000800 0x0 0x64>,   /* Chip revision */
+		      <0x0 0x7000E864 0x0 0x04>;   /* Strapping options */
+	};
+
 	pinmux: pinmux@0,70000868 {
 		compatible = "nvidia,tegra124-pinmux";
 		reg = <0x0 0x70000868 0x0 0x164>, /* Pad control registers */
@@ -437,6 +443,12 @@
 		clock-names = "pclk", "clk32k_in";
 	};
 
+	fuse@7000f800 {
+		compatible = "nvidia,tegra124-efuse";
+		reg = <0x0 0x7000f800 0x0 0x400>;
+		clocks = <&tegra_car TEGRA124_CLK_FUSE>;
+	};
+
 	sdhci@0,700b0000 {
 		compatible = "nvidia,tegra124-sdhci";
 		reg = <0x0 0x700b0000 0x0 0x200>;
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index a7ddf70..b5d1fe1 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -236,6 +236,12 @@
 		interrupt-controller;
 	};
 
+        apbmisc@0x70000800 {
+		compatible = "nvidia,tegra20-apbmisc";
+		reg = <0x70000800 0x64   /* Chip revision */
+		       0x70000008 0x04>; /* Strapping options */
+	};
+
 	pinmux: pinmux@70000014 {
 		compatible = "nvidia,tegra20-pinmux";
 		reg = <0x70000014 0x10   /* Tri-state registers */
@@ -545,6 +551,12 @@
 		#size-cells = <0>;
 	};
 
+	fuse@7000f800 {
+		compatible = "nvidia,tegra20-efuse";
+		reg = <0x7000F800 0x400>;
+		clocks = <&tegra_car TEGRA20_CLK_FUSE>;
+	};
+
 	pcie-controller@80003000 {
 		compatible = "nvidia,tegra20-pcie";
 		device_type = "pci";
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index dec4fc8..bd4969d 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -335,6 +335,12 @@
 		interrupt-controller;
 	};
 
+        apbmisc@0x70000800 {
+		compatible = "nvidia,tegra30-apbmisc", "nvidia,tegra20-apbmisc";
+		reg = <0x70000800 0x64   /* Chip revision */
+		       0x70000008 0x04>; /* Strapping options */
+	};
+
 	pinmux: pinmux@70000868 {
 		compatible = "nvidia,tegra30-pinmux";
 		reg = <0x70000868 0xd4    /* Pad control registers */
@@ -631,6 +637,12 @@
 		nvidia,ahb = <&ahb>;
 	};
 
+	fuse@7000f800 {
+		compatible = "nvidia,tegra30-efuse";
+		reg = <0x7000f800 0x400>;
+		clocks = <&tegra_car TEGRA30_CLK_FUSE>;
+	};
+
 	ahub@70080000 {
 		compatible = "nvidia,tegra30-ahub";
 		reg = <0x70080000 0x200
-- 
1.7.7.rc0.72.g4b5ea.dirty

