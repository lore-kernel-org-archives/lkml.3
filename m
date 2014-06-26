Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaFZUuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:50:07 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41153 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaFZUuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:50:01 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>
Cc: Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 03/10] of: Add NVIDIA Tegra124 memory controller binding
Date: Thu, 26 Jun 2014 22:49:43 +0200
Message-Id: <1403815790-8548-4-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The memory controller on NVIDIA Tegra124 exposes various knobs that can
be used to tune the behaviour of the clients attached to it.

In addition, the memory controller implements an SMMU (IOMMU) which can
translate I/O virtual addresses to physical addresses for clients. This
is useful for scatter-gather operation on devices that don't support it
natively and for virtualization or process separation.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 .../bindings/memory-controllers/nvidia,tegra124-mc.txt       | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/nvidia,tegra124-mc.txt

diff --git a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra124-mc.txt b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra124-mc.txt
new file mode 100644
index 000000000000..4c922e839059
--- /dev/null
+++ b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra124-mc.txt
@@ -0,0 +1,12 @@
+NVIDIA Tegra124 Memory Controller device tree bindings
+======================================================
+
+Required properties:
+- compatible: Should be "nvidia,tegra124-mc"
+- reg: Physical base address and length of the controller's registers.
+- interrupts: The interrupt outputs from the controller.
+- #iommu-cells: Should be 1. The single cell of the IOMMU specifier defines
+  the SWGROUP of the master.
+
+This device implements an IOMMU that complies with the generic IOMMU binding.
+See ../iommu/iommu.txt for details.
-- 
2.0.0

