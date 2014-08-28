Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaH1Xg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:36:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:35781 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbaH1Xg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:36:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="378412713"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 01/11] staging/lustre: remove linux/lprocfs_status.h
Date: Thu, 28 Aug 2014 18:35:09 -0500
Message-ID: <1409268919-16155-2-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409268919-16155-1-git-send-email-john.hammond@intel.com>
References: <1409268919-16155-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.107]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Remove lustre/include/linux/lprocfs_status.h. Include linux/statfs.h
where needed.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 .../lustre/lustre/include/linux/lprocfs_status.h   |   57 --------------------
 .../staging/lustre/lustre/include/lprocfs_status.h |    6 ++-
 drivers/staging/lustre/lustre/include/lustre_lib.h |    1 +
 drivers/staging/lustre/lustre/llite/llite_lib.c    |    1 +
 .../staging/lustre/lustre/obdclass/statfs_pack.c   |    2 +-
 5 files changed, 8 insertions(+), 59 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lprocfs_status.h

diff --git a/drivers/staging/lustre/lustre/include/linux/lprocfs_status.h b/drivers/staging/lustre/lustre/include/linux/lprocfs_status.h
deleted file mode 100644
index cb76b5d..0000000
--- a/drivers/staging/lustre/lustre/include/linux/lprocfs_status.h
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
- * Copyright (c) 2002, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2011, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/include/linux/lprocfs_status.h
- *
- * Top level header file for LProc SNMP
- *
- * Author: Hariharan Thantry thantry@users.sourceforge.net
- */
-#ifndef _LINUX_LPROCFS_SNMP_H
-#define _LINUX_LPROCFS_SNMP_H
-
-#ifndef _LPROCFS_SNMP_H
-#error Do not #include this file directly. #include <lprocfs_status.h> instead
-#endif
-
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-#include <linux/smp.h>
-#include <linux/rwsem.h>
-#include "../../../include/linux/libcfs/libcfs.h"
-#include <linux/statfs.h>
-
-
-#endif /* LPROCFS_SNMP_H */
diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index 16b3d68..1f7cb9b 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -42,7 +42,11 @@
 #ifndef _LPROCFS_SNMP_H
 #define _LPROCFS_SNMP_H
 
-#include "linux/lprocfs_status.h"
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
 #include "lustre/lustre_idl.h"
 
 struct lprocfs_vars {
diff --git a/drivers/staging/lustre/lustre/include/lustre_lib.h b/drivers/staging/lustre/lustre/include/lustre_lib.h
index 6ab8958..d455a6d 100644
--- a/drivers/staging/lustre/lustre/include/lustre_lib.h
+++ b/drivers/staging/lustre/lustre/include/lustre_lib.h
@@ -53,6 +53,7 @@
 #include "linux/lustre_lib.h"
 
 /* target.c */
+struct kstatfs;
 struct ptlrpc_request;
 struct obd_export;
 struct lu_target;
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index ff375d3..8b564f2 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -41,6 +41,7 @@
 #define DEBUG_SUBSYSTEM S_LLITE
 
 #include <linux/module.h>
+#include <linux/statfs.h>
 #include <linux/types.h>
 #include <linux/mm.h>
 
diff --git a/drivers/staging/lustre/lustre/obdclass/statfs_pack.c b/drivers/staging/lustre/lustre/obdclass/statfs_pack.c
index 33b1a83..cc785ab 100644
--- a/drivers/staging/lustre/lustre/obdclass/statfs_pack.c
+++ b/drivers/staging/lustre/lustre/obdclass/statfs_pack.c
@@ -40,7 +40,7 @@
 
 #define DEBUG_SUBSYSTEM S_CLASS
 
-
+#include <linux/statfs.h>
 #include "../include/lustre_export.h"
 #include "../include/lustre_net.h"
 #include "../include/obd_support.h"
-- 
1.7.9.5

