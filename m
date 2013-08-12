Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3HLH7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 03:59:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38123 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3HLH6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:58:54 -0400
X-AuditID: cbfee68f-b7f436d000000f81-a0-520895bb84ce
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: should cover i_xattr_nid with its xattr node page
 lock
Date: Mon, 12 Aug 2013 16:58:54 +0900
Message-id: <1376294334-11699-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
In-reply-to: <1376294334-11699-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1376294334-11699-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zA93dUzmCDBYvVLS4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+Pq/MvMBYeEK24t
	1mhg7OTrYuTkkBAwkTg+bRsLhC0mceHeerYuRi4OIYFljBInL8xjgim6tvkvO0RiEaPEm8+P
	WSCcNiaJrmXzGbsYOTjYBLQlNu83AGkQEWCWWDD1PCNIDbPABEaJ/4ves4DUCAsESzSccwWp
	YRFQlbj7/ycbiM0r4C7x5OdxNohluhKLThxkBbE5BTwkzh84yQhiCwHVbHq9BmyvhMBvNolb
	r66wQQwSkPg2+RDYfAkBWYlNB5gh5khKHFxxg2UCo/ACRoZVjKKpBckFxUnpRcZ6xYm5xaV5
	6XrJ+bmbGCEB27+D8e4B60OMyUDjJjJLiSbnAwM+ryTe0NjMyMLUxNTYyNzSjDRhJXFetRbr
	QCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mx9ZzaPw9uVHPYYP4slM+vV/3Niy728jSL9JU
	3lwylV1B6X6ywe51AdeW/nO+Pie/UK7p1OULbT/rqkIWz/x1KbqsYU1eleKX7c387j6/32a/
	4zleGX9hrnzKH4G9sus89t14xfb/mlz4mlj1ztem3tLXts4/29Hy3tbuh73kzG+rk/dOCl10
	VYmlOCPRUIu5qDgRAHjMw59uAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd3dUzmCDHreCVhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hxdf5l5oJDwhW3Fms0MHbydTFyckgImEhc2/yXHcIWk7hwbz1bFyMXh5DA
	IkaJN58fs0A4bUwSXcvmM3YxcnCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwGpERYI
	lmg45wpSwyKgKnH3/082EJtXwF3iyc/jbBDLdCUWnTjICmJzCnhInD9wkhHEFgKq2fR6DcsE
	Rt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLj4ZnUDsaVDRaHGAU4GJV4eD2+sAcJ
	sSaWFVfmHmKU4GBWEuHlbeQIEuJNSaysSi3Kjy8qzUktPsSYDHTVRGYp0eR8YKzmlcQbGpuY
	GVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANjyfR7H25pn92msUL2udVl
	TSueDS+OlsSkmWd/U/1ncrL0wF1OV23XWnmnHe0eDPoR7//3ddpuUrtcwvluq+wW85CDZh45
	vTn+bFtPG25Z02bI6bw348aRM0GSk2cKWzn0tZWdnXbBNdrIe7Wce+I3vzKBnj7La4aPTEKa
	NZ6tf8f39NXkFZ+VWIozEg21mIuKEwH717zbywIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, f2fs_setxattr assigns i_xattr_nid in the inode page inconsistently.

The scenario is:

= Thread 1 =         = Thread 2 =     = fi->i_xattr_nid =  = on-disk nid =

f2fs_setxattr                                   0                 0
  new_node_page                                 X                 0
                   sync_inode_page              X                 X
                   checkpoint                   X                 X -.
    grab_cache_page                             X                 X  |
--> allocate a new xattr node block or -ENOSPC      <----------------'

At this moment, the checkpoint stores inconsistent data where the inode has
i_xattr_nid but actual xattr node block is not allocated yet.

So, we should assign the real i_xattr_nid only after its xattr node block is
allocated.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c  |  3 +++
 fs/f2fs/xattr.c | 10 +++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 858a333..1c21344 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -851,6 +851,9 @@ struct page *new_node_page(struct dnode_of_data *dn,
 	SetPageUptodate(page);
 	set_page_dirty(page);
 
+	if (ofs == XATTR_NODE_OFFSET)
+		F2FS_I(dn->inode)->i_xattr_nid = dn->nid;
+
 	dn->node_page = page;
 	if (ipage)
 		update_inode(dn->inode, ipage);
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index fb16f71..3bc307c 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -378,23 +378,23 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 	if (!fi->i_xattr_nid) {
 		/* Allocate new attribute block */
 		struct dnode_of_data dn;
+		nid_t new_nid;
 
-		if (!alloc_nid(sbi, &fi->i_xattr_nid)) {
+		if (!alloc_nid(sbi, &new_nid)) {
 			error = -ENOSPC;
 			goto exit;
 		}
-		set_new_dnode(&dn, inode, NULL, NULL, fi->i_xattr_nid);
+		set_new_dnode(&dn, inode, NULL, NULL, new_nid);
 		mark_inode_dirty(inode);
 
 		page = new_node_page(&dn, XATTR_NODE_OFFSET, ipage);
 		if (IS_ERR(page)) {
-			alloc_nid_failed(sbi, fi->i_xattr_nid);
-			fi->i_xattr_nid = 0;
+			alloc_nid_failed(sbi, new_nid);
 			error = PTR_ERR(page);
 			goto exit;
 		}
 
-		alloc_nid_done(sbi, fi->i_xattr_nid);
+		alloc_nid_done(sbi, new_nid);
 		base_addr = page_address(page);
 		header = XATTR_HDR(base_addr);
 		header->h_magic = cpu_to_le32(F2FS_XATTR_MAGIC);
-- 
1.8.3.1.437.g0dbd812

