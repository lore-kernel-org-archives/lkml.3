Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761743Ab3DCOqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:46:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761443Ab3DCOpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:45:54 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 06/12] ARM: tegra: Move pmc.h to include/linux/tegra-pmc.h
Date: Wed,  3 Apr 2013 16:45:12 +0200
Message-Id: <1365000318-28256-7-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:RoNmn9kuU8gxg4oYs0h7582Ei1pqzNVh9j0wNMQ5Uxr
 VBB5RhNSA1lCNQNsBoDyJ6hBYSCaF69bThoxL/iJEc9redHn9j
 GlWSFT6GA5K1djQTuxJ9VD3Ouqy1W94hYHHFymsoTA7/aUe1Tp
 wmKebK9gjMjd7bgEqTklkFrsE57c/UGhapjcMASwEhjjdNZgMb
 7P9qXEGQC6/vcu/SAZLQuohn+ASO8RLjcA3h1Baf9mUv9K/X4v
 12mJAyEngO/BNLBGKOoOGbAn4eTOtjrYvDGp6gM6MOCTXVuIs/
 mAL+Ckd8PHSEGEZpR4lxv7dSzBXeN1OSThoPebd4LKQQA2vkcr
 umZD7X6Pq0ityLFgTfv5Z4Q1vmAyMh9k2drcSrCONe4nL5FLg1
 JS6XAPvZS9D7C33W/eRHbIGga8afet18dLMZfzZ6CxKUCvxkWl
 tRz1H
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for moving the PCIe driver into the drivers/pci/host
directory, this header, which contains prototypes that are required by
the PCIe driver, needs to be moved to a globally visible location.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
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
index c778451..7d44710 100644
--- a/arch/arm/mach-tegra/pmc.h
+++ b/arch/arm/mach-tegra/pmc.h
@@ -23,6 +23,5 @@ int tegra_pmc_cpu_power_on(int cpuid);
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
1.8.2

