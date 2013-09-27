Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3I0BKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 21:10:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:46617 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab3I0BKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 21:10:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,989,1371106800"; 
   d="scan'208";a="299939026"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH CHAR-MISC-NEXT 2/4] Intel MIC Driver Header File Cleanups.
Date: Thu, 26 Sep 2013 18:10:01 -0700
Message-Id: <1db9ec1d28297b01c01f0f4089cb5ce559906ac8.1380241770.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1380241770.git.sudeep.dutt@intel.com>
References: <cover.1380241770.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dont use same name for header files in different folders.

These changes were suggested by Greg Kroah-Hartman during the
code review @ https://lkml.org/lkml/2013/9/6/18

Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/card/mic_debugfs.c  |  2 +-
 drivers/misc/mic/card/mic_device.c   |  2 +-
 drivers/misc/mic/card/mic_virtio.c   |  2 +-
 drivers/misc/mic/card/mic_x100.c     |  2 +-
 drivers/misc/mic/common/mic_dev.h    | 51 ++++++++++++++++++++++++++++++++++++
 drivers/misc/mic/common/mic_device.h | 51 ------------------------------------
 drivers/misc/mic/host/mic_boot.c     |  2 +-
 drivers/misc/mic/host/mic_debugfs.c  |  2 +-
 drivers/misc/mic/host/mic_fops.c     |  2 +-
 drivers/misc/mic/host/mic_intr.c     |  2 +-
 drivers/misc/mic/host/mic_main.c     |  2 +-
 drivers/misc/mic/host/mic_smpt.c     |  2 +-
 drivers/misc/mic/host/mic_sysfs.c    |  2 +-
 drivers/misc/mic/host/mic_virtio.c   |  2 +-
 drivers/misc/mic/host/mic_x100.c     |  2 +-
 15 files changed, 64 insertions(+), 64 deletions(-)
 create mode 100644 drivers/misc/mic/common/mic_dev.h
 delete mode 100644 drivers/misc/mic/common/mic_device.h

diff --git a/drivers/misc/mic/card/mic_debugfs.c b/drivers/misc/mic/card/mic_debugfs.c
index 95cf186..421b3d7 100644
--- a/drivers/misc/mic/card/mic_debugfs.c
+++ b/drivers/misc/mic/card/mic_debugfs.c
@@ -30,7 +30,7 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 
-#include "../common/mic_device.h"
+#include "../common/mic_dev.h"
 #include "mic_device.h"
 
 /* Debugfs parent dir */
diff --git a/drivers/misc/mic/card/mic_device.c b/drivers/misc/mic/card/mic_device.c
index 4125217..175d114 100644
--- a/drivers/misc/mic/card/mic_device.c
+++ b/drivers/misc/mic/card/mic_device.c
@@ -30,7 +30,7 @@
 #include <linux/reboot.h>
 
 #include <linux/mic_common.h>
-#include "../common/mic_device.h"
+#include "../common/mic_dev.h"
 #include "mic_device.h"
 #include "mic_virtio.h"
 
diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
index 38275c1..7420c33 100644
--- a/drivers/misc/mic/card/mic_virtio.c
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -40,7 +40,7 @@
 #include <linux/slab.h>
 #include <linux/virtio_config.h>
 
-#include "../common/mic_device.h"
+#include "../common/mic_dev.h"
 #include "mic_virtio.h"
 
 #define VIRTIO_SUBCODE_64 0x0D00
diff --git a/drivers/misc/mic/card/mic_x100.c b/drivers/misc/mic/card/mic_x100.c
index 7cb3469..f491c91 100644
--- a/drivers/misc/mic/card/mic_x100.c
+++ b/drivers/misc/mic/card/mic_x100.c
@@ -28,7 +28,7 @@
 #include <linux/pci.h>
 #include <linux/platform_device.h>
 
-#include "../common/mic_device.h"
+#include "../common/mic_dev.h"
 #include "mic_device.h"
 #include "mic_x100.h"
 
