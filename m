Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaBEFiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 00:38:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18601 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaBEFiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 00:38:07 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-e1-52f1ce3d0726
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: fix to truncate dentry pages in the error case
Date: Wed, 05 Feb 2014 14:36:34 +0900
Message-id: <1391578595-854-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zY13bcx+DDO6utrS4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK6NnzVy2gk8sFdMn
	3WZsYGxl6WLk5JAQMJHYsnQFO4QtJnHh3nq2LkYuDiGBZYwS0/4vZIMpurbkBCtEYhGjRN/e
	OewQThOTRNfTp8xdjBwcbALaEpv3G4A0iAgwSyyYep4RpIZZYAKjxP9F71lAaoQFPCUmzakF
	qWERUJXoOnONFcTmFXCV6Nn+H+oibYltzyeC9UoI3GeTOLL1CztEg4DEt8mHwOZICMhKbDrA
	DFEvKXFwxQ2WCYyCCxgZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmKEhODEHYz3D1gfYkwG
	GjeRWUo0OR8Ywnkl8YbGZkYWpiamxkbmlmakCSuJ86Y/SgoSEkhPLEnNTk0tSC2KLyrNSS0+
	xMjEwSnVwDhZ4/fuCie5C8e2PYhUaDxqkND25Iv/YhstLc+92z4d/Ope9rEw/9zLtGmtPRY7
	83JNp+7Zq9Dk53hmh8LGWV6Xl4kylL1+K7Lv1Zq+yNcmP5h26593mnPwalhg8engvQyzJ/Ly
	Pnry4cGn3YabmsqSbOPW/U1g8m8WjloZntz01eH6xlshrpuUWIozEg21mIuKEwFnDhGrVwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAV3bcx+DDFp/mVpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jRs2YuW8Enlorpk24zNjC2snQxcnJICJhIXFtyghXCFpO4cG89WxcjF4eQ
	wCJGib69c9ghnCYmia6nT5m7GDk42AS0JTbvNwBpEBFgllgw9TwjSA2zwARGif+L3rOA1AgL
	eEpMmlMLUsMioCrRdeYa2AJeAVeJnu3/oRZrS2x7PpFxAiP3AkaGVYyiqQXJBcVJ6bmGesWJ
	ucWleel6yfm5mxjBAf5MagfjygaLQ4wCHIxKPLwGwh+DhFgTy4orcw8xSnAwK4nwJnYDhXhT
	EiurUovy44tKc1KLDzEmA22fyCwlmpwPjL68knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmk
	J5akZqemFqQWwWxh4uCUamCczr5L+094K+OsgMLYaY5rF2mafMg9U7Ki2VXDn9/DZ8fedX+6
	vnht3f9Dyk7L0ysmWbVSLOKOS8zHBwWNP4NKbRzXVOwLePPp4m/j6Csy58oPhUw0Z0zyfDyX
	o3R5wJtQz+3bl9960qDx/9ix//8+3n0imSh4O1Kh6XCRZH2/+DctR0uxDUxKLMUZiYZazEXF
	iQABjoCdtAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a new directory is allocated, if an error is occurred, we should truncate
preallocated dentry pages too.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index bfcb4ae..daea906c 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -372,6 +372,8 @@ static struct page *init_inode_metadata(struct inode *inode,
 
 put_error:
 	f2fs_put_page(page, 1);
+	if (S_ISDIR(inode->i_mode))
+		truncate_blocks(inode, 0);
 error:
 	remove_inode_page(inode);
 	return ERR_PTR(err);
-- 
1.8.4.474.g128a96c

