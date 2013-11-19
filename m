Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab3KSOmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:42:55 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42762 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3KSOmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:42:47 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 09/13] staging/lustre: remove __CYGWIN__
Date: Tue, 19 Nov 2013 22:38:43 +0800
Message-Id: <1384871927-8553-10-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
References: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/linux/kp30.h       |    6 ------
 drivers/staging/lustre/include/linux/lnet/types.h  |   11 -----------
 drivers/staging/lustre/lustre/osc/osc_request.c    |    4 ----
 3 files changed, 21 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
index 69eefd5..fedf086 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
@@ -175,12 +175,6 @@ extern int  lwt_snapshot (cfs_cycles_t *now, int *ncpu, int *total_size,
 
 /* ------------------------------------------------------------------ */
 
-#ifdef __CYGWIN__
-# ifndef BITS_PER_LONG
-#   define BITS_PER_LONG 64
-# endif
-#endif
-
 # define LI_POISON 0x5a5a5a5a
 #if BITS_PER_LONG > 32
 # define LL_POISON 0x5a5a5a5a5a5a5a5aL
diff --git a/drivers/staging/lustre/include/linux/lnet/types.h b/drivers/staging/lustre/include/linux/lnet/types.h
index 4f63b7a..c833ce8 100644
--- a/drivers/staging/lustre/include/linux/lnet/types.h
+++ b/drivers/staging/lustre/include/linux/lnet/types.h
@@ -383,14 +383,6 @@ typedef enum {
 typedef unsigned LNET_SEQ_BASETYPE lnet_seq_t;
 #define LNET_SEQ_GT(a,b)	(((signed LNET_SEQ_BASETYPE)((a) - (b))) > 0)
 
-/* XXX
- * cygwin need the pragma line, not clear if it's needed in other places.
- * checking!!!
- */
-#ifdef __CYGWIN__
-#pragma pack(push, 4)
-#endif
-
 /**
  * Information about an event on a MD.
  */
@@ -462,9 +454,6 @@ typedef struct {
 	 */
 	volatile lnet_seq_t sequence;
 } lnet_event_t;
-#ifdef __CYGWIN__
-#pragma pop
-#endif
 
 /**
  * Event queue handler function type.
diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index cb19778..c837a0d 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -46,10 +46,6 @@
 #include <obd_ost.h>
 #include <obd_lov.h>
 
-#ifdef  __CYGWIN__
-# include <ctype.h>
-#endif
-
 #include <lustre_ha.h>
 #include <lprocfs_status.h>
 #include <lustre_log.h>
-- 
1.7.9.5

