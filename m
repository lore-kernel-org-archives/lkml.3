Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaDXD0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 23:26:07 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55165 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaDXD0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 23:26:04 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: haver@linux.vnet.ibm.com, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] misc: genwqe: Fix format string mismatch in card_debugfs.c
Date: Thu, 24 Apr 2014 12:25:49 +0900
Message-Id: <1398309949-23305-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.0.rc0.26.g779792a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two format string mismatch in genwqe_init_debugfs()

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/misc/genwqe/card_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/genwqe/card_debugfs.c b/drivers/misc/genwqe/card_debugfs.c
index 50d2096..0a33ade 100644
--- a/drivers/misc/genwqe/card_debugfs.c
+++ b/drivers/misc/genwqe/card_debugfs.c
@@ -348,7 +348,7 @@ int genwqe_init_debugfs(struct genwqe_dev *cd)
 	char name[64];
 	unsigned int i;
 
-	sprintf(card_name, "%s%u_card", GENWQE_DEVNAME, cd->card_idx);
+	sprintf(card_name, "%s%d_card", GENWQE_DEVNAME, cd->card_idx);
 
 	root = debugfs_create_dir(card_name, cd->debugfs_genwqe);
 	if (!root) {
@@ -454,7 +454,7 @@ int genwqe_init_debugfs(struct genwqe_dev *cd)
 	}
 
 	for (i = 0; i <  GENWQE_MAX_VFS; i++) {
-		sprintf(name, "vf%d_jobtimeout_msec", i);
+		sprintf(name, "vf%u_jobtimeout_msec", i);
 
 		file = debugfs_create_u32(name, 0666, root,
 					  &cd->vf_jobtimeout_msec[i]);
-- 
2.0.0.rc0.26.g779792a

