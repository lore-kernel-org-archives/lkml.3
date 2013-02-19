Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab3BSCer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:34:47 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42746 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab3BSCeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:34:46 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 8/8] f2fs: add tracepoints to debug checkpoint request
Date: Tue, 19 Feb 2013 11:34:38 +0900
Message-Id: <1361241278-18277-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints to debug checkpoint request.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/checkpoint.c        |    1 +
 include/trace/events/f2fs.h |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index a0fce2c..047bcb8 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -604,6 +604,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 	void *kaddr;
 	int i;
 
+	trace_f2fs_do_checkpoint(sbi->sb);
 	/* Flush all the NAT/SIT pages */
 	while (get_pages(sbi, F2FS_DIRTY_META))
 		sync_meta_pages(sbi, META, LONG_MAX);
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 46856bd..9530635 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -502,6 +502,24 @@ DEFINE_EVENT(f2fs_page_type_op, f2fs_write_page,
 	TP_ARGS(page, type)
 );
 
+TRACE_EVENT(f2fs_do_checkpoint,
+	TP_PROTO(struct super_block *sb),
+
+	TP_ARGS(sb),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev))
+
+);
+
 #endif /* _TRACE_F2FS_H */
 
  /* This part must be outside protection */
-- 
1.7.9.5

