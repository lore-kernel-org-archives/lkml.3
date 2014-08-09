Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbaHICqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 22:46:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57794 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaHICqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 22:46:48 -0400
X-AuditID: cbfee61a-f79e46d00000134f-84-53e58b958cb9
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/5] f2fs: add infra macro and sturct for inline dir
Date: Sat, 09 Aug 2014 10:46:01 +0800
Message-id: <00bf01cfb37c$28d136b0$7a73a410$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+zfAXND+RJtj6RR92vRfthYDO0UQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jAd2p3U+DDTYvUrC4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxuEpKQWT
	uSo2v9/L2sB4lKOLkYNDQsBE4uPbsi5GTiBTTOLCvfVsILaQwCJGibMf67sYuYDsH4wS+yb0
	MIIk2ARUJJZ3/GcCsUUEvCQm7T/BAmIzC3hINHZ8ZwWxhQX8JM7deQJmswioSixf+ADM5hWw
	lLjacQLKFpT4MfkeVK+WxOZtTawQtrzE5jVvmSEOUpDYcfY1I8QuPYn2ra3sEDXiEhuP3GKZ
	wCgwC8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgsP5mdQOxpUN
	FocYBTgYlXh4V9g8DRZiTSwrrsw9xCjBwawkwruwEijEm5JYWZValB9fVJqTWnyIUZqDRUmc
	90CrdaCQQHpiSWp2ampBahFMlomDU6qBUbzfPlLwq0nAX45QgY4bGce33iruOm9c8a4jRP2D
	zummPUcPqckertAq/Sht2ao+90BM14q5MWU15zZoTbhdFpmv/2N7b9e/SR9PHdrHLt70L/PH
	Rp+HrV137kZdu8o+Ifac2mHXpO2VL2Ru7k1IePz6WNTWri9K+jbMctM09JNsom/5vGvOUWIp
	zkg01GIuKk4EAEvkUAtjAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines macro and inline dentry struct for inline dir infrastructure.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 include/linux/f2fs_fs.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 6ff0b0b..a79726b 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -423,6 +423,24 @@ struct f2fs_dentry_block {
 	__u8 filename[NR_DENTRY_IN_BLOCK][F2FS_SLOT_LEN];
 } __packed;
 
+/* for inline dir */
+#define NR_INLINE_DENTRY	(MAX_INLINE_DATA * BITS_PER_BYTE / \
+				((SIZE_OF_DIR_ENTRY + F2FS_SLOT_LEN) * \
+				BITS_PER_BYTE + 1))
+#define INLINE_DENTRY_BITMAP_SIZE	((NR_INLINE_DENTRY + \
+					BITS_PER_BYTE - 1) / BITS_PER_BYTE)
+#define INLINE_RESERVED_SIZE	(MAX_INLINE_DATA - \
+				((SIZE_OF_DIR_ENTRY + F2FS_SLOT_LEN) * \
+				NR_INLINE_DENTRY + INLINE_DENTRY_BITMAP_SIZE))
+
+/* inline directory entry structure */
+struct f2fs_inline_dentry {
+	__u8 dentry_bitmap[INLINE_DENTRY_BITMAP_SIZE];
+	__u8 reserved[INLINE_RESERVED_SIZE];
+	struct f2fs_dir_entry dentry[NR_INLINE_DENTRY];
+	__u8 filename[NR_INLINE_DENTRY][F2FS_SLOT_LEN];
+} __packed;
+
 /* file types used in inode_info->flags */
 enum {
 	F2FS_FT_UNKNOWN,
-- 
2.0.1.474.g72c7794


