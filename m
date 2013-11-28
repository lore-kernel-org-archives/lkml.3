Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab3K1UBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 15:01:05 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:33090 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356Ab3K1TzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:16 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/34] sysfs, kernfs: reorganize SYSFS_* constants
Date: Thu, 28 Nov 2013 14:54:28 -0500
Message-Id: <1385668487-10181-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to add one more SYSFS_FLAG_* but we can't use the next higher
bit, 0x10000, as the flag field is 16bits wide.  The flags are
currently arranged weirdly - 8 bits are set aside for the type flags
when there are only three three used, the first flag starts at 0x1000
instead of 0x0100 and flag literals have 5 digits (20 bits) when only
4 digits can be used.

Rearrange them so that type bits are only the lowest four, flags start
at 0x0010 and similar flags are grouped.

This patch doesn't cause any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/sysfs.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index a6542d2..c86456c 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -80,18 +80,18 @@ struct sysfs_dirent {
 
 #define SD_DEACTIVATED_BIAS		INT_MIN
 
-#define SYSFS_TYPE_MASK			0x00ff
+#define SYSFS_TYPE_MASK			0x000f
 #define SYSFS_DIR			0x0001
 #define SYSFS_KOBJ_ATTR			0x0002
-#define SYSFS_KOBJ_LINK			0x0008
+#define SYSFS_KOBJ_LINK			0x0004
 #define SYSFS_COPY_NAME			(SYSFS_DIR | SYSFS_KOBJ_LINK)
 #define SYSFS_ACTIVE_REF		SYSFS_KOBJ_ATTR
 
 #define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
-#define SYSFS_FLAG_NS			0x01000
-#define SYSFS_FLAG_REMOVED		0x02000
-#define SYSFS_FLAG_HAS_SEQ_SHOW		0x04000
-#define SYSFS_FLAG_HAS_MMAP		0x08000
+#define SYSFS_FLAG_REMOVED		0x0010
+#define SYSFS_FLAG_NS			0x0020
+#define SYSFS_FLAG_HAS_SEQ_SHOW		0x0040
+#define SYSFS_FLAG_HAS_MMAP		0x0080
 
 static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 {
-- 
1.8.4.2