diff --git a/drivers/misc/mic/common/mic_dev.h b/drivers/misc/mic/common/mic_dev.h
new file mode 100644
index 0000000..92999c2
--- /dev/null
+++ b/drivers/misc/mic/common/mic_dev.h
@@ -0,0 +1,51 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC driver.
+ *
+ */
+#ifndef __MIC_DEV_H__
+#define __MIC_DEV_H__
+
+/**
+ * struct mic_mw - MIC memory window
+ *
+ * @pa: Base physical address.
+ * @va: Base ioremap'd virtual address.
+ * @len: Size of the memory window.
+ */
+struct mic_mw {
+	phys_addr_t pa;
+	void __iomem *va;
+	resource_size_t len;
+};
+
+/*
+ * Scratch pad register offsets used by the host to communicate
+ * device page DMA address to the card.
+ */
+#define MIC_DPLO_SPAD 14
+#define MIC_DPHI_SPAD 15
+
+/*
+ * These values are supposed to be in the config_change field of the
+ * device page when the host sends a config change interrupt to the card.
+ */
+#define MIC_VIRTIO_PARAM_DEV_REMOVE 0x1
+#define MIC_VIRTIO_PARAM_CONFIG_CHANGED 0x2
+
+#endif
diff --git a/drivers/misc/mic/common/mic_device.h b/drivers/misc/mic/common/mic_device.h
deleted file mode 100644
index 01eb74f..0000000
--- a/drivers/misc/mic/common/mic_device.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
- * Intel MIC Platform Software Stack (MPSS)
- *
- * Copyright(c) 2013 Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License, version 2, as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
- * General Public License for more details.
- *
- * The full GNU General Public License is included in this distribution in
- * the file called "COPYING".
- *
- * Intel MIC driver.
- *
- */
-#ifndef __MIC_COMMON_DEVICE_H_
-#define __MIC_COMMON_DEVICE_H_
-
-/**
- * struct mic_mw - MIC memory window
- *
- * @pa: Base physical address.
- * @va: Base ioremap'd virtual address.
- * @len: Size of the memory window.
- */
-struct mic_mw {
-	phys_addr_t pa;
-	void __iomem *va;
-	resource_size_t len;
-};
-
-/*
- * Scratch pad register offsets used by the host to communicate
- * device page DMA address to the card.
- */
-#define MIC_DPLO_SPAD 14
-#define MIC_DPHI_SPAD 15
-
-/*
- * These values are supposed to be in the config_change field of the
- * device page when the host sends a config change interrupt to the card.
- */
-#define MIC_VIRTIO_PARAM_DEV_REMOVE 0x1
-#define MIC_VIRTIO_PARAM_CONFIG_CHANGED 0x2
-
-#endif
diff --git a/drivers/misc/mic/host/mic_boot.c b/drivers/misc/mic/host/mic_boot.c
index fd9ff6d..60c54d5 100644
--- a/drivers/misc/mic/host/mic_boot.c
+++ b/drivers/misc/mic/host/mic_boot.c
@@ -22,7 +22,7 @@
 #include <linux/firmware.h>
 
 #include <linux/mic_common.h>
-#include "../common/mic_device.h"
+#include "../common/mic_dev.h"
 #include "mic_device.h"
 #include "mic_smpt.h"
 #include "mic_virtio.h"
diff --git a/drivers/misc/mic/host/mic_debugfs.c b/drivers/misc/mic/host/mic_debugfs.c
index e22fb7b..98a61b4 100644
--- a/drivers/misc/mic/host/mic_debugfs.c
+++ b/drivers/misc/mic/host/mic_debugfs.c
@@ -23,7 +23,7 @@
 #include <linux/seq_file.h>
 
 #include <linux/mic_common.h>
-#include "../common/mic_device.h"
+#include "../common/mic_dev.h"
 #include "mic_device.h"
 #include "mic_smpt.h"
 #include "mic_virtio.h"
