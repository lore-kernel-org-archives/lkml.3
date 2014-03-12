Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbaCLH7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 03:59:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43307 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413AbaCLH7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 03:59:54 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-7a-532013f8236d
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [f2fs-dev] [PATCH] f2fs: introduce f2fs_has_inline_xattr for better
 readability
Date: Wed, 12 Mar 2014 15:59:03 +0800
Message-id: <001501cf3dc9$0ca56340$25f029c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac89yEl+e5jmCcmYSCqvfLBtTeUaHg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jQd0fwgrBBo+nKVtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlTH39FSmgms8FQ/P
	H2ZtYDzJ1cXIySEhYCLxZv8RVghbTOLCvfVsXYxcHEIC0xklGm6tY4FwfjBKrDtyiR2kik1A
	RWJ5x38mEFtEQFFiw/sNYHFmgUyJCfvns4DYwgJREp//PGUEsVkEVCX6H+9lA7F5BSwlpp3d
	xARhC0r8mHyPBaJXS2L9zuNMELa8xOY1b5khLlKQ2HH2NSPELj2J2cdPQO0Sl9h45BbLBEaB
	WUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzKz6R3MK5qsDjE
	KMDBqMTDu1BTPliINbGsuDL3EKMEB7OSCO9HkBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeg63W
	gUIC6YklqdmpqQWpRTBZJg5OqQZG6x/8Rz++FHr3/9M0Z9Mp388pimk1HI0Vr4y/oi925dIX
	hb77+vOurTe78oW3sltM3FB+4ZomlQLFD1mabpxXHiQvq2uOkbvYGrlt+s0LV1Mv9l8offYj
	M/P3wfmrfu75fOvO38BMc07x69+SX24oW+Ohcvpq0IHlF65dOVP2+BJnzKa3S9iaS5RYijMS
	DbWYi4oTAc6Y4SdhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a help function f2fs_has_inline_xattr for better
readability.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h |    9 +++++++--
 fs/f2fs/node.c |    2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f845e92..1f87a04 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -991,9 +991,14 @@ static inline void set_raw_inline(struct f2fs_inode_info *fi,
 		ri->i_inline |= F2FS_INLINE_DATA;
 }
 
+static inline int f2fs_has_inline_xattr(struct inode *inode)
+{
+	return is_inode_flag_set(F2FS_I(inode), FI_INLINE_XATTR);
+}
+
 static inline unsigned int addrs_per_inode(struct f2fs_inode_info *fi)
 {
-	if (is_inode_flag_set(fi, FI_INLINE_XATTR))
+	if (f2fs_has_inline_xattr(&fi->vfs_inode))
 		return DEF_ADDRS_PER_INODE - F2FS_INLINE_XATTR_ADDRS;
 	return DEF_ADDRS_PER_INODE;
 }
@@ -1007,7 +1012,7 @@ static inline void *inline_xattr_addr(struct page *page)
 
 static inline int inline_xattr_size(struct inode *inode)
 {
-	if (is_inode_flag_set(F2FS_I(inode), FI_INLINE_XATTR))
+	if (f2fs_has_inline_xattr(inode))
 		return F2FS_INLINE_XATTR_ADDRS << 2;
 	else
 		return 0;
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e72b258..c618fad 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1501,7 +1501,7 @@ void recover_inline_xattr(struct inode *inode, struct page *page)
 	struct page *ipage;
 	struct f2fs_inode *ri;
 
-	if (!is_inode_flag_set(F2FS_I(inode), FI_INLINE_XATTR))
+	if (!f2fs_has_inline_xattr(inode))
 		return;
 
 	if (!IS_INODE(page))
-- 
1.7.9.5


