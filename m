Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab3E1BVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 21:21:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63331 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab3E1BVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 21:21:04 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-f0-51a4067c4105
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/3] f2fs: fix incorrect iputs during the dentry recovery
Date: Tue, 28 May 2013 10:19:45 +0900
Message-id: <1369703985-26284-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1369703985-26284-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1369703985-26284-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zfd0atiWBBh//cFtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlTHh3WWmghucFRdn
	3WdtYPzJ3sXIySEhYCIxcec1RghbTOLCvfVsXYxcHEICyxgllq5uhiv6sfA9M0RiOqNE44x5
	LBBOG5PEpwk3gDIcHGwC2hKb9xuANIgIMEssmHqeEaSGWWACo8T/Re9ZQBLCAp4S/1sOMYHY
	LAKqEq39b5lAenkF3CX6Z3hCLNOVWP3/OTtImFPAQ+JAiyxIWAio4tuNp6wgIyUEvrNJPHm4
	mw1ijIDEt8mHWEDqJQRkJTYdYIYYIylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXmegVJ+YWl+al
	6yXn525ihATshB2M9w5YH2JMBho3kVlKNDkfGPB5JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gH
	CgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDMvm6osPWaO/tMn48M9ef3T1KKifxqw/7Av7yX
	ufp2n0JfSdvDdMEbD550MC/5NHXzBNMVHzoqVSf8jvF4nOoRvHLzb5fquz//zY3xkw82nya1
	8fnj6o6uWdbp6zS+/59f8t2ppNdqSn+Z+fodSS+7wm97vSiaMLXE8cM5H4XMqCjjaZNVQ78o
	sRRnJBpqMRcVJwIAdmibWG4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jQd0atiWBBjPucVhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5gx4d1lpoIbnBUXZ91nbWD8yd7FyMkhIWAi8WPhe2YIW0ziwr31bF2MXBxC
	AtMZJRpnzGOBcNqYJD5NuAFUxcHBJqAtsXm/AUiDiACzxIKp5xlBapgFJjBK/F/0ngUkISzg
	KfG/5RATiM0ioCrR2v+WCaSXV8Bdon+GJ8QyXYnV/5+zg4Q5BTwkDrTIgoSFgCq+3XjKOoGR
	dwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Hh4Jr2DcVWDxSFGAQ5GJR7eCdmLA4VY
	E8uKK3MPMUpwMCuJ8G5fARTiTUmsrEotyo8vKs1JLT7EmAx000RmKdHkfGCs5pXEGxqbmBlZ
	GplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY+nNVXannk6UW/dFLvGSaJLJ
	BesOpt1G1xdzb18gmMfo3fZHyXPnApM0rlp2gWzTVT9uRc1Lfsu75sjqBc1lupPvFF1g6Ld9
	YyFc8IDP3LT/3cTDe/Kn5ZhKyBjbWl0Re3SI56aS2gPxxc6LP/5xkv2z/fcPDbvGNyZry5ms
	j2zIV7ZuyQmqUGIpzkg01GIuKk4EAIERGfHLAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- iget/iput flow in the dentry recovery process

1. *dir* = f2fs_iget
2. set FI_DELAY_IPUT to *dir*
3. add *dir* to the dirty_dir_list
		   - __f2fs_add_link
		     - recover_dentry)
4. iput *dir* by remove_dirty_dir_inode
		   - sync_dirty_dir_inodes
		     - write_chekcpoint

If *dir*'s i_count is not 1 (i.e., root dir), remove_dirty_dir_inode is called
later and then iput is triggered again due to the FI_DELAY_IPUT flag.
So, let's unset the flag properly once iput is triggered.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 0d3701d..6f56e57 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -521,8 +521,10 @@ void remove_dirty_dir_inode(struct inode *inode)
 	spin_unlock(&sbi->dir_inode_lock);
 
 	/* Only from the recovery routine */
-	if (is_inode_flag_set(F2FS_I(inode), FI_DELAY_IPUT))
+	if (is_inode_flag_set(F2FS_I(inode), FI_DELAY_IPUT)) {
+		clear_inode_flag(F2FS_I(inode), FI_DELAY_IPUT);
 		iput(inode);
+	}
 }
 
 struct inode *check_dirty_dir_inode(struct f2fs_sb_info *sbi, nid_t ino)
-- 
1.8.1.3.566.gaa39828

