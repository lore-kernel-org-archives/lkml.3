Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab3GYRyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:54:18 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:37890 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab3GYRyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:54:11 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jay Agarwal <jagarwal@nvidia.com>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 05/16] ARM: tegra: tec: Add PCIe support
Date: Thu, 25 Jul 2013 10:53:19 -0700
Message-Id: <1374774810-18459-6-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com>
References: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <thierry.reding@avionic-design.de>

Enable the first PCIe root port which is connected to an FPGA on the
Tamonten Evaluation Carrier and add device nodes for each of the PCI
endpoints available in the standard configuration.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- remove duplicate nodes and properties defined in tegra20-tamonten.dtsi

Changes in v3:
- remove PCIe endpoint device tree nodes, all devices can be discovered
  via standard PCI enumeration

 arch/arm/boot/dts/tegra20-tec.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20-tec.dts b/arch/arm/boot/dts/tegra20-tec.dts
index c572c43..3ada3cb 100644
--- a/arch/arm/boot/dts/tegra20-tec.dts
+++ b/arch/arm/boot/dts/tegra20-tec.dts
@@ -32,6 +32,14 @@
 		};
 	};
 
+	pcie-controller {
+		status = "okay";
+
+		pci@1,0 {
+			status = "okay";
+		};
+	};
+
 	sound {
 		compatible = "ad,tegra-audio-wm8903-tec",
 			     "nvidia,tegra-audio-wm8903";
-- 
1.8.1.5

