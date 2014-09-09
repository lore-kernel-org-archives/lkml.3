Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaIISmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:42:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:15626 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbaIISkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:40:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,492,1406617200"; 
   d="scan'208";a="570725216"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 4/7] staging/lustre: remove lvfs_linux.h
Date: Tue, 9 Sep 2014 13:39:05 -0500
Message-ID: <1410287948-13168-5-git-send-email-john.hammond@intel.com>
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

The definitions in lustre/include/linux/lvfs_linux.h are not used so
remove that header.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/include/linux/lvfs.h |    4 +-
 .../lustre/lustre/include/linux/lvfs_linux.h       |   59 --------------------
 2 files changed, 3 insertions(+), 60 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lvfs_linux.h

diff --git a/drivers/staging/lustre/lustre/include/linux/lvfs.h b/drivers/staging/lustre/lustre/include/linux/lvfs.h
index e4cdb45..ddeb7de 100644
--- a/drivers/staging/lustre/lustre/include/linux/lvfs.h
+++ b/drivers/staging/lustre/lustre/include/linux/lvfs.h
@@ -45,8 +45,10 @@
 #error Do not #include this file directly. #include <lvfs.h> instead
 #endif
 
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
 #include "lustre_compat25.h"
-#include "lvfs_linux.h"
 
 #define LLOG_LVFS
 
diff --git a/drivers/staging/lustre/lustre/include/linux/lvfs_linux.h b/drivers/staging/lustre/lustre/include/linux/lvfs_linux.h
deleted file mode 100644
index 01e01ad..0000000
--- a/drivers/staging/lustre/lustre/include/linux/lvfs_linux.h
+++ /dev/null
@@ -1,59 +0,0 @@
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
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#ifndef __LVFS_LINUX_H__
-#define __LVFS_LINUX_H__
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/namei.h>
-#include <linux/sched.h>
-
-#include "../lvfs.h"
-
-struct lvfs_run_ctxt;
-
-struct l_linux_dirent {
-	struct list_head      lld_list;
-	ino_t	   lld_ino;
-	unsigned long   lld_off;
-	char	    lld_name[LL_FID_NAMELEN];
-};
-struct l_readdir_callback {
-	struct l_linux_dirent *lrc_dirent;
-	struct list_head	    *lrc_list;
-};
-
-#endif /*  __LVFS_LINUX_H__ */
-- 
1.7.9.5

