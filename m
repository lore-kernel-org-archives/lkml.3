Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaHOWC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 18:02:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:54421 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaHOWCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 18:02:55 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/4] f2fs: add WARN_ON in f2fs_bug_on
Date: Fri, 15 Aug 2014 15:03:46 -0700
Message-Id: <1408140229-54949-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds WARN_ON when f2fs_bug_on is disable to see kernel messages.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2d009ae..2723b2d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -24,7 +24,7 @@
 #define f2fs_bug_on(condition)	BUG_ON(condition)
 #define f2fs_down_write(x, y)	down_write_nest_lock(x, y)
 #else
-#define f2fs_bug_on(condition)
+#define f2fs_bug_on(condition)	WARN_ON(condition)
 #define f2fs_down_write(x, y)	down_write(x)
 #endif
 
-- 
1.8.5.2 (Apple Git-48)

