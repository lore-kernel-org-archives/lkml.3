Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbaCSA1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:27:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38115 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758489AbaCSA0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:26:17 -0400
X-AuditID: cbfee690-b7f266d00000287c-6e-5328e425e919
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/5] f2fs: introduce get_dirty_dents for readability
Date: Wed, 19 Mar 2014 09:24:21 +0900
Message-id: <1395188665-4175-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zA13VJxrBBmdmcllc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbFz6U+2gibeisYr
	l5kbGH9wdTFyckgImEhc7bnGAmGLSVy4t56ti5GLQ0hgGaPEsk9b2WCKZt5dywSRWMQocbvz
	HCOE08kk8aztHlAVBwebgLbE5v0GIA0iAswSC6aeB6thFpjAKPF/0XuwFcICLhJrNn5iBrFZ
	BFQlfn7YCWbzCrhJLFq2jB1im7bEtucTwZolBO6zSdxbf54VokFA4tvkQywgyyQEZCU2HWCG
	qJeUOLjiBssERsEFjAyrGEVTC5ILipPSi0z0ihNzi0vz0vWS83M3MUKCcMIOxnsHrA8xJgON
	m8gsJZqcDwzivJJ4Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGanphakFsUXleakFh9i
	ZOLglGpgDHexFjvhvJwnMoGX202wJHq9Vsk123DO2bNWnJT/kez/8PCp5lN1316b/tisf+Tk
	ySme/2e6csWxTpq+d6X+a85pPx/l3XnE8NWI0zjmXd6vlVoXcsy+V/Epvr3HKrBr3/+/CwQj
	ts049yu+/s0Fgcl2SVbZp91UT11auEhvWXJWuu3lR4t/XVViKc5INNRiLipOBAC8Xti8WAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jAV3VJxrBBt9Ps1lc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ixc+lPtoIm3orGK5eZGxh/cHUxcnJICJhIzLy7lgnCFpO4cG89WxcjF4eQ
	wCJGidud5xghnE4miWdt94AyHBxsAtoSm/cbgDSICDBLLJh6HqyGWWACo8T/Re9ZQBLCAi4S
	azZ+YgaxWQRUJX5+2Alm8wq4SSxatowdYpu2xLbnExknMHIvYGRYxSiaWpBcUJyUnmuoV5yY
	W1yal66XnJ+7iREc4s+kdjCubLA4xCjAwajEw3sgSiNYiDWxrLgy9xCjBAezkgiv8F2gEG9K
	YmVValF+fFFpTmrxIcZkoO0TmaVEk/OB8ZdXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0
	xJLU7NTUgtQimC1MHJxSDYxKN/NaP9tLcXz9Y7jrX/X0/mVPfdIU1JYsSdzAvtJmU8SRSpu6
	mIyKp27PN8sIbhS7umlPbtq/6Zxtpi8ONi5lMz+17l7kAfcFM6e6dUxU+StrzyKx5ovFJ6kr
	xpExanunV52RVDAU0uqyDhOZepYtbv/uCF7xO2Vc3N7sO3ImKnMqXE9WEVBiKc5INNRiLipO
	BABt56a1tQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The get_dirty_dents gives us the number of dirty dentry pages.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 2 +-
 fs/f2fs/f2fs.h       | 5 +++++
 fs/f2fs/inode.c      | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 911b6f9..4c0e98d 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -619,7 +619,7 @@ void remove_dirty_dir_inode(struct inode *inode)
 		return;
 
 	spin_lock(&sbi->dir_inode_lock);
-	if (atomic_read(&F2FS_I(inode)->dirty_dents)) {
+	if (get_dirty_dents(inode)) {
 		spin_unlock(&sbi->dir_inode_lock);
 		return;
 	}
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 292cc3c..59fac1a 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -704,6 +704,11 @@ static inline int get_pages(struct f2fs_sb_info *sbi, int count_type)
 	return atomic_read(&sbi->nr_pages[count_type]);
 }
 
+static inline int get_dirty_dents(struct inode *inode)
+{
+	return atomic_read(&F2FS_I(inode)->dirty_dents);
+}
+
 static inline int get_blocktype_secs(struct f2fs_sb_info *sbi, int block_type)
 {
 	unsigned int pages_per_sec = sbi->segs_per_sec *
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index d518e37..0d8e4a2 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -273,7 +273,7 @@ void f2fs_evict_inode(struct inode *inode)
 			inode->i_ino == F2FS_META_INO(sbi))
 		goto no_delete;
 
-	f2fs_bug_on(atomic_read(&F2FS_I(inode)->dirty_dents));
+	f2fs_bug_on(get_dirty_dents(inode));
 	remove_dirty_dir_inode(inode);
 
 	if (inode->i_nlink || is_bad_inode(inode))
-- 
1.8.4.474.g128a96c

