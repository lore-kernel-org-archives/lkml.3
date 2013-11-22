Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab3KVXdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 18:33:02 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63454 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab3KVXcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 18:32:55 -0500
From: Lv Zheng <zetalog@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <zetalog@gmail.com>, Lv Zheng <lv.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 3/4] ACPICA: Cleanup <acpi/acpi.h> inclusions.
Date: Sat, 23 Nov 2013 07:32:01 +0800
Message-Id: <32e38589d3ca7b01c13f2390bf49210a02f3ed97.1385094641.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1385094640.git.lv.zheng@intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

This patch cleans up <acpi/acpi.h> inclusions.

1. For files where <linux/acpi.h> is already included, this patch cleans up
   them by deleting <acpi/acpi.h> inclusions.  Note that if <acpi/acpi.h>
   is included before including <linux/acpi.h> in the original file, the
   inclusion of <linux/acpi.h> is moved up to avoid issues from happening.
2. The sfi_acpi files have invoked acpi_table_parse(), so this patch
   converts <acpi/acpi.h> inclusions into <linux/acpi.h> inclusions so that
   they can find the acpi_parse_table() prototypes.
3. For files where only <acpi/acpi.h> included, this patch cleans up them
   by replacing <acpi/acpi.h> inclusions with <linux/acpi.h>.  Such files
   are those include ACPICA headers to find table definitions or ACPICA
   basic types.
4. For files where no actual ACPICA references, this patch cleans up them
   by deleting <acpi/acpi.h> inclusions.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 arch/x86/pci/mmconfig_32.c             |    1 -
 drivers/acpi/apei/einj.c               |    1 -
 drivers/acpi/osl.c                     |    1 -
 drivers/char/tpm/tpm_acpi.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c |    1 -
 drivers/hwmon/asus_atk0110.c           |    1 -
 drivers/ide/ide-acpi.c                 |    1 -
 drivers/iommu/amd_iommu_init.c         |    1 -
 drivers/iommu/intel_irq_remapping.c    |    2 +-
 drivers/pci/hotplug/pciehp.h           |    1 -
 drivers/pci/pci-acpi.c                 |    1 -
 drivers/platform/x86/tc1100-wmi.c      |    1 -
 drivers/sfi/sfi_acpi.c                 |    2 +-
 include/linux/acpi_io.h                |    2 +-
 include/linux/ide.h                    |    3 ---
 include/linux/iscsi_ibft.h             |    2 +-
 include/linux/pci_hotplug.h            |    1 -
 include/linux/sfi_acpi.h               |    2 +-
 include/linux/tboot.h                  |    2 +-
 19 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
index 5c90975..43984bc 100644
--- a/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
@@ -14,7 +14,6 @@
 #include <linux/rcupdate.h>
 #include <asm/e820.h>
 #include <asm/pci_x86.h>
-#include <acpi/acpi.h>
 
 /* Assume systems with more busses have correct MCFG */
 #define mmcfg_virt_addr ((void __iomem *) fix_to_virt(FIX_PCIE_MCFG))
diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index fb57d03..ca0c6d7 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -33,7 +33,6 @@
 #include <linux/nmi.h>
 #include <linux/delay.h>
 #include <linux/mm.h>
-#include <acpi/acpi.h>
 
 #include "apei-internal.h"
 
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 8507034..c4a0e45 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -49,7 +49,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
-#include <acpi/acpi.h>
 #include <acpi/processor.h>
 #include "internal.h"
 
diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
index 64420b3..b9a57fa 100644
--- a/drivers/char/tpm/tpm_acpi.c
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -23,7 +23,7 @@
 #include <linux/security.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <acpi/acpi.h>
+#include <linux/acpi.h>
 
 #include "tpm.h"
 #include "tpm_eventlog.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index 6763865..5910ef5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -2,7 +2,6 @@
 #include <linux/acpi.h>
 #include <linux/slab.h>
 #include <acpi/video.h>
-#include <acpi/acpi.h>
 #include <linux/mxm-wmi.h>
 
 #include <linux/vga_switcheroo.h>
diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index 9b64d26..eea1f60 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -17,7 +17,6 @@
 #include <linux/jiffies.h>
 #include <linux/err.h>
 
-#include <acpi/acpi.h>
 #include <linux/acpi.h>
 
 
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index d9e1f7c..333d405 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -14,7 +14,6 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <acpi/acpi.h>
 #include <linux/ide.h>
 #include <linux/pci.h>
 #include <linux/dmi.h>
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 8f798be..28b4bea 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -26,7 +26,6 @@
 #include <linux/msi.h>
 #include <linux/amd-iommu.h>
 #include <linux/export.h>
