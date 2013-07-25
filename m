Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab3GYRza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:55:30 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:33292 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab3GYRzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:55:14 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jay Agarwal <jagarwal@nvidia.com>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 15/16] ARM: dts: tegra: Increase prefetchable PCI memory space
Date: Thu, 25 Jul 2013 10:53:29 -0700
Message-Id: <1374774810-18459-16-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com>
References: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Agarwal <jagarwal@nvidia.com>

Instead of evenly splitting the 512 MiB area between prefetchable and
non-prefetchable memory spaces, increase the prefetchable memory space
to 384 MiB while at the same time decreasing the non-prefetchable memory
space to 128 MiB. This is a more useful default as most PCIe devices
require more prefetchable than non-prefetchable memory.

Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/boot/dts/tegra20.dtsi | 4 ++--
 arch/arm/boot/dts/tegra30.dtsi | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index ecd016a..3add9ac2 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -473,8 +473,8 @@
 		ranges = <0x82000000 0 0x80000000 0x80000000 0 0x00001000   /* port 0 registers */
 			  0x82000000 0 0x80001000 0x80001000 0 0x00001000   /* port 1 registers */
 			  0x81000000 0 0          0x82000000 0 0x00010000   /* downstream I/O */
-			  0x82000000 0 0xa0000000 0xa0000000 0 0x10000000   /* non-prefetchable memory */
-			  0xc2000000 0 0xb0000000 0xb0000000 0 0x10000000>; /* prefetchable memory */
+			  0x82000000 0 0xa0000000 0xa0000000 0 0x08000000   /* non-prefetchable memory */
+			  0xc2000000 0 0xa8000000 0xa8000000 0 0x18000000>; /* prefetchable memory */
 
 		clocks = <&tegra_car TEGRA20_CLK_PEX>,
 			 <&tegra_car TEGRA20_CLK_AFI>,
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index c8facca..d81c52e 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -35,8 +35,8 @@
 			  0x82000000 0 0x00001000 0x00001000 0 0x00001000   /* port 1 configuration space */
 			  0x82000000 0 0x00004000 0x00004000 0 0x00001000   /* port 2 configuration space */
 			  0x81000000 0 0          0x02000000 0 0x00010000   /* downstream I/O */
-			  0x82000000 0 0x20000000 0x20000000 0 0x10000000   /* non-prefetchable memory */
-			  0xc2000000 0 0x30000000 0x30000000 0 0x10000000>; /* prefetchable memory */
+			  0x82000000 0 0x20000000 0x20000000 0 0x08000000   /* non-prefetchable memory */
+			  0xc2000000 0 0x28000000 0x28000000 0 0x18000000>; /* prefetchable memory */
 
 		clocks = <&tegra_car TEGRA30_CLK_PCIE>,
 			 <&tegra_car TEGRA30_CLK_AFI>,
-- 
1.8.1.5

