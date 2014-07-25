Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971AbaGYWtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:49:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:48838 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760684AbaGYWt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:49:29 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 09/11] f2fs: test before set/clear bits
Date: Fri, 25 Jul 2014 15:47:23 -0700
Message-Id: <1406328445-63707-9-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the bit is already set, we don't need to reset it, and vice versa.
Because we don't need to make the caches dirty for that.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 8f8685e..475f97c 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1003,7 +1003,8 @@ enum {
 
 static inline void set_inode_flag(struct f2fs_inode_info *fi, int flag)
 {
-	set_bit(flag, &fi->flags);
+	if (!test_bit(flag, &fi->flags))
+		set_bit(flag, &fi->flags);
 }
 
 static inline int is_inode_flag_set(struct f2fs_inode_info *fi, int flag)
@@ -1013,7 +1014,8 @@ static inline int is_inode_flag_set(struct f2fs_inode_info *fi, int flag)
 
 static inline void clear_inode_flag(struct f2fs_inode_info *fi, int flag)
 {
-	clear_bit(flag, &fi->flags);
+	if (test_bit(flag, &fi->flags))
+		clear_bit(flag, &fi->flags);
 }
 
 static inline void set_acl_inode(struct f2fs_inode_info *fi, umode_t mode)
-- 
1.8.5.2 (Apple Git-48)

