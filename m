Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaH1Xgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:36:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:54933 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbaH1Xgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:36:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,421,1406617200"; 
   d="scan'208";a="583154386"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 02/11] staging/lustre remove linux/lustre_acl.h
Date: Thu, 28 Aug 2014 18:35:10 -0500
Message-ID: <1409268919-16155-3-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409268919-16155-1-git-send-email-john.hammond@intel.com>
References: <1409268919-16155-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.106]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Move the contents of lustre/include/linux/lustre_acl.h to
lustre/include/lustre_acl.h and remove the first header.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 .../lustre/lustre/include/linux/lustre_acl.h       |   66 --------------------
 drivers/staging/lustre/lustre/include/lustre_acl.h |    9 ++-
 2 files changed, 8 insertions(+), 67 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_acl.h

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_acl.h b/drivers/staging/lustre/lustre/include/linux/lustre_acl.h
deleted file mode 100644
index b17273d..0000000
--- a/drivers/staging/lustre/lustre/include/linux/lustre_acl.h
+++ /dev/null
@@ -1,66 +0,0 @@
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
- * Copyright (c) 2005, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- */
-/*
- * Copyright (c) 2011, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/lustre/include/lustre_acl.h
- *
- * MDS data structures.
- * See also lustre_idl.h for wire formats of requests.
- */
-
-#ifndef _LUSTRE_LINUX_ACL_H
-#define _LUSTRE_LINUX_ACL_H
-
-#ifndef	_LUSTRE_ACL_H
-#error	Should not include directly. use #include <lustre_acl.h> instead
-#endif
-
-#include <linux/fs.h>
-#include <linux/dcache.h>
-
-#include <linux/posix_acl_xattr.h>
-#define LUSTRE_POSIX_ACL_MAX_ENTRIES	32
-#define LUSTRE_POSIX_ACL_MAX_SIZE					\
-	(sizeof(posix_acl_xattr_header) +				\
-	 LUSTRE_POSIX_ACL_MAX_ENTRIES * sizeof(posix_acl_xattr_entry))
-
-#include "lustre_intent.h"
-#include <linux/xattr.h> /* XATTR_{REPLACE,CREATE} */
-
-#ifndef LUSTRE_POSIX_ACL_MAX_SIZE
-# define LUSTRE_POSIX_ACL_MAX_SIZE   0
-#endif
-
-#endif /* _LUSTRE_LINUX_ACL_H */
diff --git a/drivers/staging/lustre/lustre/include/lustre_acl.h b/drivers/staging/lustre/lustre/include/lustre_acl.h
index 0b6ea07..aa4cfa7 100644
--- a/drivers/staging/lustre/lustre/include/lustre_acl.h
+++ b/drivers/staging/lustre/lustre/include/lustre_acl.h
@@ -37,6 +37,13 @@
 #ifndef _LUSTRE_ACL_H
 #define _LUSTRE_ACL_H
 
-#include "linux/lustre_acl.h"
+#include <linux/fs.h>
+#include <linux/dcache.h>
+#include <linux/posix_acl_xattr.h>
+
+#define LUSTRE_POSIX_ACL_MAX_ENTRIES	32
+#define LUSTRE_POSIX_ACL_MAX_SIZE					\
+	(sizeof(posix_acl_xattr_header) +				\
+	 LUSTRE_POSIX_ACL_MAX_ENTRIES * sizeof(posix_acl_xattr_entry))
 
 #endif
-- 
1.7.9.5

