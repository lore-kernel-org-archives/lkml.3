Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3CBDl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:41:28 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:35981 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3CBDl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:41:26 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 4/5] f2fs: align f2fs maximum name length to linux based filesystem
Date: Sat,  2 Mar 2013 12:41:18 +0900
Message-Id: <1362195678-20785-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Since, maximum filename length supported in linux is 255 characters.
So, there is no need to reserve space for 256 characters in f2fs inode.
This aligns the filename length to NFS requests also which also
has a default limit of '255'.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 include/linux/f2fs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index f9a12f6..f7bd27d 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -139,7 +139,7 @@ struct f2fs_extent {
 	__le32 len;		/* lengh of the extent */
 } __packed;
 
-#define F2FS_MAX_NAME_LEN	256
+#define F2FS_MAX_NAME_LEN	255
 #define ADDRS_PER_INODE         923	/* Address Pointers in an Inode */
 #define ADDRS_PER_BLOCK         1018	/* Address Pointers in a Direct Block */
 #define NIDS_PER_BLOCK          1018	/* Node IDs in an Indirect Block */
@@ -166,6 +166,7 @@ struct f2fs_inode {
 	__le32 i_pino;			/* parent inode number */
 	__le32 i_namelen;		/* file name length */
 	__u8 i_name[F2FS_MAX_NAME_LEN];	/* file name for SPOR */
+	__u8 i_reserved_2;		/* reserved for future use*/
 
 	struct f2fs_extent i_ext;	/* caching a largest extent */
 
-- 
1.7.9.5

