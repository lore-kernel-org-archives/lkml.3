Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3KUOcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:32:00 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39207 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3KUOb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:31:56 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 05/10] staging/lustre: move IFTODT/DTTOIF to lustre_idl.h
Date: Thu, 21 Nov 2013 22:28:26 +0800
Message-Id: <1385044111-3129-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
References: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are in fact definition of how client/server talks
to each other about file type.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/linux/linux-fs.h   |   11 -----------
 .../lustre/lustre/include/lustre/lustre_idl.h      |   12 ++++++++++++
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
index 102afa2..fdec53a 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
@@ -61,15 +61,4 @@
 #define flock_end(fl)			((fl)->fl_end)
 #define flock_set_end(fl, end)		do { (fl)->fl_end = (end); } while (0)
 
-#ifndef IFSHIFT
-#define IFSHIFT			12
-#endif
-
-#ifndef IFTODT
-#define IFTODT(type)		(((type) & S_IFMT) >> IFSHIFT)
-#endif
-#ifndef DTTOIF
-#define DTTOIF(dirtype)		((dirtype) << IFSHIFT)
-#endif
-
 #endif
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index e592a0e..5130468 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -1025,6 +1025,18 @@ struct luda_type {
 	__u16 lt_type;
 };
 
+#ifndef IFSHIFT
+#define IFSHIFT                 12
+#endif
+
+#ifndef IFTODT
+#define IFTODT(type)		(((type) & S_IFMT) >> IFSHIFT)
+#endif
+#ifndef DTTOIF
+#define DTTOIF(dirtype)		((dirtype) << IFSHIFT)
+#endif
+
+
 struct lu_dirpage {
 	__u64	    ldp_hash_start;
 	__u64	    ldp_hash_end;
-- 
1.7.9.5

