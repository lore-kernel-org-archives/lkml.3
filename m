Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3LSJpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:45:24 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44461 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3LSJpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:45:21 -0500
Date: Thu, 19 Dec 2013 15:15:02 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        josh@joshtriplett.org
Subject: [PATCH 09/13] drivers: block: Move prototype declaration of function
 tl_abort_disk_io() to appropriate header file from drbd_state.c
Message-ID: <858d992f118ff1695201c7fb22c9a14052a5a96f.1387445396.git.rashika.kheria@gmail.com>
References: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the prototype declaration of function tl_abort_disk_io() from
drbd/drbd_state.c to appropriate header file drbd/drbd_int.h because it
is used by more than 2 files.

This eliminates the following warnings in drbd/drbd_main.c:
drivers/block/drbd/drbd_main.c:310:6: warning: no previous prototype for ‘tl_abort_disk_io’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/block/drbd/drbd_int.h   |    1 +
 drivers/block/drbd/drbd_state.c |    3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 0cc79f4..27df55f 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -65,6 +65,7 @@
 extern unsigned int minor_count;
 extern bool disable_sendpage;
 extern bool allow_oos;
+void tl_abort_disk_io(struct drbd_conf *mdev);
 
 #ifdef CONFIG_DRBD_FAULT_INJECTION
 extern int enable_faults;
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 216d47b..120e1c0 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -29,9 +29,6 @@
 #include "drbd_int.h"
 #include "drbd_req.h"
 
-/* in drbd_main.c */
-extern void tl_abort_disk_io(struct drbd_conf *mdev);
-
 struct after_state_chg_work {
 	struct drbd_work w;
 	union drbd_state os;
-- 
1.7.9.5

