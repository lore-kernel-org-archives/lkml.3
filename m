Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaH1XiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:38:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:54933 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbaH1Xgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:36:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,421,1406617200"; 
   d="scan'208";a="591404788"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 05/11] staging/lustre: move lustre_intent.h to ..
Date: Thu, 28 Aug 2014 18:35:13 -0500
Message-ID: <1409268919-16155-6-git-send-email-john.hammond@intel.com>
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

Move lustre/include/linux/lustre_intent.h to lustre/include.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 .../lustre/lustre/include/linux/lustre_intent.h    |   62 --------------------
 drivers/staging/lustre/lustre/include/linux/obd.h  |    2 +-
 .../staging/lustre/lustre/include/lustre_intent.h  |   62 ++++++++++++++++++++
 drivers/staging/lustre/lustre/include/lustre_mdc.h |    2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |    2 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |    2 +-
 drivers/staging/lustre/lustre/lmv/lmv_intent.c     |    2 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |    2 +-
 8 files changed, 68 insertions(+), 68 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_intent.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_intent.h

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_intent.h b/drivers/staging/lustre/lustre/include/linux/lustre_intent.h
deleted file mode 100644
index c491d52..0000000
--- a/drivers/staging/lustre/lustre/include/linux/lustre_intent.h
+++ /dev/null
@@ -1,62 +0,0 @@
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
- *
- * Copyright (c) 2011, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#ifndef LUSTRE_INTENT_H
-#define LUSTRE_INTENT_H
-
-/* intent IT_XXX are defined in lustre/include/obd.h */
-struct lustre_intent_data {
-	int		it_disposition;
-	int		it_status;
-	__u64		it_lock_handle;
-	__u64		it_lock_bits;
-	int		it_lock_mode;
-	int		it_remote_lock_mode;
-	__u64	   it_remote_lock_handle;
-	void	   *it_data;
-	unsigned int    it_lock_set:1;
-};
-
-struct lookup_intent {
-	int     it_op;
-	int     it_create_mode;
-	__u64   it_flags;
-	union {
-		struct lustre_intent_data lustre;
-	} d;
-};
-
-#endif
diff --git a/drivers/staging/lustre/lustre/include/linux/obd.h b/drivers/staging/lustre/lustre/include/linux/obd.h
index 2a3a88c..9d7e28a 100644
--- a/drivers/staging/lustre/lustre/include/linux/obd.h
+++ b/drivers/staging/lustre/lustre/include/linux/obd.h
@@ -48,7 +48,7 @@
 # include <linux/sched.h>  /* for struct task_struct, for current.h */
 # include <linux/proc_fs.h>
 # include <linux/mount.h>
-#include "lustre_intent.h"
+#include "../lustre_intent.h"
 
 struct ll_iattr {
 	struct iattr	iattr;
diff --git a/drivers/staging/lustre/lustre/include/lustre_intent.h b/drivers/staging/lustre/lustre/include/lustre_intent.h
new file mode 100644
index 0000000..c491d52
--- /dev/null
+++ b/drivers/staging/lustre/lustre/include/lustre_intent.h
@@ -0,0 +1,62 @@
+/*
+ * GPL HEADER START
+ *
+ * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 only,
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 for more details (a copy is included
+ * in the LICENSE file that accompanied this code).
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 along with this program; If not, see
+ * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
+ *
+ * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
+ * CA 95054 USA or visit www.sun.com if you need additional information or
+ * have any questions.
+ *
+ * GPL HEADER END
+ */
+/*
+ * Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
+ * Use is subject to license terms.
+ *
+ * Copyright (c) 2011, Intel Corporation.
+ */
+/*
+ * This file is part of Lustre, http://www.lustre.org/
+ * Lustre is a trademark of Sun Microsystems, Inc.
+ */
+
+#ifndef LUSTRE_INTENT_H
+#define LUSTRE_INTENT_H
+
+/* intent IT_XXX are defined in lustre/include/obd.h */
+struct lustre_intent_data {
+	int		it_disposition;
+	int		it_status;
+	__u64		it_lock_handle;
+	__u64		it_lock_bits;
+	int		it_lock_mode;
+	int		it_remote_lock_mode;
+	__u64	   it_remote_lock_handle;
+	void	   *it_data;
+	unsigned int    it_lock_set:1;
+};
+
+struct lookup_intent {
+	int     it_op;
+	int     it_create_mode;
+	__u64   it_flags;
+	union {
+		struct lustre_intent_data lustre;
+	} d;
+};
+
+#endif
diff --git a/drivers/staging/lustre/lustre/include/lustre_mdc.h b/drivers/staging/lustre/lustre/include/lustre_mdc.h
index 39bbc36..b1b05c8 100644
--- a/drivers/staging/lustre/lustre/include/lustre_mdc.h
+++ b/drivers/staging/lustre/lustre/include/lustre_mdc.h
@@ -50,7 +50,7 @@
 
 #include <linux/fs.h>
 #include <linux/dcache.h>
-#include "linux/lustre_intent.h"
+#include "lustre_intent.h"
 #include "lustre_handles.h"
 #include "../../include/linux/libcfs/libcfs.h"
 #include "obd_class.h"
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index 3143222..f6b24d7 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -42,7 +42,7 @@
 #define DEBUG_SUBSYSTEM S_LDLM
 
 #include "../../include/linux/libcfs/libcfs.h"
-#include "../include/linux/lustre_intent.h"
+#include "../include/lustre_intent.h"
 #include "../include/obd_class.h"
 #include "ldlm_internal.h"
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index acfb078..0b685f0 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -45,7 +45,7 @@
 #include "../include/cl_object.h"
 #include "../include/lclient.h"
 #include "../include/lustre_mdc.h"
-#include "../include/linux/lustre_intent.h"
+#include "../include/lustre_intent.h"
 #include <linux/compat.h>
 #include <linux/posix_acl_xattr.h>
 
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_intent.c b/drivers/staging/lustre/lustre/lmv/lmv_intent.c
index aba698f..602cec8 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_intent.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_intent.c
@@ -41,7 +41,7 @@
 #include <asm/div64.h>
 #include <linux/seq_file.h>
 #include <linux/namei.h>
-#include "../include/linux/lustre_intent.h"
+#include "../include/lustre_intent.h"
 #include "../include/obd_support.h"
 #include "../include/lustre/lustre_idl.h"
 #include "../include/lustre_lib.h"
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 9c3e533..9ade09a 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -38,7 +38,7 @@
 
 # include <linux/module.h>
 
-#include "../include/linux/lustre_intent.h"
+#include "../include/lustre_intent.h"
 #include "../include/obd.h"
 #include "../include/obd_class.h"
 #include "../include/lustre_dlm.h"
-- 
1.7.9.5

