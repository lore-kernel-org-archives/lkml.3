Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbaFYRuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:50:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50825 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535AbaFYRun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:50:43 -0400
From: Christopher Covington <cov@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Covington <cov@codeaurora.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Rob Herring <robh@kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Matthew Leach <matthew.leach@arm.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Nicolas Pitre <nico@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ARM: virt, vexpress: Use 64-bit DMA for LPAE
Date: Wed, 25 Jun 2014 13:50:28 -0400
Message-Id: <1403718631-25194-1-git-send-email-cov@codeaurora.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <5331B14B.7040103@codeaurora.org>
References: <5331B14B.7040103@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an LPAE system, the physical addresses used by VirtIO-MMIO may be
higher than 32 bits. For example on a Versatile Express system with
4G RAM, the following error surfaces when trying to use a VirtIO-MMIO
block device.

EXT2-fs (vda): error: ext2_check_page: bad entry in directory #2: : unaligned directory entry - offset=0, inode=3755990991, rec_len=57311, name_len=223

To fix this, select ARCH_DMA_ADDR_T_64BIT when LPAE is selected
and mach-vexpress, mach-virt, or both are being built.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arch/arm/Kconfig               | 1 +
 arch/arm/mach-vexpress/Kconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 245058b..8407c28 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -901,6 +901,7 @@ endmenu
 
 config ARCH_VIRT
 	bool "Dummy Virtual Machine" if ARCH_MULTI_V7
+	select ARCH_DMA_ADDR_T_64BIT if ARM_LPAE
 	select ARM_AMBA
 	select ARM_GIC
 	select ARM_PSCI
diff --git a/arch/arm/mach-vexpress/Kconfig b/arch/arm/mach-vexpress/Kconfig
index 99c1f15..5f33e16 100644
--- a/arch/arm/mach-vexpress/Kconfig
+++ b/arch/arm/mach-vexpress/Kconfig
@@ -1,5 +1,6 @@
 menuconfig ARCH_VEXPRESS
 	bool "ARM Ltd. Versatile Express family" if ARCH_MULTI_V7
+	select ARCH_DMA_ADDR_T_64BIT if ARM_LPAE
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ARM_AMBA
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by the Linux Foundation.

