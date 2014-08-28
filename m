Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbaH1Xhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:37:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:54962 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbaH1Xgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:36:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,421,1406617200"; 
   d="scan'208";a="583154485"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 08/11] staging/lustre: remove linux/lustre_net.h
Date: Thu, 28 Aug 2014 18:35:16 -0500
Message-ID: <1409268919-16155-9-git-send-email-john.hammond@intel.com>
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

Remove the superfluous header lustre/include/linux/lustre_net.h.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 .../lustre/lustre/include/linux/lustre_net.h       |   49 --------------------
 drivers/staging/lustre/lustre/include/lustre_net.h |    2 -
 drivers/staging/lustre/lustre/ptlrpc/service.c     |    4 --
 3 files changed, 55 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_net.h

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_net.h b/drivers/staging/lustre/lustre/include/linux/lustre_net.h
deleted file mode 100644
index 05de4d8..0000000
--- a/drivers/staging/lustre/lustre/include/linux/lustre_net.h
+++ /dev/null
@@ -1,49 +0,0 @@
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
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#ifndef _LINUX_LUSTRE_NET_H
-#define _LINUX_LUSTRE_NET_H
-
-#ifndef _LUSTRE_NET_H
-#error Do not #include this file directly. #include <lustre_net.h> instead
-#endif
-
-#include <linux/workqueue.h>
-
-/* XXX Liang: should be moved to other header instead of here */
-#ifndef WITH_GROUP_INFO
-#define WITH_GROUP_INFO
-#endif
-
-#endif
diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index d6af2ca..d8c8471 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -55,8 +55,6 @@
  * @{
  */
 
-#include "linux/lustre_net.h"
-
 #include "../../include/linux/libcfs/libcfs.h"
 // #include <obd.h>
 #include "../../include/linux/lnet/lnet.h"
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index c88eae27b..01027c5 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -2262,9 +2262,7 @@ static int ptlrpc_main(void *arg)
 	struct ptlrpc_service_part	*svcpt = thread->t_svcpt;
 	struct ptlrpc_service		*svc = svcpt->scp_service;
 	struct ptlrpc_reply_state	*rs;
-#ifdef WITH_GROUP_INFO
 	struct group_info *ginfo = NULL;
-#endif
 	struct lu_env *env;
 	int counter = 0, rc = 0;
 
@@ -2280,7 +2278,6 @@ static int ptlrpc_main(void *arg)
 		      svc->srv_name, thread->t_name, svcpt->scp_cpt);
 	}
 
-#ifdef WITH_GROUP_INFO
 	ginfo = groups_alloc(0);
 	if (!ginfo) {
 		rc = -ENOMEM;
@@ -2289,7 +2286,6 @@ static int ptlrpc_main(void *arg)
 
 	set_current_groups(ginfo);
 	put_group_info(ginfo);
-#endif
 
 	if (svc->srv_ops.so_thr_init != NULL) {
 		rc = svc->srv_ops.so_thr_init(thread);
-- 
1.7.9.5

