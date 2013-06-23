Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085Ab3FWHDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 03:03:45 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:65444 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3FWHDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 03:03:41 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH 1/6] Staging: silicom: remove bp_media_type enum typedef
Date: Sun, 23 Jun 2013 02:02:23 -0500
Message-Id: <1371970948-26802-2-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371970948-26802-1-git-send-email-chad@dahc.us>
References: <1371970948-26802-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the typedef for enum bp_media_type from bpctl_mod.c and
change its one use accordingly, resolving a checkpatch.pl warning.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bpctl_mod.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 31fd3d5..33e226d 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -52,12 +52,12 @@ if (down_interruptible(&bpctl_sema)) {			\
 	up(&bpctl_sema);
 
 /* Media Types */
-typedef enum {
+enum bp_media_type {
 	bp_copper = 0,
 	bp_fiber,
 	bp_cx4,
 	bp_none,
-} bp_media_type;
+};
 
 struct bypass_pfs_sd {
 	char dir_name[32];
@@ -89,7 +89,7 @@ typedef struct _bpctl_dev {
 	uint32_t reset_time;
 	uint8_t bp_status_un;
 	atomic_t wdt_busy;
-	bp_media_type media_type;
+	enum bp_media_type media_type;
 	int bp_tpl_flag;
 	struct timer_list bp_tpl_timer;
 	spinlock_t bypass_wr_lock;
-- 
1.8.1.4