diff --git a/drivers/misc/mic/host/mic_fops.c b/drivers/misc/mic/host/mic_fops.c
index 661469a..e699c80 100644
--- a/drivers/misc/mic/host/mic_fops.c
+++ b/drivers/misc/mic/host/mic_fops.c
@@ -21,7 +21,7 @@
 #include <linux/poll.h>
 
 #include <linux/mic_common.h>
-#include "../common/mic_device.h"
+#include "../common/mic_dev.h"
 #include "mic_device.h"
 #include "mic_fops.h"
 #include "mic_virtio.h"
diff --git a/drivers/misc/mic/host/mic_intr.c b/drivers/misc/mic/host/mic_intr.c
index cdae314..71a7521 100644
--- a/drivers/misc/mic/host/mic_intr.c
+++ b/drivers/misc/mic/host/mic_intr.c
@@ -21,7 +21,7 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 
-#include "../common/mic_device.h"
+#include "../common/mic_dev.h"
 #include "mic_device.h"
 
 /*
diff --git a/drivers/misc/mic/host/mic_main.c b/drivers/misc/mic/host/mic_main.c
index a8965d4..ca06aa9 100644
--- a/drivers/misc/mic/host/mic_main.c
+++ b/drivers/misc/mic/host/mic_main.c
@@ -28,7 +28,7 @@
 #include <linux/poll.h>
 
 #include <linux/mic_common.h>
-#include "../common/mic_device.h"
+#include "../common/mic_dev.h"
 #include "mic_device.h"
 #include "mic_x100.h"
 #include "mic_smpt.h"
diff --git a/drivers/misc/mic/host/mic_smpt.c b/drivers/misc/mic/host/mic_smpt.c
index a346207..003d02b 100644
--- a/drivers/misc/mic/host/mic_smpt.c
+++ b/drivers/misc/mic/host/mic_smpt.c
@@ -20,7 +20,7 @@
  */
 #include <linux/pci.h>
 
-#include "../common/mic_device.h"
+#include "../common/mic_dev.h"
 #include "mic_device.h"
 #include "mic_smpt.h"
 
diff --git a/drivers/misc/mic/host/mic_sysfs.c b/drivers/misc/mic/host/mic_sysfs.c
index bebbae2..029a4f3 100644
--- a/drivers/misc/mic/host/mic_sysfs.c
+++ b/drivers/misc/mic/host/mic_sysfs.c
@@ -21,7 +21,7 @@
 #include <linux/pci.h>
 
 #include <linux/mic_common.h>
-#include "../common/mic_device.h"
+#include "../common/mic_dev.h"
 #include "mic_device.h"
 
 /*
diff --git a/drivers/misc/mic/host/mic_virtio.c b/drivers/misc/mic/host/mic_virtio.c
index be2a1f0..9e0456f 100644
--- a/drivers/misc/mic/host/mic_virtio.c
+++ b/drivers/misc/mic/host/mic_virtio.c
@@ -23,7 +23,7 @@
 #include <linux/uaccess.h>
 
 #include <linux/mic_common.h>
-#include "../common/mic_device.h"
+#include "../common/mic_dev.h"
 #include "mic_device.h"
 #include "mic_smpt.h"
 #include "mic_virtio.h"
diff --git a/drivers/misc/mic/host/mic_x100.c b/drivers/misc/mic/host/mic_x100.c
index a12ae5c..3a0d660 100644
--- a/drivers/misc/mic/host/mic_x100.c
+++ b/drivers/misc/mic/host/mic_x100.c
@@ -24,7 +24,7 @@
 #include <linux/firmware.h>
 #include <linux/delay.h>
 
-#include "../common/mic_device.h"
+#include "../common/mic_dev.h"
 #include "mic_device.h"
 #include "mic_x100.h"
 #include "mic_smpt.h"
-- 
1.8.2.1

