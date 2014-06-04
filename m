Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaFDLuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:50:03 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6979 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaFDLrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:47:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 04 Jun 2014 04:42:24 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <tj@kernel.org>,
        <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>, <devicetree@vger.kernel.org>
Subject: [PATCH 2/9] ARM: tegra: Add SATA controller to Tegra124 device tree
Date: Wed, 4 Jun 2014 14:32:32 +0300
Message-ID: <1401881559-18469-3-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the integrated AHCI-compliant Serial ATA controller present
in Tegra124 systems-on-chip to the Tegra124 device tree.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Cc: devicetree@vger.kernel.org
---
 arch/arm/boot/dts/tegra124.dtsi | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index 90f11ea..e647f30 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -787,6 +787,30 @@
 		status = "disabled";
 	};
 
+	sata@0,70020000 {
+		compatible = "nvidia,tegra124-ahci";
+
+		reg = <0x0 0x70027000 0x0 0x2000>, /* AHCI */
+			<0x0 0x70020000 0x0 0x7000>; /* SATA */
+
+		interrupts = <0 23 IRQ_TYPE_LEVEL_HIGH>;
+
+		clocks = <&tegra_car TEGRA124_CLK_SATA>,
+			<&tegra_car TEGRA124_CLK_SATA_OOB>,
+			<&tegra_car TEGRA124_CLK_CML1>,
+			<&tegra_car TEGRA124_CLK_PLL_E>;
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

