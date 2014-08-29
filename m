Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaH2Qz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:55:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:39000 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbaH2Qz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:55:58 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs: fix wrong casting for dentry name
Date: Fri, 29 Aug 2014 09:55:52 -0700
Message-Id: <1409331352-36388-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dentry name type is unsigned char *.
If we don't match this type, some character codes can be changed by signed bit.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/hash.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/hash.c b/fs/f2fs/hash.c
index 948d17bf..a844fcf 100644
--- a/fs/f2fs/hash.c
+++ b/fs/f2fs/hash.c
@@ -42,7 +42,8 @@ static void TEA_transform(unsigned int buf[4], unsigned int const in[])
 	buf[1] += b1;
 }
 
-static void str2hashbuf(const char *msg, size_t len, unsigned int *buf, int num)
+static void str2hashbuf(const unsigned char *msg, size_t len,
+				unsigned int *buf, int num)
 {
 	unsigned pad, val;
 	int i;
@@ -73,9 +74,9 @@ f2fs_hash_t f2fs_dentry_hash(const struct qstr *name_info)
 {
 	__u32 hash;
 	f2fs_hash_t f2fs_hash;
-	const char *p;
+	const unsigned char *p;
 	__u32 in[8], buf[4];
-	const char *name = name_info->name;
+	const unsigned char *name = name_info->name;
 	size_t len = name_info->len;
 
 	if ((len <= 2) && (name[0] == '.') &&
-- 
1.8.5.2 (Apple Git-48)

