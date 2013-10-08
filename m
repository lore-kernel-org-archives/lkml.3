Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3JHJMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:12:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47890 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab3JHJMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:12:10 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-45-5253cc684a11
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: fix to store and retrieve i_rdev correctly
Date: Tue, 08 Oct 2013 18:11:40 +0900
Message-id: <1381223500-6582-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zA92MM8FBBo+XaFhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXHiWj9TQY9UxbKr
	n1kaGI+LdjFyckgImEhcPNnEDGGLSVy4t56ti5GLQ0hgGaPEsRN/mWCKvi2YwgSRmM4o0bj6
	FjuE08wkMenhXcYuRg4ONgFtic37DUAaRASYJRZMPc8IUsMsMIFR4v+i9ywgCWEBR4nrrY+Z
	QOpZBFQl+peng4R5BdwkHvbfg7pCW2Lb84lgvRICj9kklh2/CZZgERCQ+Db5EAtIr4SArMSm
	A1D1khIHV9xgmcAouICRYRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGSAhO3MF4/4D1IcZk
	oHETmaVEk/OBIZxXEm9obGZkYWpiamxkbmlGmrCSOK96i3WgkEB6YklqdmpqQWpRfFFpTmrx
	IUYmDk6pBsa+/x8WyIlGTE8Q3TNxh07xWiPeZ2G+Yaa3HZQFBW979zozWMuw+gZfPl9u1RY3
	I/7V6gPb+k6+zijc7ffsrymXZ8yuLwJv17B0iG3fVe4jFli9ikF0i1/Zxa9cnTvMTF8tZhTc
	9OWtubBthIaFhrHg3lWrphS9X1POZGjCV/Drzgf9RUUnApVYijMSDbWYi4oTAew+5NZXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd2MM8FBBkcnqlhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hx4lo/U0GPVMWyq59ZGhiPi3YxcnJICJhIfFswhQnCFpO4cG89WxcjF4eQ
	wHRGicbVt9ghnGYmiUkP7zJ2MXJwsAloS2zebwDSICLALLFg6nlGkBpmgQmMEv8XvWcBSQgL
	OEpcb33MBFLPIqAq0b88HSTMK+Am8bD/HjPEMm2Jbc8nMk5g5F7AyLCKUTS1ILmgOCk910iv
	ODG3uDQvXS85P3cTIzjAn0nvYFzVYHGIUYCDUYmHV+BwUJAQa2JZcWXuIUYJDmYlEV4Bo+Ag
	Id6UxMqq1KL8+KLSnNTiQ4zJQMsnMkuJJucDoy+vJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaB
	QgLpiSWp2ampBalFMFuYODilGhhLmyuZhURvHXKOVTs2aYfz6d0L/rqt6blVsOkdB/u2b8v0
	s2p6xA2OPPr9ptVmo0Dzx8XKohGFIQuE5sZe0vuVxvv2lny74FxB2Xfn3swKvH5Ukv3Ngt4H
	xy65+rAc09o3scOQ7ctLv7gJOSECwfcOHqxPVauI2LA6dg/v+gMHPJc6Rvfmh39UYinOSDTU
	Yi4qTgQA2NAR5rQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously f2fs stores i_rdev information into i_addr.
But, if inline_xattr is set, f2fs should avoid using i_addr fields.
So, this patch adds to use i_nid fields instead of i_addrs when inline_xattr
is set.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/inode.c | 63 +++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 46 insertions(+), 17 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index c8c0580..fab657f 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -37,6 +37,45 @@ void f2fs_set_inode_flags(struct inode *inode)
 		inode->i_flags |= S_DIRSYNC;
 }
 
+static void get_inode_rdev(struct inode *inode, struct f2fs_inode *ri)
+{
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
+			S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
+		__le32 *rdev;
+
+		if (is_inode_flag_set(F2FS_I(inode), FI_INLINE_XATTR))
+			rdev = ri->i_nid;
+		else
+			rdev = ri->i_addr;
+
+		if (rdev[0])
+			inode->i_rdev = old_decode_dev(le32_to_cpu(rdev[0]));
+		else
+			inode->i_rdev = new_decode_dev(le32_to_cpu(rdev[1]));
+	}
+}
+
+static void set_inode_rdev(struct inode *inode, struct f2fs_inode *ri)
+{
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
+		__le32 *rdev;
+
+		if (is_inode_flag_set(F2FS_I(inode), FI_INLINE_XATTR))
+			rdev = ri->i_nid;
+		else
+			rdev = ri->i_addr;
+
+		if (old_valid_dev(inode->i_rdev)) {
+			rdev[0] = cpu_to_le32(old_encode_dev(inode->i_rdev));
+			rdev[1] = 0;
+		} else {
+			rdev[0] = 0;
+			rdev[1] = cpu_to_le32(new_encode_dev(inode->i_rdev));
+			rdev[2] = 0;
+		}
+	}
+}
+
 static int do_read_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
@@ -73,10 +112,6 @@ static int do_read_inode(struct inode *inode)
 	inode->i_ctime.tv_nsec = le32_to_cpu(ri->i_ctime_nsec);
 	inode->i_mtime.tv_nsec = le32_to_cpu(ri->i_mtime_nsec);
 	inode->i_generation = le32_to_cpu(ri->i_generation);
-	if (ri->i_addr[0])
-		inode->i_rdev = old_decode_dev(le32_to_cpu(ri->i_addr[0]));
-	else
-		inode->i_rdev = new_decode_dev(le32_to_cpu(ri->i_addr[1]));
 
 	fi->i_current_depth = le32_to_cpu(ri->i_current_depth);
 	fi->i_xattr_nid = le32_to_cpu(ri->i_xattr_nid);
@@ -84,8 +119,13 @@ static int do_read_inode(struct inode *inode)
 	fi->flags = 0;
 	fi->i_advise = ri->i_advise;
 	fi->i_pino = le32_to_cpu(ri->i_pino);
+
 	get_extent_info(&fi->ext, ri->i_ext);
 	get_inline_info(fi, ri);
+
+	/* get rdev by using inline_info */
+	get_inode_rdev(inode, ri);
+
 	f2fs_put_page(node_page, 1);
 	return 0;
 }
@@ -179,21 +219,10 @@ void update_inode(struct inode *inode, struct page *node_page)
 	ri->i_pino = cpu_to_le32(F2FS_I(inode)->i_pino);
 	ri->i_generation = cpu_to_le32(inode->i_generation);
 
-	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
-		if (old_valid_dev(inode->i_rdev)) {
-			ri->i_addr[0] =
-				cpu_to_le32(old_encode_dev(inode->i_rdev));
-			ri->i_addr[1] = 0;
-		} else {
-			ri->i_addr[0] = 0;
-			ri->i_addr[1] =
-				cpu_to_le32(new_encode_dev(inode->i_rdev));
-			ri->i_addr[2] = 0;
-		}
-	}
-
+	set_inode_rdev(inode, ri);
 	set_cold_node(inode, node_page);
 	set_page_dirty(node_page);
+
 	clear_inode_flag(F2FS_I(inode), FI_DIRTY_INODE);
 }
 
-- 
1.8.4.474.g128a96c

