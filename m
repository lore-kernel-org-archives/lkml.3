Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbaGVUIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:08:11 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:61747 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669AbaGVUIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:08:09 -0400
From: Jeff Oczek <jeffoczek@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jeff Oczek <jeffoczek@gmail.com>
Subject: [PATCH] staging: cxt1e1: Fix static symbol sparse warnings for global vars in linux.c
Date: Tue, 22 Jul 2014 16:07:51 -0400
Message-Id: <1406059671-6536-1-git-send-email-jeffoczek@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put extern declarations in cxt1e1_common.h to reduce sparse warnings for linux.c:
drivers/staging/cxt1e1/linux.c:86:13: warning:
  symbol 'error_flag' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:91:13: warning:
  symbol 'cxt1e1_max_mru' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:95:13: warning:
  symbol 'cxt1e1_max_mtu' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:96:13: warning:
  symbol 'max_mtu_default' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:99:13: warning:
  symbol 'max_txdesc_used' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:100:13: warning:
  symbol 'max_txd:esc_default' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:103:13: warning:
  symbol 'max_rxdesc_used' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:104:13: warning:
  symbol 'max_rxdesc_default' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:153:1: warning:
  symbol 'c4_wk_chan_restart' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:171:1: warning:
  symbol 'c4_wk_chan_init' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:186:1: warning:
  symbol 'c4_wq_port_init' was not declared. Should it be static?
drivers/staging/cxt1e1/linux.c:208:1: warning:
  symbol 'c4_wq_port_cleanup' was not declared. Should it be static?

Signed-off-by: Jeff Oczek <jeffoczek@gmail.com>
---
 drivers/staging/cxt1e1/cxt1e1_common.h | 15 +++++++++++++++
 drivers/staging/cxt1e1/hwprobe.c       |  2 +-
 drivers/staging/cxt1e1/linux.c         |  2 +-
 drivers/staging/cxt1e1/musycc.c        |  7 +------
 drivers/staging/cxt1e1/pmcc4_drv.c     |  5 +----
 5 files changed, 19 insertions(+), 12 deletions(-)
 create mode 100644 drivers/staging/cxt1e1/cxt1e1_common.h

diff --git a/drivers/staging/cxt1e1/cxt1e1_common.h b/drivers/staging/cxt1e1/cxt1e1_common.h
new file mode 100644
index 0000000..ac6b974
--- /dev/null
+++ b/drivers/staging/cxt1e1/cxt1e1_common.h
@@ -0,0 +1,15 @@
+#ifndef __CXT1E1_COMMON_H
+#define __CXT1E1_COMMON_H
+
+#include "pmcc4.h"
+
+extern int error_flag;
+extern int cxt1e1_max_mru;
+extern int cxt1e1_max_mtu;
+extern int max_mtu_default;
+extern int max_txdesc_used;
+extern int max_txdesc_default;
+extern int max_rxdesc_used;
+extern int max_rxdesc_default;
+
+#endif
diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index 4fa27c8..45bc161 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -30,8 +30,8 @@
 #ifdef CONFIG_PROC_FS
 #include "sbeproc.h"
 #endif
+#include "cxt1e1_common.h"
 
-extern int  error_flag;
 extern int  drvr_state;
 
 /* forward references */
diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 09f3d5c..3ba0245 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -30,7 +30,7 @@
 #include "pmcc4_ioctls.h"
 #include "pmcc4_private.h"
 #include "sbeproc.h"
-
+#include "cxt1e1_common.h"
 /*******************************************************************************
  * Error out early if we have compiler trouble.
  *
diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 0bcbd8a..4f8b137 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -34,7 +34,7 @@ static unsigned int max_bh;
 #include "pmcc4_private.h"
 #include "pmcc4.h"
 #include "musycc.h"
-
+#include "cxt1e1_common.h"
 #define sd_find_chan(ci,ch)   c4_find_chan(ch)
 
 
@@ -42,11 +42,6 @@ static unsigned int max_bh;
 /* global driver variables */
 extern ci_t *c4_list;
 extern int  drvr_state;
-
-extern int  cxt1e1_max_mru;
-extern int  cxt1e1_max_mtu;
-extern int  max_rxdesc_used;
-extern int  max_txdesc_used;
 extern ci_t *CI;                /* dummy pointr to board ZEROE's data - DEBUG
 				 * USAGE */
 
diff --git a/drivers/staging/cxt1e1/pmcc4_drv.c b/drivers/staging/cxt1e1/pmcc4_drv.c
index 76bebdd..e053b60 100644
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
-extern int  max_rxdesc_used, max_rxdesc_default;
-extern int  max_txdesc_used, max_txdesc_default;
 
 #if defined (__powerpc__)
 extern void *memset (void *s, int c, size_t n);
-- 
1.9.1

