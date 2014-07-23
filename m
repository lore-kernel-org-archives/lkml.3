Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbaGWAfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 20:35:17 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:60376 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301AbaGWAfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 20:35:12 -0400
From: Jeff Oczek <jeffoczek@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jeff Oczek <jeffoczek@gmail.com>
Subject: [PATCH v2 2/2] staging: cxt1e1: Fix static symbol sparse warnings for global vars in linux.c
Date: Tue, 22 Jul 2014 20:34:56 -0400
Message-Id: <1406075696-15912-3-git-send-email-jeffoczek@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406075696-15912-2-git-send-email-jeffoczek@gmail.com>
References: <1406059671-6536-1-git-send-email-jeffoczek@gmail.com>
 <1406075696-15912-1-git-send-email-jeffoczek@gmail.com>
 <1406075696-15912-2-git-send-email-jeffoczek@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put extern declarations in cxt1e1_common.h to reduce sparse warnings for linux.c:

drivers/staging/cxt1e1/linux.c:86:13: warning:
  symbol 'cxt1e1_error_flag' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:91:13: warning:
  symbol 'cxt1e1_max_mru' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:95:13: warning:
  symbol 'cxt1e1_max_mtu' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:96:13: warning:
  symbol 'cxt1e1_max_mtu_default' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:100:13: warning:
  symbol 'cxt1e1_max_txdesc_default' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:101:13: warning:
  symbol 'cxt1e1_max_txdesc_used' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:105:13: warning:
  symbol 'cxt1e1_max_rxdesc_default' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:106:13: warning:
  symbol 'cxt1e1_max_rxdesc_used' was not declared. Should it be static?

Signed-off-by: Jeff Oczek <jeffoczek@gmail.com>
---
 drivers/staging/cxt1e1/cxt1e1_common.h | 14 ++++++++++++++
 drivers/staging/cxt1e1/hwprobe.c       |  2 +-
 drivers/staging/cxt1e1/linux.c         |  1 +
 drivers/staging/cxt1e1/musycc.c        |  5 +----
 drivers/staging/cxt1e1/pmcc4_drv.c     |  5 +----
 5 files changed, 18 insertions(+), 9 deletions(-)
 create mode 100644 drivers/staging/cxt1e1/cxt1e1_common.h

diff --git a/drivers/staging/cxt1e1/cxt1e1_common.h b/drivers/staging/cxt1e1/cxt1e1_common.h
new file mode 100644
index 0000000..c6634ea
--- /dev/null
+++ b/drivers/staging/cxt1e1/cxt1e1_common.h
@@ -0,0 +1,14 @@
+#ifndef __CXT1E1_COMMON_H
+#define __CXT1E1_COMMON_H
+
+extern int cxt1e1_error_flag;
+extern int cxt1e1_max_mru;
+extern int cxt1e1_max_mtu;
+extern int cxt1e1_max_mtu_default;
+extern int cxt1e1_max_txdesc_used;
+extern int cxt1e1_max_txdesc_default;
+extern int cxt1e1_max_rxdesc_used;
+extern int cxt1e1_max_rxdesc_default;
+
+#endif
+
diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index 9eb0313..3f7bf70 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -30,8 +30,8 @@
 #ifdef CONFIG_PROC_FS
 #include "sbeproc.h"
 #endif
+#include "cxt1e1_common.h"
 
-extern int  cxt1e1_error_flag;
 extern int  drvr_state;
 
 /* forward references */
diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 07cc142..3dd09a3 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -30,6 +30,7 @@
 #include "pmcc4_ioctls.h"
 #include "pmcc4_private.h"
 #include "sbeproc.h"
+#include "cxt1e1_common.h"
 
 /*******************************************************************************
  * Error out early if we have compiler trouble.
diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 5b9b482..aeb8a21 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -34,6 +34,7 @@ static unsigned int max_bh;
 #include "pmcc4_private.h"
 #include "pmcc4.h"
 #include "musycc.h"
+#include "cxt1e1_common.h"
 
 #define sd_find_chan(ci,ch)   c4_find_chan(ch)
 
@@ -43,10 +44,6 @@ static unsigned int max_bh;
 extern ci_t *c4_list;
 extern int  drvr_state;
 
-extern int  cxt1e1_max_mru;
-extern int  cxt1e1_max_mtu;
-extern int  cxt1e1_max_rxdesc_used;
-extern int  cxt1e1_max_txdesc_used;
 extern ci_t *CI;                /* dummy pointr to board ZEROE's data - DEBUG
 				 * USAGE */
 
diff --git a/drivers/staging/cxt1e1/pmcc4_drv.c b/drivers/staging/cxt1e1/pmcc4_drv.c
index 99b02a0..a3ec7f9 100644
--- a/drivers/staging/cxt1e1/pmcc4_drv.c
+++ b/drivers/staging/cxt1e1/pmcc4_drv.c
@@ -38,6 +38,7 @@
 #include "musycc.h"
 #include "comet.h"
 #include "sbe_bid.h"
+#include "cxt1e1_common.h"
 
 #define KERN_WARN KERN_WARNING
 
@@ -59,10 +60,6 @@ void        musycc_update_timeslots (mpi_t *);
 
 extern void musycc_update_tx_thp (mch_t *);
 extern int  cxt1e1_log_level;
-extern int  cxt1e1_max_mru;
-extern int  cxt1e1_max_mtu;
-extern int  cxt1e1_max_rxdesc_used, cxt1e1_max_rxdesc_default;
-extern int  cxt1e1_max_txdesc_used, cxt1e1_max_txdesc_default;
 
 #if defined (__powerpc__)
 extern void *memset (void *s, int c, size_t n);
-- 
1.9.1

