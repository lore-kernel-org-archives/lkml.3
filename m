Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaIISk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:40:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:15637 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbaIISks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:40:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,492,1406617200"; 
   d="scan'208";a="570725351"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 7/7] staging/lustre: remove lvfs.h
Date: Tue, 9 Sep 2014 13:39:08 -0500
Message-ID: <1410287948-13168-8-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410287948-13168-1-git-send-email-john.hammond@intel.com>
References: <1410287948-13168-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.106]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Move the definition of struct lvfs_run_ctxt to the one file that
needed it (lustre/include/obd.h). Remove the then unneeded headers
lustre/include/lvfs.h and lustre/include/linux/lvfs.h.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/include/cl_object.h  |    2 +-
 drivers/staging/lustre/lustre/include/linux/lvfs.h |   57 --------------------
 drivers/staging/lustre/lustre/include/lvfs.h       |   45 ----------------
 drivers/staging/lustre/lustre/include/obd.h        |    4 ++
 .../staging/lustre/lustre/include/obd_support.h    |    2 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/llog_net.c    |    1 -
 7 files changed, 7 insertions(+), 106 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lvfs.h
 delete mode 100644 drivers/staging/lustre/lustre/include/lvfs.h

diff --git a/drivers/staging/lustre/lustre/include/cl_object.h b/drivers/staging/lustre/lustre/include/cl_object.h
index 41858e4..d56c8be 100644
--- a/drivers/staging/lustre/lustre/include/cl_object.h
+++ b/drivers/staging/lustre/lustre/include/cl_object.h
@@ -98,7 +98,7 @@
  * super-class definitions.
  */
 #include "lu_object.h"
-#include "lvfs.h"
+#include "linux/lustre_compat25.h"
 #include <linux/mutex.h>
 #include <linux/radix-tree.h>
 
diff --git a/drivers/staging/lustre/lustre/include/linux/lvfs.h b/drivers/staging/lustre/lustre/include/linux/lvfs.h
deleted file mode 100644
index 786e779..0000000
--- a/drivers/staging/lustre/lustre/include/linux/lvfs.h
+++ /dev/null
@@ -1,57 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2003, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/include/linux/lvfs.h
- *
- * lustre VFS/process permission interface
- */
-
-#ifndef __LINUX_LVFS_H__
-#define __LINUX_LVFS_H__
-
-#ifndef __LVFS_H__
-#error Do not #include this file directly. #include <lvfs.h> instead
-#endif
-
-#include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/sched.h>
-#include "lustre_compat25.h"
-
-struct lvfs_run_ctxt {
-	struct dt_device	*dt;
-};
-
-#endif
diff --git a/drivers/staging/lustre/lustre/include/lvfs.h b/drivers/staging/lustre/lustre/include/lvfs.h
deleted file mode 100644
index a98307ba..0000000
--- a/drivers/staging/lustre/lustre/include/lvfs.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/include/lvfs.h
- *
- * lustre VFS/process permission interface
- */
-
-#ifndef __LVFS_H__
-#define __LVFS_H__
-
-#include "../../include/linux/libcfs/libcfs.h"
-#include "linux/lvfs.h"
-
-#endif
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index b29f7fc..ef24871 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -830,6 +830,10 @@ struct obd_llog_group {
 #define OBD_DEVICE_MAGIC	0XAB5CD6EF
 #define OBD_DEV_BY_DEVNAME      0xffffd0de
 
+struct lvfs_run_ctxt {
+	struct dt_device *dt;
+};
+
 struct obd_device {
 	struct obd_type	*obd_type;
 	__u32		   obd_magic;
diff --git a/drivers/staging/lustre/lustre/include/obd_support.h b/drivers/staging/lustre/lustre/include/obd_support.h
index e9497c1..2991d2e 100644
--- a/drivers/staging/lustre/lustre/include/obd_support.h
+++ b/drivers/staging/lustre/lustre/include/obd_support.h
@@ -39,7 +39,7 @@
 
 #include <linux/slab.h>
 #include "../../include/linux/libcfs/libcfs.h"
-#include "lvfs.h"
+#include "linux/lustre_compat25.h"
 #include "lprocfs_status.h"
 
 /* global variables */
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index 4e0635d..1260c87 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -46,7 +46,7 @@
 #define PRINT_CMD CDEBUG
 
 #include "../include/obd.h"
-#include "../include/lvfs.h"
+#include "../include/linux/lustre_compat25.h"
 #include "../include/obd_class.h"
 #include "../include/lustre/lustre_user.h"
 #include "../include/lustre_log.h"
diff --git a/drivers/staging/lustre/lustre/ptlrpc/llog_net.c b/drivers/staging/lustre/lustre/ptlrpc/llog_net.c
index 1d996ca..dac66f5 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/llog_net.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/llog_net.c
@@ -51,7 +51,6 @@
 #include "../include/obd_class.h"
 #include "../include/lustre_log.h"
 #include <linux/list.h>
-#include "../include/lvfs.h"
 
 int llog_initiator_connect(struct llog_ctxt *ctxt)
 {
-- 
1.7.9.5

