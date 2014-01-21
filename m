Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaAUJ4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:56:04 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:9330 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaAUJ4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:56:00 -0500
X-AuditID: cbfee68f-b7f156d00000276c-91-52de442fc884
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: call mark_inode_dirty to flush dirty pages
Date: Tue, 21 Jan 2014 18:54:33 +0900
Message-id: <1390298075-21458-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zI119l3tBBo+viltc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbHgZidbwTSeikVb
	7RsYW7m6GDk5JARMJNoOTGaGsMUkLtxbz9bFyMUhJLCMUWL64s9sMEV/pnWzQySmM0p86Oxi
	AkkICTQxSfxtUO5i5OBgE9CW2LzfACQsIsAssWDqeUaQemaBCYwS/xe9ZwFJCAu4Smzd9RKs
	l0VAVWLn1ANgm3kF3CWmrJrNCrFMW2Lb84lgzRICj9kkFiyZzQzRICDxbfIhFpBlEgKyEpsO
	QF0tKXFwxQ2WCYyCCxgZVjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmKEBGD/Dsa7B6wPMSYD
	jZvILCWanA8M4LySeENjMyMLUxNTYyNzSzPShJXEee8/TAoSEkhPLEnNTk0tSC2KLyrNSS0+
	xMjEwSnVwGhw+3Pfzali5r6G1+fnbdd2sNypka87Te6x4Xb+b5/V8+6/PGsdFabQG2i/4mjb
	fKOud3uyv4tmC61/lsepcGt3xdsHcTo/xV36NYJ+8+dtMPOeqCqSKM+msdPo0L8v/L/uzf7x
	6lf923BbSab+4ifNKSpixx737p8x12BDbJSW50bp1geH1yqxFGckGmoxFxUnAgDxOS2HVgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jQV19l3tBBm/eCVtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ix4GYnW8E0nopFW+0bGFu5uhg5OSQETCT+TOtmh7DFJC7cW8/WxcjFISQw
	nVHiQ2cXE0hCSKCJSeJvg3IXIwcHm4C2xOb9BiBhEQFmiQVTzzOC1DMLTGCU+L/oPQtIQljA
	VWLrrpdgvSwCqhI7px5gBrF5BdwlpqyazQqxTFti2/OJjBMYuRcwMqxiFE0tSC4oTkrPNdIr
	TswtLs1L10vOz93ECA7vZ9I7GFc1WBxiFOBgVOLhrdh4N0iINbGsuDL3EKMEB7OSCO8xx3tB
	QrwpiZVVqUX58UWlOanFhxiTgbZPZJYSTc4Hxl5eSbyhsYmZkaWRmYWRibk5acJK4rwHW60D
	hQTSE0tSs1NTC1KLYLYwcXBKNTBWXfheHTfFdD/nxxseh3x8H2bq228ozX9XqXKu2+xthjJf
	gnx6BZPas5WnMidbR0hkq6a4mfT5THxq/PWaXi6vmp+jyOFNt9gPbV4w49K0papsT84z7OSO
	6r73fKPlhkmPt5n8bs7atenDnenXdFaf7b+5xt1S7XPu1wSXspt7+S7GaS1ps9qrxFKckWio
	xVxUnAgAxJWhw7MCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a dentry page is updated, we should call mark_inode_dirty to add the inode
into the dirty list, so that its dentry pages are flushed to the disk.
Otherwise, the inode can be evicted without flush.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index cd055b6..1679e8b 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -387,7 +387,10 @@ static void update_parent_metadata(struct inode *dir, struct inode *inode,
 		}
 		clear_inode_flag(F2FS_I(inode), FI_NEW_INODE);
 	}
+
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+	mark_inode_dirty(dir);
+
 	if (F2FS_I(dir)->i_current_depth != current_depth) {
 		F2FS_I(dir)->i_current_depth = current_depth;
 		set_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
@@ -395,8 +398,6 @@ static void update_parent_metadata(struct inode *dir, struct inode *inode,
 
 	if (is_inode_flag_set(F2FS_I(dir), FI_UPDATE_DIR))
 		update_inode_page(dir);
-	else
-		mark_inode_dirty(dir);
 
 	if (is_inode_flag_set(F2FS_I(inode), FI_INC_LINK))
 		clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
@@ -549,12 +550,11 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	set_page_dirty(page);
 
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	mark_inode_dirty(dir);
 
 	if (inode && S_ISDIR(inode->i_mode)) {
 		drop_nlink(dir);
 		update_inode_page(dir);
-	} else {
-		mark_inode_dirty(dir);
 	}
 
 	if (inode) {
-- 
1.8.4.474.g128a96c

