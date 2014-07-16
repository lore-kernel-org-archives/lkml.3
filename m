Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbaGPIzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:55:45 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7000 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaGPIze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:55:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 16 Jul 2014 01:48:06 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <tj@kernel.org>,
        <hdegoede@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v3 2/8] ARM: tegra: Add SATA controller to Tegra124 device tree
Date: Wed, 16 Jul 2014 11:54:17 +0300
Message-ID: <1405500863-19696-3-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1405500863-19696-1-git-send-email-mperttunen@nvidia.com>
References: <1405500863-19696-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the integrated AHCI-compliant Serial ATA controller present
in Tegra124 systems-on-chip to the Tegra124 device tree.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 arch/arm/boot/dts/tegra124.dtsi | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index 03916ef..7d3c48a 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -756,6 +756,31 @@
 		status = "disabled";
 	};
 
+	sata@0,70020000 {
+		compatible = "nvidia,tegra124-ahci";
+
+		reg = <0x0 0x70027000 0x0 0x2000>, /* AHCI */
+			<0x0 0x70020000 0x0 0x7000>; /* SATA */
+
+		interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
+
+		clocks = <&tegra_car TEGRA124_CLK_SATA>,
+			<&tegra_car TEGRA124_CLK_SATA_OOB>,
+			<&tegra_car TEGRA124_CLK_CML1>,
+			<&tegra_car TEGRA124_CLK_PLL_E>;
+		clock-names = "sata", "sata-oob", "cml1", "pll_e";
+
+		resets = <&tegra_car 124>,
+			<&tegra_car 123>,
+			<&tegra_car 129>;
+		reset-names = "sata", "sata-oob", "sata-cold";
+
+		phys = <&padctl TEGRA_XUSB_PADCTL_SATA>;
+		phy-names = "sata-phy";
+
+		status = "disabled";
+	};
+
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
1.8.1.5

