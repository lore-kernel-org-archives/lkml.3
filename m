Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaAUVZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:25:25 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50696 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbaAUVZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:02 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>,
        Steffen Maier <maier@linux.vnet.ibm.com>, <linux390@de.ibm.com>,
        <linux-s390@vger.kernel.org>
Subject: [PATCH 36/73] s390: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:39 -0500
Message-ID: <1390339396-3479-37-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ursula Braun <ursula.braun@de.ibm.com>
Cc: Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/s390/block/dasd_erp.c    | 1 -
 drivers/s390/char/tape_34xx.c    | 1 -
 drivers/s390/char/tape_3590.c    | 1 -
 drivers/s390/char/tape_class.h   | 1 -
 drivers/s390/char/tape_core.c    | 1 -
 drivers/s390/cio/airq.c          | 1 -
 drivers/s390/cio/device_ops.c    | 1 -
 drivers/s390/cio/device_status.c | 1 -
 drivers/s390/net/ctcm_dbug.c     | 1 -
 drivers/s390/net/ctcm_fsms.c     | 1 -
 drivers/s390/net/ctcm_fsms.h     | 1 -
 drivers/s390/net/ctcm_mpc.c      | 1 -
 drivers/s390/scsi/zfcp_def.h     | 1 -
 13 files changed, 13 deletions(-)

diff --git a/drivers/s390/block/dasd_erp.c b/drivers/s390/block/dasd_erp.c
index e1e8848..0b9f823 100644
--- a/drivers/s390/block/dasd_erp.c
+++ b/drivers/s390/block/dasd_erp.c
@@ -11,7 +11,6 @@
 #define KMSG_COMPONENT "dasd"
 
 #include <linux/ctype.h>
-#include <linux/init.h>
 
 #include <asm/debug.h>
 #include <asm/ebcdic.h>
diff --git a/drivers/s390/char/tape_34xx.c b/drivers/s390/char/tape_34xx.c
index 9aa7970..2e3eb6a 100644
--- a/drivers/s390/char/tape_34xx.c
+++ b/drivers/s390/char/tape_34xx.c
@@ -11,7 +11,6 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/bio.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
diff --git a/drivers/s390/char/tape_3590.c b/drivers/s390/char/tape_3590.c
index 327cb19..e979c76 100644
--- a/drivers/s390/char/tape_3590.c
+++ b/drivers/s390/char/tape_3590.c
@@ -12,7 +12,6 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/bio.h>
 #include <asm/ebcdic.h>
 
diff --git a/drivers/s390/char/tape_class.h b/drivers/s390/char/tape_class.h
index a332c10..444ffdf 100644
--- a/drivers/s390/char/tape_class.h
+++ b/drivers/s390/char/tape_class.h
@@ -9,7 +9,6 @@
 #ifndef __TAPE_CLASS_H__
 #define __TAPE_CLASS_H__
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/major.h>
diff --git a/drivers/s390/char/tape_core.c b/drivers/s390/char/tape_core.c
index f3b5123..6edf6ae 100644
--- a/drivers/s390/char/tape_core.c
+++ b/drivers/s390/char/tape_core.c
@@ -14,7 +14,6 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/module.h>
-#include <linux/init.h>	     // for kernel parameters
 #include <linux/kmod.h>	     // for requesting modules
 #include <linux/spinlock.h>  // for locks
 #include <linux/vmalloc.h>
diff --git a/drivers/s390/cio/airq.c b/drivers/s390/cio/airq.c
index f055df0..897209a 100644
--- a/drivers/s390/cio/airq.c
+++ b/drivers/s390/cio/airq.c
@@ -8,7 +8,6 @@
  *		 Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
  */
 
-#include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/kernel_stat.h>
 #include <linux/module.h>
diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
index 4845d64..09de935 100644
--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -5,7 +5,6 @@
  *	      Cornelia Huck (cornelia.huck@de.ibm.com)
  */
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/list.h>
diff --git a/drivers/s390/cio/device_status.c b/drivers/s390/cio/device_status.c
index 15b56a1..323fa37 100644
--- a/drivers/s390/cio/device_status.c
+++ b/drivers/s390/cio/device_status.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 
 #include <asm/ccwdev.h>
 #include <asm/cio.h>
diff --git a/drivers/s390/net/ctcm_dbug.c b/drivers/s390/net/ctcm_dbug.c
index 8363f1c9..7fc399a 100644
--- a/drivers/s390/net/ctcm_dbug.c
+++ b/drivers/s390/net/ctcm_dbug.c
@@ -11,7 +11,6 @@
 #include <linux/ctype.h>
 #include <linux/sysctl.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/debugfs.h>
 #include "ctcm_dbug.h"
diff --git a/drivers/s390/net/ctcm_fsms.c b/drivers/s390/net/ctcm_fsms.c
index fb92524..0d64046 100644
--- a/drivers/s390/net/ctcm_fsms.c
+++ b/drivers/s390/net/ctcm_fsms.c
@@ -15,7 +15,6 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
diff --git a/drivers/s390/net/ctcm_fsms.h b/drivers/s390/net/ctcm_fsms.h
index c963d04..0ae2e8c 100644
--- a/drivers/s390/net/ctcm_fsms.h
+++ b/drivers/s390/net/ctcm_fsms.h
@@ -10,7 +10,6 @@
 #define _CTCM_FSMS_H_
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index 2dbc77b..f39bd3c 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -21,7 +21,6 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index d91173f..553eba9 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -11,7 +11,6 @@
 
 /*************************** INCLUDES *****************************************/
 
-#include <linux/init.h>
 #include <linux/moduleparam.h>
 #include <linux/major.h>
 #include <linux/blkdev.h>
-- 
1.8.4.1

