Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129Ab3AQCzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:55:33 -0500
Received: from smtp.outflux.net ([198.145.64.163]:38231 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759095Ab3AQCz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:55:27 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Joerg Roedel <joerg.roedel@amd.com>,
        Hiroshi DOYU <hdoyu@nvidia.com>, Jiri Kosina <jkosina@suse.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 47/86] drivers/iommu: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:39 -0800
Message-Id: <1358391258-1771-48-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Joerg Roedel <joerg.roedel@amd.com>
CC: Hiroshi DOYU <hdoyu@nvidia.com>
CC: Jiri Kosina <jkosina@suse.cz>
CC: Kukjin Kim <kgene.kim@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/iommu/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index e39f9db..0106898 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -65,8 +65,8 @@ config AMD_IOMMU_STATS
 	  If unsure, say N.
 
 config AMD_IOMMU_V2
-	tristate "AMD IOMMU Version 2 driver (EXPERIMENTAL)"
-	depends on AMD_IOMMU && PROFILING && EXPERIMENTAL
+	tristate "AMD IOMMU Version 2 driver"
+	depends on AMD_IOMMU && PROFILING
 	select MMU_NOTIFIER
 	---help---
 	  This option enables support for the AMD IOMMUv2 features of the IOMMU
@@ -119,8 +119,8 @@ config INTEL_IOMMU_FLOPPY_WA
 	  16MiB to make floppy (an ISA device) work.
 
 config IRQ_REMAP
-	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
-	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
+	bool "Support for Interrupt Remapping"
+	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI
 	select DMAR_TABLE
 	---help---
 	  Supports Interrupt remapping for IO-APIC and MSI devices.
-- 
1.7.9.5

