Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab3LWWDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:03:35 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60678 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410Ab3LWV64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:56 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 15/27] drbd: Move string function prototypes from linux/drbd.h to drbd_string.h
Date: Mon, 23 Dec 2013 22:50:44 +0100
Message-Id: <1387835456-29695-16-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h     |    1 +
 drivers/block/drbd/drbd_strings.c |    1 +
 drivers/block/drbd/drbd_strings.h |    9 +++++++++
 include/linux/drbd.h              |    6 ------
 4 files changed, 11 insertions(+), 6 deletions(-)
 create mode 100644 drivers/block/drbd/drbd_strings.h

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index ef4c621..2b0fdfd 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -45,6 +45,7 @@
 #include <linux/prefetch.h>
 #include <linux/drbd_genl_api.h>
 #include <linux/drbd.h>
+#include "drbd_strings.h"
 #include "drbd_state.h"
 #include "drbd_protocol.h"
 
diff --git a/drivers/block/drbd/drbd_strings.c b/drivers/block/drbd/drbd_strings.c
index 58e08ff..80b0f63 100644
--- a/drivers/block/drbd/drbd_strings.c
+++ b/drivers/block/drbd/drbd_strings.c
@@ -24,6 +24,7 @@
 */
 
 #include <linux/drbd.h>
+#include "drbd_strings.h"
 
 static const char *drbd_conn_s_names[] = {
 	[C_STANDALONE]       = "StandAlone",
diff --git a/drivers/block/drbd/drbd_strings.h b/drivers/block/drbd/drbd_strings.h
new file mode 100644
index 0000000..f9923cc
--- /dev/null
+++ b/drivers/block/drbd/drbd_strings.h
@@ -0,0 +1,9 @@
+#ifndef __DRBD_STRINGS_H
+#define __DRBD_STRINGS_H
+
+extern const char *drbd_conn_str(enum drbd_conns);
+extern const char *drbd_role_str(enum drbd_role);
+extern const char *drbd_disk_str(enum drbd_disk_state);
+extern const char *drbd_set_st_err_str(enum drbd_state_rv);
+
+#endif  /* __DRBD_STRINGS_H */
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 6f60136..3dbe9bd 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -327,12 +327,6 @@ enum drbd_state_rv {
 	SS_AFTER_LAST_ERROR = -22,    /* Keep this at bottom */
 };
 
-/* from drbd_strings.c */
-extern const char *drbd_conn_str(enum drbd_conns);
-extern const char *drbd_role_str(enum drbd_role);
-extern const char *drbd_disk_str(enum drbd_disk_state);
-extern const char *drbd_set_st_err_str(enum drbd_state_rv);
-
 #define SHARED_SECRET_MAX 64
 
 #define MDF_CONSISTENT		(1 << 0)
-- 
1.7.9.5

