Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaFZFel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 01:34:41 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3794 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaFZFeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 01:34:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 25 Jun 2014 22:27:59 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 2/3] ARM: tegra: of: add GK20A device tree binding
Date: Thu, 26 Jun 2014 14:33:33 +0900
Message-ID: <1403760814-26148-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403760814-26148-1-git-send-email-acourbot@nvidia.com>
References: <1403760814-26148-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device tree binding documentation for the GK20A GPU used in
Tegra K1 SoCs.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
---
 .../devicetree/bindings/gpu/nvidia,gk20a.txt       | 43 ++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt

diff --git a/Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt b/Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt
new file mode 100644
index 000000000000..23bfe8e1f7cc
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt
@@ -0,0 +1,43 @@
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
+- interrupts: Must contain an entry for each entry in interrupt-names.
+  See ../interrupt-controller/interrupts.txt for details.
+- interrupt-names: Must include the following entries:
+  - stall
+  - nonstall
+- vdd-supply: regulator for supply voltage.
+- clocks: Must contain an entry for each entry in clock-names.
+  See ../clocks/clock-bindings.txt for details.
+- clock-names: Must include the following entries:
+  - gpu
+  - pwr
+- resets: Must contain an entry for each entry in reset-names.
+  See ../reset/reset.txt for details.
+- reset-names: Must include the following entries:
+  - gpu
+
+Example:
+
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
+		clock-names = "gpu", "pwr";
+		resets = <&tegra_car 184>;
+		reset-names = "gpu";
+		status = "disabled";
+	};
-- 
2.0.0

