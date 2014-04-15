Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbaDOLAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:00:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55973 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaDOK7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:59:11 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-1f-534d10faa32d
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/3] f2fs: fix to decrease the number of dirty dentry page
Date: Tue, 15 Apr 2014 19:57:02 +0900
Message-id: <1397559423-27411-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1397559423-27411-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1397559423-27411-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t8zQ91fAr7BBtfarSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyvg8YQlzwRHOik2t
	11gbGM+wdzFyckgImEh0PPwIZYtJXLi3nq2LkYtDSGAZo8SJq29YYYrWHvrNDJGYzigxZe0/
	Fgink0li+qnXjF2MHBxsAtoSm/cbgDSICDBLLJh6nhGkhllgAqPE/0XvWUASwgJeEre6joGt
	YxFQlfgwZTpYnFfAXWJTTxfUGdoS255PZASxOQU8JHYcfQBWIwRU0/l/G9h5EgLf2SRal/1k
	hhgkIPFt8iEWkCMkBGQlNh1ghpgjKXFwxQ2WCYzCCxgZVjGKphYkFxQnpReZ6hUn5haX5qXr
	JefnbmKEBO3EHYz3D1gfYkwGGjeRWUo0OR8Y9Hkl8YbGZkYWpiamxkbmlmakCSuJ86Y/SgoS
	EkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwGitwpfmoWapHH+y8lrWT2Vut3frEpLmrTzTlvRw
	etTZwN16IsZ+531qr2XvD9ixaPb5kgcpbCK/di440ue2Wyevb/9df6WPHKsfZF0tOLib88GN
	2rBF1yafMc39bypn6CAh5Baw26tCoGznztqZ/WtbbA7f1v3H/uTkA+0G2bMKXknXpuot/KTE
	UpyRaKjFXFScCAB9GCdGcAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQd1fAr7BBidvm1lc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jxecIS5oIjnBWbWq+xNjCeYe9i5OSQEDCRWHvoNzOELSZx4d56ti5GLg4h
	gemMElPW/mOBcDqZJKafes3YxcjBwSagLbF5vwFIg4gAs8SCqecZQWqYBSYwSvxf9J4FJCEs
	4CVxq+sY2AYWAVWJD1Omg8V5BdwlNvV0QW3Wltj2fCIjiM0p4CGx4+gDsBohoJrO/9vYJjDy
	LmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHBPPpHcwrmqwOMQowMGoxMM74Z13sBBr
	YllxZe4hRgkOZiUR3o/cvsFCvCmJlVWpRfnxRaU5qcWHGJOBrprILCWanA+M17ySeENjEzMj
	SyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYIy4FmE9a8Fn+4urT/n+kD8o
	9KvrjFC51ePTi+xClJ+dEnLl5Z+R0G95Rmz7ic+7/mik+vl+73nHu62900CEsXBj2+P/f0/x
	szRznL3j+f+/q96u0JMlh6Ii9vJnHzFw9Une2vYwZVkHf2ssT+cPj1alE6ITIv+/nMC5Qj9f
	tnJq5kYeMVGTnUosxRmJhlrMRcWJALL2GSjNAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The f2fs_write_data_page should decrease the number of dirty dentry page
all the time.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 45abd60..9a3fa38 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -790,6 +790,8 @@ static int f2fs_write_data_page(struct page *page,
 		.rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE,
 	};
 
+	inode_dec_dirty_dents(inode);
+
 	if (page->index < end_index)
 		goto write;
 
@@ -798,10 +800,8 @@ static int f2fs_write_data_page(struct page *page,
 	 * this page does not have to be written to disk.
 	 */
 	offset = i_size & (PAGE_CACHE_SIZE - 1);
-	if ((page->index >= end_index + 1) || !offset) {
-		inode_dec_dirty_dents(inode);
+	if ((page->index >= end_index + 1) || !offset)
 		goto out;
-	}
 
 	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 write:
@@ -810,7 +810,6 @@ write:
 
 	/* Dentry blocks are controlled by checkpoint */
 	if (S_ISDIR(inode->i_mode)) {
-		inode_dec_dirty_dents(inode);
 		err = do_write_data_page(page, &fio);
 		goto done;
 	}
-- 
1.8.4.474.g128a96c

