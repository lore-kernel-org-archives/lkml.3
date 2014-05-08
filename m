Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbaEHJKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:10:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10144 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaEHJKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:10:14 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-88-536b49f440fa
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: use inode_init_owner() to simplify codes
Date: Thu, 08 May 2014 17:09:30 +0800
Message-id: <000201cf6a9d$5266c3f0$f7344bd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9qnQM2z4fQx4ZmTqa+2q+8kESDGw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQd0vntnBBvt+mVlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbHiwgHmgjnsFR2T
	HjE3ML5l7WLk5JAQMJG403+KGcIWk7hwbz0biC0kMJ1R4taO3C5GLiD7B6PE4ml3mUASbAIq
	Ess7/oPZIgKaEo+XbwZrZhbIlLjXNAPMFhbwlPh8+RfYIBYBVYlVjyezg9i8ApYSvTO2M0PY
	ghI/Jt9jgejVkli/8zgThC0vsXnNW6iDFCR2nH3NCLFLT2J/41tGiBpxiY1HbrFMYBSYhWTU
	LCSjZiEZNQtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwYH8TGoH48oGi0OMAhyM
	Sjy8Gc5ZwUKsiWXFlbmHGCU4mJVEeNMcs4OFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4U
	EkhPLEnNTk0tSC2CyTJxcEo1MJquUDijHmarfvrPrijNQuUD559MZ/E4I3DE5BvzOoG8N8e5
	FZ6+VzxUyXWqtE9HrENr0t6wsFXzfWpvsYox1NatnNt+dnv8nehHl5rye/5P/7vdqOfoJZ3k
	0G5brcVPTRfNzD2veXhxR9mE398udR8w6k1kMa6YzriPySFx2qbcG0dD5mpsKFZiKc5INNRi
	LipOBAChjwv1YAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses exported inode_init_owner() to simplify codes in
f2fs_new_inode().

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/namei.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index a9409d1..9138c32 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -41,18 +41,9 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 	}
 	f2fs_unlock_op(sbi);
 
-	inode->i_uid = current_fsuid();
-
-	if (dir->i_mode & S_ISGID) {
-		inode->i_gid = dir->i_gid;
-		if (S_ISDIR(mode))
-			mode |= S_ISGID;
-	} else {
-		inode->i_gid = current_fsgid();
-	}
+	inode_init_owner(inode, dir, mode);
 
 	inode->i_ino = ino;
-	inode->i_mode = mode;
 	inode->i_blocks = 0;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	inode->i_generation = sbi->s_next_generation++;
-- 
1.7.9.5


