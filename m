Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaH1Xgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:36:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:34943 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbaH1Xgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:36:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,421,1406617200"; 
   d="scan'208";a="565065855"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 10/11] staging/lustre: remove linux/obd_class.h
Date: Thu, 28 Aug 2014 18:35:18 -0500
Message-ID: <1409268919-16155-11-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409268919-16155-1-git-send-email-john.hammond@intel.com>
References: <1409268919-16155-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.108]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Kill the macro ll_inode_flags() and remove the superfluous header
lustre/include/linux/obd_class.h.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 .../lustre/lustre/include/linux/obd_class.h        |   58 --------------------
 drivers/staging/lustre/lustre/include/obd_class.h  |    9 ++-
 drivers/staging/lustre/lustre/obdclass/obdo.c      |    2 +-
 3 files changed, 8 insertions(+), 61 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/obd_class.h

diff --git a/drivers/staging/lustre/lustre/include/linux/obd_class.h b/drivers/staging/lustre/lustre/include/linux/obd_class.h
deleted file mode 100644
index 99c5bd1..0000000
--- a/drivers/staging/lustre/lustre/include/linux/obd_class.h
+++ /dev/null
@@ -1,58 +0,0 @@
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
- * Copyright (c) 1999, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2011, 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#ifndef __LINUX_CLASS_OBD_H
-#define __LINUX_CLASS_OBD_H
-
-#ifndef __CLASS_OBD_H
-#error Do not #include this file directly. #include <obd_class.h> instead
-#endif
-
-#include <asm/uaccess.h>
-#include <linux/types.h>
-#include <linux/fs.h>
-#include <linux/time.h>
-#include <linux/timer.h>
-
-/* obdo.c */
-void obdo_from_la(struct obdo *dst, struct lu_attr *la, __u64 valid);
-void la_from_obdo(struct lu_attr *la, struct obdo *dst, u32 valid);
-void obdo_refresh_inode(struct inode *dst, struct obdo *src, u32 valid);
-void obdo_to_inode(struct inode *dst, struct obdo *src, u32 valid);
-#define ll_inode_flags(inode)	 (inode->i_flags)
-
-
-#endif /* __LINUX_OBD_CLASS_H */
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 3597226..a21ef77 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -45,8 +45,6 @@
 #include "lustre/lustre_idl.h"
 #include "lprocfs_status.h"
 
-#include "linux/obd_class.h"
-
 #define OBD_STATFS_NODELAY      0x0001  /* requests should be send without delay
 					 * and resends for avoid deadlocks */
 #define OBD_STATFS_FROM_CACHE   0x0002  /* the statfs callback should not update
@@ -307,6 +305,13 @@ static inline enum obd_option exp_flags_from_obd(struct obd_device *obd)
 		0);
 }
 
+struct inode;
+struct lu_attr;
+struct obdo;
+void obdo_from_la(struct obdo *dst, struct lu_attr *la, __u64 valid);
+void la_from_obdo(struct lu_attr *la, struct obdo *dst, u32 valid);
+void obdo_refresh_inode(struct inode *dst, struct obdo *src, u32 valid);
+void obdo_to_inode(struct inode *dst, struct obdo *src, u32 valid);
 
 void obdo_cpy_md(struct obdo *dst, struct obdo *src, u32 valid);
 void obdo_to_ioobj(struct obdo *oa, struct obd_ioobj *ioobj);
diff --git a/drivers/staging/lustre/lustre/obdclass/obdo.c b/drivers/staging/lustre/lustre/obdclass/obdo.c
index 0746952..bdc00ea 100644
--- a/drivers/staging/lustre/lustre/obdclass/obdo.c
+++ b/drivers/staging/lustre/lustre/obdclass/obdo.c
@@ -108,7 +108,7 @@ void obdo_from_inode(struct obdo *dst, struct inode *src, u32 valid)
 		newvalid |= OBD_MD_FLGID;
 	}
 	if (valid & OBD_MD_FLFLAGS) {
-		dst->o_flags = ll_inode_flags(src);
+		dst->o_flags = src->i_flags;
 		newvalid |= OBD_MD_FLFLAGS;
 	}
 	dst->o_valid |= newvalid;
-- 
1.7.9.5