-#include <acpi/acpi.h>
 #include <asm/pci-direct.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index bab10b1..01c1dd9 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -10,7 +10,7 @@
 #include <asm/smp.h>
 #include <asm/cpu.h>
 #include <linux/intel-iommu.h>
-#include <acpi/acpi.h>
+#include <linux/acpi.h>
 #include <asm/irq_remapping.h>
 #include <asm/pci-direct.h>
 #include <asm/msidef.h>
diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index f773254..fc51cab 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -163,7 +163,6 @@ static inline const char *slot_name(struct slot *slot)
 }
 
 #ifdef CONFIG_ACPI
-#include <acpi/acpi.h>
 #include <linux/pci-acpi.h>
 
 void __init pciehp_acpi_slot_detection_init(void);
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index d0e4999..4c77380 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -12,7 +12,6 @@
 #include <linux/pci.h>
 #include <linux/module.h>
 #include <linux/pci-aspm.h>
-#include <acpi/acpi.h>
 
 #include <linux/pci-acpi.h>
 #include <linux/pm_runtime.h>
diff --git a/drivers/platform/x86/tc1100-wmi.c b/drivers/platform/x86/tc1100-wmi.c
index d16193e..6a6ea28 100644
--- a/drivers/platform/x86/tc1100-wmi.c
+++ b/drivers/platform/x86/tc1100-wmi.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <acpi/acpi.h>
 #include <linux/acpi.h>
 #include <linux/platform_device.h>
 
diff --git a/drivers/sfi/sfi_acpi.c b/drivers/sfi/sfi_acpi.c
index f5b4ca5..5589ec5 100644
--- a/drivers/sfi/sfi_acpi.c
+++ b/drivers/sfi/sfi_acpi.c
@@ -60,7 +60,7 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/kernel.h>
-#include <acpi/acpi.h>
+#include <linux/acpi.h>
 
 #include <linux/sfi.h>
 #include "sfi_core.h"
diff --git a/include/linux/acpi_io.h b/include/linux/acpi_io.h
index b0ffa21..ded96fe 100644
--- a/include/linux/acpi_io.h
+++ b/include/linux/acpi_io.h
@@ -2,7 +2,7 @@
 #define _ACPI_IO_H_
 
 #include <linux/io.h>
-#include <acpi/acpi.h>
+#include <linux/acpi.h>
 
 static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
 					    acpi_size size)
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 46a1422..f29a6de 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -18,9 +18,6 @@
 #include <linux/completion.h>
 #include <linux/pm.h>
 #include <linux/mutex.h>
-#ifdef CONFIG_BLK_DEV_IDEACPI
-#include <acpi/acpi.h>
-#endif
 #include <asm/byteorder.h>
 #include <asm/io.h>
 
diff --git a/include/linux/iscsi_ibft.h b/include/linux/iscsi_ibft.h
index 8ba7e5b..605cc5c 100644
--- a/include/linux/iscsi_ibft.h
+++ b/include/linux/iscsi_ibft.h
@@ -21,7 +21,7 @@
 #ifndef ISCSI_IBFT_H
 #define ISCSI_IBFT_H
 
-#include <acpi/acpi.h>
+#include <linux/acpi.h>
 
 /*
  * Logical location of iSCSI Boot Format Table.
diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
index 71294ab..e6a5e99 100644
--- a/include/linux/pci_hotplug.h
+++ b/include/linux/pci_hotplug.h
@@ -175,7 +175,6 @@ struct hotplug_params {
 };
 
 #ifdef CONFIG_ACPI
-#include <acpi/acpi.h>
 #include <linux/acpi.h>
 int pci_get_hp_params(struct pci_dev *dev, struct hotplug_params *hpp);
 int acpi_get_hp_hw_control_from_firmware(struct pci_dev *dev, u32 flags);
diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
index 631af63..c9cab82 100644
--- a/include/linux/sfi_acpi.h
+++ b/include/linux/sfi_acpi.h
@@ -60,7 +60,7 @@
 #define _LINUX_SFI_ACPI_H
 
 #ifdef CONFIG_SFI
-#include <acpi/acpi.h>		/* struct acpi_table_header */
+#include <linux/acpi.h>
 
 extern int sfi_acpi_table_parse(char *signature, char *oem_id,
 				char *oem_table_id,
diff --git a/include/linux/tboot.h b/include/linux/tboot.h
index c75128b..9a54b33 100644
--- a/include/linux/tboot.h
+++ b/include/linux/tboot.h
@@ -34,7 +34,7 @@ enum {
 };
 
 #ifdef CONFIG_INTEL_TXT
-#include <acpi/acpi.h>
+#include <linux/acpi.h>
 /* used to communicate between tboot and the launched kernel */
 
 #define TB_KEY_SIZE             64   /* 512 bits */
-- 
1.7.10

