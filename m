Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab3BBOwy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:52:54 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:36421 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab3BBOwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:52:53 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 4/6] f2fs: mark gc_thread as NULL when thread creation failed
Date: Sat,  2 Feb 2013 23:52:42 +0900
Message-Id: <1359816762-16355-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

When gc thread creatio failed, mark gc_thread as NULL to avoid
crash while trying to stop invalid thread in
stop_gc_thread->kthread_stop.
Instead make it return from:
	if (!gc_th)
       return;

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/gc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index d344784..21f3ec6 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -107,6 +107,7 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
 				"f2fs_gc-%s", dev_name(sbi->sb->s_bdi->dev));
 	if (IS_ERR(gc_th->f2fs_gc_task)) {
 		kfree(gc_th);
+		sbi->gc_thread = NULL;
 		return -ENOMEM;
 	}
 	return 0;
-- 
1.7.9.5

