Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab3GYRx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:53:57 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:41149 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208Ab3GYRxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:53:51 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jay Agarwal <jagarwal@nvidia.com>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 02/16] ARM: tegra: Move pmc.h to include/linux/tegra-pmc.h
Date: Thu, 25 Jul 2013 10:53:16 -0700
Message-Id: <1374774810-18459-3-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com>
References: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <thierry.reding@avionic-design.de>

In preparation for moving the PCIe driver into the drivers/pci/host
directory, this header, which contains prototypes that are required by
the PCIe driver, needs to be moved to a globally visible location.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- keep tegra_pmc_init() prototype in arch/arm/mach-tegra/pmc.h
- move pmc.h to includex/linux/tegra-pmc.h

Changes in v3:
- update subject to match new location

 arch/arm/mach-tegra/pmc.h |  1 -
 include/linux/tegra-pmc.h | 23 +++++++++++++++++++++++
 2 files changed, 23 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/tegra-pmc.h

diff --git a/arch/arm/mach-tegra/pmc.h b/arch/arm/mach-tegra/pmc.h
index cdb08a1..e1c2df2 100644
--- a/arch/arm/mach-tegra/pmc.h
+++ b/arch/arm/mach-tegra/pmc.h
@@ -37,6 +37,5 @@ int tegra_pmc_cpu_power_on(int cpuid);
 int tegra_pmc_cpu_remove_clamping(int cpuid);
 
 void tegra_pmc_init(void);
-void tegra_pmc_pcie_xclk_clamp(bool clamp);
 
 #endif
diff --git a/include/linux/tegra-pmc.h b/include/linux/tegra-pmc.h
new file mode 100644
index 0000000..b6296bf
--- /dev/null
+++ b/include/linux/tegra-pmc.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2012 NVIDIA CORPORATION. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#ifndef __LINUX_TEGRA_PMC_H
+#define __LINUX_TEGRA_PMC_H
+
+void tegra_pmc_pcie_xclk_clamp(bool clamp);
+
+#endif
-- 
1.8.1.5

