Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab3EWN6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:58:37 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:37504 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758976Ab3EWN6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:58:35 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 3/4] f2fs: return proper error from start_gc_thread
Date: Thu, 23 May 2013 22:58:22 +0900
Message-Id: <1369317502-14380-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

when there is an error from kthread_run, then return proper error
rather than returning -ENOMEM.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/gc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 25b083c..03d5ba1 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -105,7 +105,7 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
 	if (IS_ERR(gc_th->f2fs_gc_task)) {
 		kfree(gc_th);
 		sbi->gc_thread = NULL;
-		return -ENOMEM;
+		return PTR_ERR(gc_th->f2fs_gc_task);
 	}
 	return 0;
 }
-- 
1.7.9.5

