Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaK0Rd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:33:58 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:63855 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaK0Rdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:33:55 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        linux-kernel@vger.kernel.org (open list),
        kvm@vger.kernel.org (open list:VFIO DRIVER)
Subject: [PATCH v10 03/20] vfio: platform: add the VFIO PLATFORM module to Kconfig
Date: Thu, 27 Nov 2014 18:32:43 +0100
Message-Id: <1417109580-10505-4-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable building the VFIO PLATFORM driver that allows to use Linux platform
devices with VFIO.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/Kconfig           | 1 +
 drivers/vfio/Makefile          | 1 +
 drivers/vfio/platform/Kconfig  | 9 +++++++++
 drivers/vfio/platform/Makefile | 4 ++++
 4 files changed, 15 insertions(+)
 create mode 100644 drivers/vfio/platform/Kconfig
 create mode 100644 drivers/vfio/platform/Makefile

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index a0abe04..962fb80 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -27,3 +27,4 @@ menuconfig VFIO
 	  If you don't know what to do here, say N.
 
 source "drivers/vfio/pci/Kconfig"
+source "drivers/vfio/platform/Kconfig"
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 0b035b1..dadf0ca 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
 obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
 obj-$(CONFIG_VFIO_PCI) += pci/
+obj-$(CONFIG_VFIO_PLATFORM) += platform/
diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
new file mode 100644
index 0000000..c51af17
--- /dev/null
+++ b/drivers/vfio/platform/Kconfig
@@ -0,0 +1,9 @@
+config VFIO_PLATFORM
+	tristate "VFIO support for platform devices"
+	depends on VFIO && EVENTFD && ARM
+	help
+	  Support for platform devices with VFIO. This is required to make
+	  use of platform devices present on the system using the VFIO
+	  framework.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
new file mode 100644
index 0000000..279862b
--- /dev/null
+++ b/drivers/vfio/platform/Makefile
@@ -0,0 +1,4 @@
+
+vfio-platform-y := vfio_platform.o vfio_platform_common.o
+
+obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
-- 
2.1.3

