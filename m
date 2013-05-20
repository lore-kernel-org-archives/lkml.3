Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab3ETDfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 23:35:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41635 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab3ETDdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 23:33:39 -0400
X-AuditID: cbfee690-b7efc6d000006d92-13-5199998ee619
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 05/15] f2fs: remove unnecessary por_doing check
Date: Mon, 20 May 2013 12:32:19 +0900
Message-id: <1369020743-18520-5-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t8zA92+mTMDDTqWKFlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXGizb7gD0vFpj1r
	GBsYe1m6GDk5JARMJJourmaFsMUkLtxbzwZiCwksY5RYds6li5EDrGbiq+IuRi6g8CJGieNz
	jzFDOG1MEhsbjrCBFLEJaEts3m8A0isiwCyxYOp5RpAaZoEJjBL/F70HWyYsYC9x9OdEdhCb
	RUBV4lTzJrDFvALuEs83PYA6SFdi9f/nYDWcAh4SW++eYgSZLwRU8/pcCchMCYHvbBINrQ9Z
	IOYISHybfIgF4lBZiU0HmCHGSEocXHGDZQKj8AJGhlWMoqkFyQXFSelFJnrFibnFpXnpesn5
	uZsYIcE6YQfjvQPWhxiTgcZNZJYSTc4HBnteSbyhsZmRhamJqbGRuaUZacJK4rzqLdaBQgLp
	iSWp2ampBalF8UWlOanFhxiZODilGhgXnpx//cmTpCmduk+vRF+47s2akRmfzal8t3TbloBn
	E1YaS7bkurrbeD2cyXR3yoOdi9vvPVhvO/1nbXhdy6HT1227bk2tL//wxGjSjZIspzSx94Vn
	3vMUrcterCe9PVfvYaHW5P7Ddy7a5b3aHer6+UlWxJtLy0wPBdWdKYypvXNuz7zLqre9lViK
	MxINtZiLihMBOYVzgGwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAd2+mTMDDXY3y1tc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hxos2+4A9LxaY9axgbGHtZuhg5OCQETCQmviruYuQEMsUkLtxbz9bFyMUh
	JLCIUeL43GPMEE4bk8TGhiNsIA1sAtoSm/cbgDSICDBLLJh6nhGkhllgAqPE/0XvWUASwgL2
	Ekd/TmQHsVkEVCVONW9iBbF5Bdwlnm96wAKxTVdi9f/nYDWcAh4SW++eYgSZLwRU8/pcyQRG
	3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgqPhmfQOxlUNFocYBTgYlXh4BQJmBgqx
	JpYVV+YeYpTgYFYS4Y3uBgrxpiRWVqUW5ccXleakFh9iTAY6aiKzlGhyPjBS80riDY1NzIws
	jcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBsU6qZ6rWwRiT83fWMX1ZFqhz
	LcbgotTFdvbshPs5Ifxbz/6KMczKrbhjvuvznS2Pp1aWrbAzYL+yz638ZdHZaj0TZp8edb66
	3ON3lGLfWTBoXV2ZdbZkD/fjzNPbwu6/vWSrtTz8nMCRw1NenVLNOT01YMN9ITV+9rtvBBSP
	PtEPDEsvWSocrcRSnJFoqMVcVJwIAGGb5h/KAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This por_doing check is totally not related to the recovery process.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/namei.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 47abc97..729b285 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -149,8 +149,7 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 
 	alloc_nid_done(sbi, ino);
 
-	if (!sbi->por_doing)
-		d_instantiate(dentry, inode);
+	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
 	return 0;
 out:
-- 
1.8.1.3.566.gaa39828

