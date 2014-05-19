Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaESJZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:25:29 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5150 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaESJYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:24:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 19 May 2014 02:18:36 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/5] ARM: tegra: of: add GK20A device tree binding
Date: Mon, 19 May 2014 18:24:07 +0900
Message-ID: <1400491450-19223-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400491450-19223-1-git-send-email-acourbot@nvidia.com>
References: <1400491450-19223-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device tree binding documentation for the GK20A GPU used in
Tegra K1 SoCs.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 .../devicetree/bindings/gpu/nvidia,gk20a.txt       | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt

diff --git a/Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt b/Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt
new file mode 100644
index 000000000000..eda04c963af0
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt
@@ -0,0 +1,45 @@
+NVIDIA GK20A Graphics Processing Unit
+
+Required properties:
+- compatible: "nvidia,<chip>-<gpu>"
+  Currently recognized values:
+  - nvidia,tegra124-gk20a
+- reg: Physical base address and length of the controller's registers.
+  Must contain two entries:
+  - first entry for bar0
+  - second entry for bar1
+- interrupts: The interrupt outputs from the controller.
+- interrupt-names: Must include the following entries:
+  - stall
+  - nonstall
+- vdd-supply: regulator for supply voltage.
+- clocks: Must contain an entry for each entry in clock-names.
+  See ../clocks/clock-bindings.txt for details.
+- clock-names: Must include the following entries:
+  - gpu
+  - pll
+- resets: Must contain an entry for each entry in reset-names.
+  See ../reset/reset.txt for details.
+- reset-names: Must include the following entries:
+  - gpu
+
+Example:
+
+/ {
+	gpu@0,57000000 {
+		compatible = "nvidia,gk20a";
+		reg = <0x0 0x57000000 0x0 0x01000000>,
+		      <0x0 0x58000000 0x0 0x01000000>;
+		interrupts = <GIC_SPI 157 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 158 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "stall", "nonstall";
+		vdd-supply = <&vdd_gpu>;
+		clocks = <&tegra_car TEGRA124_CLK_GPU>,
+			 <&tegra_car TEGRA124_CLK_PLL_P_OUT5>;
+		clock-names = "gpu", "pll";
+		resets = <&tegra_car 184>;
+		reset-names = "gpu";
+		status = "disabled";
+	};
+
+};
-- 
1.9.2

