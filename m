Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3ETDRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 23:17:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43064 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab3ETDRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 23:17:19 -0400
X-AuditID: cbfee68f-b7f436d000000f81-3b-519995bd8b1e
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: remove unnecessary kmap/kunmap operations
Date: Mon, 20 May 2013 12:16:06 +0900
Message-id: <1369019767-17321-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zI929U2cGGkxYY2VxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8bVrd+YC/5zVzxq
	ncjewPiIs4uRk0NCwETi///lTBC2mMSFe+vZQGwhgWWMElfmc8DU/Hm0lQUiPp1R4uMnlS5G
	LiC7jUmipXchYxcjBwebgLbE5v0GIDUiAswSC6aeZwSpYRaYwCjxf9F7sGZhAReJr1eOMYPY
	LAKqEi8OLQRbzCvgLtG+ZgErxDJdidX/n7ODNEsI3GeT2Pe4iw2iQUDi2+RDLCDLJARkJTYd
	YIaol5Q4uOIGywRGwQWMDKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxQgKwfwfj3QPWhxiT
	gcZNZJYSTc4HBnBeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanF
	hxiZODilGhhPSPB0fNqSr8jQdl7jQ/7uzZ+Zw+ctjwx9Mutw++sId49ki2d2C/VKG4RPVU5b
	ErZ8tt1h8cht2hHbTfSW6FfOsuX/aqVWqHp3VtmjcNbHvsfmTkxdYPxWr3vpFOWXhT+5dvGZ
	+C+pPcemMunadubIM08iozc0qgZ2H+atXH3jS8cnC5sVp18psRRnJBpqMRcVJwIAJ5xUG1YC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd29U2cGGvTOMbO4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj6tZvzAX/uSsetU5kb2B8xNnFyMkhIWAi8efRVhYIW0ziwr31bCC2kMB0
	RomPn1S6GLmA7DYmiZbehYxdjBwcbALaEpv3G4DUiAgwSyyYep4RpIZZYAKjxP9F78EGCQu4
	SHy9cowZxGYRUJV4cWghE4jNK+Au0b5mASvEMl2J1f+fs09g5F7AyLCKUTS1ILmgOCk910iv
	ODG3uDQvXS85P3cTIzjAn0nvYFzVYHGIUYCDUYmHVyBgZqAQa2JZcWXuIUYJDmYlEd7obqAQ
	b0piZVVqUX58UWlOavEhxmSg7ROZpUST84HRl1cSb2hsYmZkaWRmYWRibk6asJI478FW60Ah
	gfTEktTs1NSC1CKYLUwcnFINjGpfF9pLnTPYUhrb+OIms6FYWOukDN0/mTM4rr/+E3pGTF21
	2onvcYGur/ti+dSlOjzXzKdu4z4++6ph5e9NnvfqebVm/V2uXTnzvH1CsBpXxTx3sZeTP5z8
	lbxscsh9dcW5ZU9v3EnasnRN67UiZX59Ua6tDtHmfhfNK+5usHeLtLJTa1XQV2Ipzkg01GIu
	Kk4EACDs0H+0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The allocated page used by the recovery is not on HIGHMEM, so that we don't
need to use kmap/kunmap.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/recovery.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 774efdb..5fcdd08 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -40,11 +40,11 @@ static struct fsync_inode_entry *get_fsync_inode(struct list_head *head,
 
 static int recover_dentry(struct page *ipage, struct inode *inode)
 {
-	struct f2fs_node *raw_node = (struct f2fs_node *)kmap(ipage);
+	void *kaddr = page_address(ipage);
+	struct f2fs_node *raw_node = (struct f2fs_node *)kaddr;
 	struct f2fs_inode *raw_inode = &(raw_node->i);
 	nid_t pino = le32_to_cpu(raw_inode->i_pino);
 	struct qstr name;
-	struct f2fs_dir_entry *de;
 	struct page *page;
 	struct inode *dir;
 	int err = 0;
@@ -62,8 +62,7 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
 	name.len = le32_to_cpu(raw_inode->i_namelen);
 	name.name = raw_inode->i_name;
 
-	de = f2fs_find_entry(dir, &name, &page);
-	if (de) {
+	if (f2fs_find_entry(dir, &name, &page)) {
 		kunmap(page);
 		f2fs_put_page(page, 0);
 	} else {
@@ -73,7 +72,6 @@ out:
 	f2fs_msg(inode->i_sb, KERN_NOTICE, "recover_inode and its dentry: "
 			"ino = %x, name = %s, dir = %lx, err = %d",
 			ino_of_node(ipage), raw_inode->i_name, dir->i_ino, err);
-	kunmap(ipage);
 	return err;
 }
 
-- 
1.8.1.3.566.gaa39828

