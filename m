Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaB0LkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:40:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9521 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaB0LkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:40:19 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-f7-530f242259ed
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/3] f2fs: remove costly bit operations for f2fs_find_entry
Date: Thu, 27 Feb 2014 20:38:37 +0900
Message-id: <1393501119-12976-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zI10lFf5gg61zeSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyjh4+BZjwXWBivnT
	97A2MK7g7WLk5JAQMJG4+m87K4QtJnHh3nq2LkYuDiGBZYwSxxZcZ4Up2th0mRUiMZ1R4uzf
	o+wQTieTxOVlT5m6GDk42AS0JTbvNwBpEBFgllgw9TwjSA2zwARGif+L3rOAJIQFvCUeT7rF
	BmKzCKhK/P43lRmkl1fAXWLz0zyIZdoS255PBOuVEHjMJnGudzUzRL2AxLfJh1hA6iUEZCU2
	HWCGqJeUOLjiBssERsEFjAyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MUJCcOIOxvsHrA8x
	JgONm8gsJZqcDwzhvJJ4Q2MzIwtTE1NjI3NLM9KElcR50x8lBQkJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgFLJ7ZNq22rNcNXlHrXWlfRPXGTcuuTauE7EXlqvIMSfmnF4r8uR8wc3SgHur
	Ns5a39noLH0rdF711QcrZ+RND+PYe9R3nsYnDvOpL/SWPz9x5Bubem/ftBNx25uasp8flp48
	9evePq3HJjfrZgnf/+hnMl13epP1rxXv7AV9RfN42dbOX7DCUomlOCPRUIu5qDgRACpX6lRX	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQV0lFf5ggzuTOCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8w4ePgWY8F1gYr50/ewNjCu4O1i5OSQEDCR2Nh0mRXCFpO4cG89WxcjF4eQ
	wHRGibN/j7JDOJ1MEpeXPWXqYuTgYBPQlti83wCkQUSAWWLB1POMIDXMAhMYJf4ves8CkhAW
	8JZ4POkWG4jNIqAq8fvfVGaQXl4Bd4nNT/MglmlLbHs+kXECI/cCRoZVjKKpBckFxUnpuYZ6
	xYm5xaV56XrJ+bmbGMEB/kxqB+PKBotDjAIcjEo8vApsfMFCrIllxZW5hxglOJiVRHjXM/EH
	C/GmJFZWpRblxxeV5qQWH2JMBlo+kVlKNDkfGH15JfGGxiZmRpZGZhZGJubmpAkrifMeaLUO
	FBJITyxJzU5NLUgtgtnCxMEp1cB48rtURRlL0psDJ9eUcEZM/RP74tNHpc3l2axb3nPoTu/3
	s/4SOm/XKSaze1Ybaz/M54+d4BoT7rKP+cecp1NC1GL2tMzW4878z7Oa2/HMGtWE8A38Kstb
	roWsmiSw3ovBtFVW70LF3nOz3zRdXDn3rUb+WTf/pgpru73fc9x7dmhqaIu25ccosRRnJBpq
	MRcVJwIAHZmzdbQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that a bit operation like find_next_bit is not always fast enough
for f2fs_find_entry.
Instead, it is pretty much simple and fast to traverse each dentries.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index d5a2c9e..c3ea8f8 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -93,16 +93,20 @@ static struct f2fs_dir_entry *find_in_block(struct page *dentry_page,
 			f2fs_hash_t namehash, struct page **res_page)
 {
 	struct f2fs_dir_entry *de;
-	unsigned long bit_pos, end_pos, next_pos;
+	unsigned long bit_pos = 0;
 	struct f2fs_dentry_block *dentry_blk = kmap(dentry_page);
-	int slots;
+	int max_len = 0;
 
-	bit_pos = find_next_bit_le(&dentry_blk->dentry_bitmap,
-					NR_DENTRY_IN_BLOCK, 0);
 	while (bit_pos < NR_DENTRY_IN_BLOCK) {
 		de = &dentry_blk->dentry[bit_pos];
-		slots = GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
-
+		if (!test_bit_le(bit_pos, &dentry_blk->dentry_bitmap)) {
+			if (bit_pos == 0)
+				max_len = 1;
+			else if (!test_bit_le(bit_pos - 1, &dentry_blk->dentry_bitmap))
+				max_len++;
+			bit_pos++;
+			continue;
+		}
 		if (early_match_name(name, namelen, namehash, de)) {
 			if (!memcmp(dentry_blk->filename[bit_pos],
 							name, namelen)) {
@@ -110,20 +114,18 @@ static struct f2fs_dir_entry *find_in_block(struct page *dentry_page,
 				goto found;
 			}
 		}
-		next_pos = bit_pos + slots;
-		bit_pos = find_next_bit_le(&dentry_blk->dentry_bitmap,
-				NR_DENTRY_IN_BLOCK, next_pos);
-		if (bit_pos >= NR_DENTRY_IN_BLOCK)
-			end_pos = NR_DENTRY_IN_BLOCK;
-		else
-			end_pos = bit_pos;
-		if (*max_slots < end_pos - next_pos)
-			*max_slots = end_pos - next_pos;
+		if (max_len > *max_slots) {
+			*max_slots = max_len;
+			max_len = 0;
+		}
+		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 	}
 
 	de = NULL;
 	kunmap(dentry_page);
 found:
+	if (max_len > *max_slots)
+		*max_slots = max_len;
 	return de;
 }
 
-- 
1.8.4.474.g128a96c

