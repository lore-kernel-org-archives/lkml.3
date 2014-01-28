Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbaA1Xiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:38:50 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11219 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbaA1Xir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:38:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 28 Jan 2014 15:37:27 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joseph Lo <josephl@nvidia.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Danny Huang <dahuang@nvidia.com>
Subject: [PATCH v3 5/6] misc: enable fuse drivers
Date: Wed, 29 Jan 2014 01:36:15 +0200
Message-ID: <1390952176-30402-6-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
References: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable building the fuse drivers.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/Makefile |    4 ----
 drivers/misc/Makefile        |    1 +
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 019bb17..92f8ab2 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -2,7 +2,6 @@ asflags-y				+= -march=armv7-a
 
 obj-y                                   += io.o
 obj-y                                   += irq.o
-obj-y					+= fuse.o
 obj-y					+= pmc.o
 obj-y					+= flowctrl.o
 obj-y					+= powergate.o
@@ -13,14 +12,12 @@ obj-y					+= reset-handler.o
 obj-y					+= sleep.o
 obj-y					+= tegra.o
 obj-$(CONFIG_CPU_IDLE)			+= cpuidle.o
-obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra20_speedo.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra2_emc.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= sleep-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= pm-tegra20.o
 ifeq ($(CONFIG_CPU_IDLE),y)
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= cpuidle-tegra20.o
 endif
-obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= tegra30_speedo.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= sleep-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= pm-tegra30.o
 ifeq ($(CONFIG_CPU_IDLE),y)
@@ -29,7 +26,6 @@ endif
 obj-$(CONFIG_SMP)			+= platsmp.o headsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
 
-obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= tegra114_speedo.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= sleep-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= pm-tegra30.o
 ifeq ($(CONFIG_CPU_IDLE),y)
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 99b9424..e243a8b 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -54,3 +54,4 @@ obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
 obj-y				+= mic/
 obj-$(CONFIG_GENWQE)		+= genwqe/
+obj-y				+= fuse/
-- 
1.7.7.rc0.72.g4b5ea.dirty

