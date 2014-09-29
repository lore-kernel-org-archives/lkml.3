Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaI2NdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:33:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:32046 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbaI2NdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:33:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393030099"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 14/18] mei: remove include to pci header from mei module files
Date: Mon, 29 Sep 2014 16:31:46 +0300
Message-Id: <1411997510-29094-15-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
References: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove inclusion of linux/pci.h in mei layer
however we need to include the headers that before
got included implicitly from linux/pci.h.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    | 2 +-
 drivers/misc/mei/bus.c       | 1 -
 drivers/misc/mei/client.c    | 2 +-
 drivers/misc/mei/debugfs.c   | 1 -
 drivers/misc/mei/hbm.c       | 5 +++--
 drivers/misc/mei/init.c      | 1 -
 drivers/misc/mei/interrupt.c | 2 +-
 drivers/misc/mei/main.c      | 2 +-
 drivers/misc/mei/nfc.c       | 3 ++-
 drivers/misc/mei/wd.c        | 1 -
 include/linux/mei_cl_bus.h   | 1 +
 11 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 5d47d1b..d9b0e761f 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -20,7 +20,6 @@
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/aio.h>
-#include <linux/pci.h>
 #include <linux/ioctl.h>
 #include <linux/cdev.h>
 #include <linux/list.h>
@@ -29,6 +28,7 @@
 #include <linux/uuid.h>
 #include <linux/jiffies.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 
 #include <linux/mei.h>
 
diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 4cc1a66..4d20d60 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -22,7 +22,6 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/mei_cl_bus.h>
 
 #include "mei_dev.h"
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index bfc3ad2..04a1964 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -14,10 +14,10 @@
  *
  */
 
-#include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/pm_runtime.h>
 
 #include <linux/mei.h>
diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index e14a7db..aca7847 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -17,7 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/debugfs.h>
-#include <linux/pci.h>
 
 #include <linux/mei.h>
 
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 209650b..c874fdd 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -15,11 +15,12 @@
  */
 
 #include <linux/export.h>
-#include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
-#include <linux/mei.h>
 #include <linux/pm_runtime.h>
+#include <linux/slab.h>
+
+#include <linux/mei.h>
 
 #include "mei_dev.h"
 #include "hbm.h"
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index dd233fd..76ef8ff 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -15,7 +15,6 @@
  */
 
 #include <linux/export.h>
-#include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/delay.h>
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 8dac769..8844e17 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -16,11 +16,11 @@
 
 
 #include <linux/export.h>
-#include <linux/pci.h>
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
 #include <linux/fs.h>
 #include <linux/jiffies.h>
+#include <linux/slab.h>
 
 #include <linux/mei.h>
 
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 4d738c8..d31f271 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -17,12 +17,12 @@
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
+#include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/aio.h>
-#include <linux/pci.h>
 #include <linux/poll.h>
 #include <linux/init.h>
 #include <linux/ioctl.h>
diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 9f32fd6..5b369f4 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -19,7 +19,8 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/device.h>
-#include <linux/pci.h>
+#include <linux/slab.h>
+
 #include <linux/mei_cl_bus.h>
 
 #include "mei_dev.h"
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index d28511b..626b4c1 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -17,7 +17,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/device.h>
-#include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/watchdog.h>
 
diff --git a/include/linux/mei_cl_bus.h b/include/linux/mei_cl_bus.h
index d14af7b..164aad1 100644
--- a/include/linux/mei_cl_bus.h
+++ b/include/linux/mei_cl_bus.h
@@ -3,6 +3,7 @@
 
 #include <linux/device.h>
 #include <linux/uuid.h>
+#include <linux/mod_devicetable.h>
 
 struct mei_cl_device;
 
-- 
1.9.3

