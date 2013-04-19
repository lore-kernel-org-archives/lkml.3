Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab3DSQ1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:27:36 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:38425 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab3DSQ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:27:34 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 1/2] f2fs: make is_multimedia_file code align with its name
Date: Sat, 20 Apr 2013 01:27:21 +0900
Message-Id: <1366388841-18701-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

The code conditions put inside the function is_multimedia_file are
reverse to the name i.e, we need to negate the return to actually
check if the file is a multimedia file. So, change the code and usage
path to align both the name and comparision conditions.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/namei.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 6c5e804..c57fd18 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -84,7 +84,7 @@ static int is_multimedia_file(const unsigned char *s, const char *sub)
 	int ret;
 
 	if (sublen > slen)
-		return 1;
+		return 0;
 
 	ret = memcmp(s + slen - sublen, sub, sublen);
 	if (ret) {	/* compare upper case */
@@ -92,10 +92,10 @@ static int is_multimedia_file(const unsigned char *s, const char *sub)
 		char upper_sub[8];
 		for (i = 0; i < sublen && i < sizeof(upper_sub); i++)
 			upper_sub[i] = toupper(sub[i]);
-		return memcmp(s + slen - sublen, upper_sub, sublen);
+		return !memcmp(s + slen - sublen, upper_sub, sublen);
 	}
 
-	return ret;
+	return !ret;
 }
 
 /*
@@ -109,7 +109,7 @@ static inline void set_cold_files(struct f2fs_sb_info *sbi, struct inode *inode,
 
 	int count = le32_to_cpu(sbi->raw_super->extension_count);
 	for (i = 0; i < count; i++) {
-		if (!is_multimedia_file(name, extlist[i])) {
+		if (is_multimedia_file(name, extlist[i])) {
 			set_cold_file(inode);
 			break;
 		}
-- 
1.7.9.5

