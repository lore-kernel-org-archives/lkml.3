Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3I0QuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:50:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:31639 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab3I0QuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:50:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,994,1371106800"; 
   d="scan'208";a="300200099"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 2/5] misc: mic: header file cleanups.
Date: Fri, 27 Sep 2013 09:49:42 -0700
Message-Id: <ac3062cba537458b0f317c9f9f4d0b8cf535c85d.1380289102.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1380289102.git.sudeep.dutt@intel.com>
References: <cover.1380289102.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dont use same name for header files in different folders.

These changes were suggested by Greg Kroah-Hartman during the
code review @ https://lkml.org/lkml/2013/9/6/18

Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/card/mic_debugfs.c                 | 2 +-
 drivers/misc/mic/card/mic_device.c                  | 2 +-
 drivers/misc/mic/card/mic_virtio.c                  | 2 +-
 drivers/misc/mic/card/mic_x100.c                    | 2 +-
 drivers/misc/mic/common/{mic_device.h => mic_dev.h} | 4 ++--
 drivers/misc/mic/host/mic_boot.c                    | 2 +-
 drivers/misc/mic/host/mic_debugfs.c                 | 2 +-
 drivers/misc/mic/host/mic_fops.c                    | 2 +-
 drivers/misc/mic/host/mic_intr.c                    | 2 +-
 drivers/misc/mic/host/mic_main.c                    | 2 +-
 drivers/misc/mic/host/mic_smpt.c                    | 2 +-
 drivers/misc/mic/host/mic_sysfs.c                   | 2 +-
 drivers/misc/mic/host/mic_virtio.c                  | 2 +-
 drivers/misc/mic/host/mic_x100.c                    | 2 +-
 14 files changed, 15 insertions(+), 15 deletions(-)
 rename drivers/misc/mic/common/{mic_device.h => mic_dev.h} (95%)

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
 
diff --git a/drivers/misc/mic/common/mic_device.h b/drivers/misc/mic/common/mic_dev.h
similarity index 95%
rename from drivers/misc/mic/common/mic_device.h
rename to drivers/misc/mic/common/mic_dev.h
index 01eb74f..92999c2 100644
--- a/drivers/misc/mic/common/mic_device.h
+++ b/drivers/misc/mic/common/mic_dev.h
@@ -18,8 +18,8 @@
  * Intel MIC driver.
  *
  */
-#ifndef __MIC_COMMON_DEVICE_H_
-#define __MIC_COMMON_DEVICE_H_
+#ifndef __MIC_DEV_H__
+#define __MIC_DEV_H__
 
 /**
  * struct mic_mw - MIC memory window
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

