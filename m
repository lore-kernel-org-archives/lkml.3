Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaAUV3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:29:23 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50832 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbaAUVZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:52 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 73/73] include: remove needless instances of <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:16 -0500
Message-ID: <1390339396-3479-74-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In removing __cpuinit and __devinit support, some files will
no longer need to include <linux/init.h>.  Here we audit the
include files themselves, looking for cases where init.h is
sourced but not actually used.  With these cleaned up, we'll
know that the odds of C files implicitly getting init.h from
random headers in here are somewhat reduced.

Some files were getting other headers via init.h, such as:

In file included from fs/cifs/winucase.c:32:0:
include/linux/nls.h:16:1: error: unknown type name ‘u16’

and so their includes were adjusted to reflect what they
were actually requiring.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/drm/drmP.h          | 2 +-
 include/linux/fb.h          | 1 -
 include/linux/ide.h         | 1 -
 include/linux/kdb.h         | 1 -
 include/linux/lsm_audit.h   | 1 -
 include/linux/moduleparam.h | 1 -
 include/linux/netfilter.h   | 1 -
 include/linux/nls.h         | 2 +-
 include/linux/percpu_ida.h  | 1 -
 include/linux/profile.h     | 1 -
 include/linux/pstore_ram.h  | 1 -
 include/linux/usb/gadget.h  | 1 -
 include/linux/zorro.h       | 1 -
 include/xen/xenbus.h        | 1 -
 14 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 63eab2b..c883f41 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -45,7 +45,7 @@
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
-#include <linux/init.h>
+#include <linux/proc_fs.h>
 #include <linux/file.h>
 #include <linux/platform_device.h>
 #include <linux/pci.h>
diff --git a/include/linux/fb.h b/include/linux/fb.h
index fe6ac95..a23ab6c 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -7,7 +7,6 @@
 #define FBIO_CURSOR            _IOWR('F', 0x08, struct fb_cursor_user)
 
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
 #include <linux/list.h>
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 93b5ca7..9aa3e3a 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -6,7 +6,6 @@
  *  Copyright (C) 1994-2002  Linus Torvalds & authors
  */
 
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/ata.h>
 #include <linux/blkdev.h>
diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 290db12..8718e15 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -22,7 +22,6 @@ typedef enum {
 typedef int (*kdb_func_t)(int, const char **);
 
 #ifdef	CONFIG_KGDB_KDB
-#include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/atomic.h>
 
diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index 1cc89e9..da30bf5 100644
--- a/include/linux/lsm_audit.h
+++ b/include/linux/lsm_audit.h
@@ -15,7 +15,6 @@
 #include <linux/kernel.h>
 #include <linux/kdev_t.h>
 #include <linux/spinlock.h>
-#include <linux/init.h>
 #include <linux/audit.h>
 #include <linux/in6.h>
 #include <linux/path.h>
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index c3eb102..72e584b 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_MODULE_PARAMS_H
 #define _LINUX_MODULE_PARAMS_H
 /* (C) Copyright 2001, 2002 Rusty Russell IBM Corporation */
-#include <linux/init.h>
 #include <linux/stringify.h>
 #include <linux/kernel.h>
 
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 2077489..e4f2878 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -1,7 +1,6 @@
 #ifndef __LINUX_NETFILTER_H
 #define __LINUX_NETFILTER_H
 
-#include <linux/init.h>
 #include <linux/skbuff.h>
 #include <linux/net.h>
 #include <linux/if.h>
diff --git a/include/linux/nls.h b/include/linux/nls.h
index 5dc635f..da8c447 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_NLS_H
 #define _LINUX_NLS_H
 
-#include <linux/init.h>
+#include <linux/types.h>
 
 /* Unicode has changed over the years.  Unicode code points no longer
  * fit into 16 bits; as of Unicode 5 valid code points range from 0
diff --git a/include/linux/percpu_ida.h b/include/linux/percpu_ida.h
index 1900bd0..bc706f1 100644
--- a/include/linux/percpu_ida.h
+++ b/include/linux/percpu_ida.h
@@ -3,7 +3,6 @@
 
 #include <linux/types.h>
 #include <linux/bitops.h>
-#include <linux/init.h>
 #include <linux/spinlock_types.h>
 #include <linux/wait.h>
 #include <linux/cpumask.h>
diff --git a/include/linux/profile.h b/include/linux/profile.h
index aaad386..dc04999 100644
--- a/include/linux/profile.h
+++ b/include/linux/profile.h
@@ -2,7 +2,6 @@
 #define _LINUX_PROFILE_H
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/cpumask.h>
 #include <linux/cache.h>
 
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index 9974975..1c1b44e 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -21,7 +21,6 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/types.h>
-#include <linux/init.h>
 
 struct persistent_ram_buffer;
 struct rs_control;
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index c3a6185..4300742 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -17,7 +17,6 @@
 
 #include <linux/device.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/scatterlist.h>
diff --git a/include/linux/zorro.h b/include/linux/zorro.h
index 63fbba0..529604b 100644
--- a/include/linux/zorro.h
+++ b/include/linux/zorro.h
@@ -15,7 +15,6 @@
 #include <uapi/linux/zorro.h>
 
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/mod_devicetable.h>
 
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 569c07f..094ffa1 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -39,7 +39,6 @@
 #include <linux/mutex.h>
 #include <linux/export.h>
 #include <linux/completion.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/grant_table.h>
-- 
1.8.4.1

