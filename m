Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaDAJzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:55:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26981 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaDAJz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:55:28 -0400
X-AuditID: cbfee690-b7f266d00000287c-1e-533a8d0a51fd
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: return -EIO when node id is not matched
Date: Tue, 01 Apr 2014 18:53:28 +0900
Message-id: <1396346008-12753-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zfV2uXqtgg2vnTS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgytjY/YitoJm9YtHX
	Y4wNjJdYuxg5OSQETCQWHl4CZYtJXLi3nq2LkYtDSGAZo8TsBR/YYIoeHtnLCpFYxChx5+Nd
	Zgink0ni2PTVjF2MHBxsAtoSm/cbgDSICDBLLJh6nhGkhllgAqPE/0XvWUASwgJ2EtNbb4PZ
	LAKqEqveNbKD2LwC7hLfzk5mgtimLbHt+USwZgmBx2wSJ/Z2skM0CEh8m3yIBWSZhICsxKYD
	zBD1khIHV9xgmcAouICRYRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSBBO2MF474D1IcZk
	oHETmaVEk/OBQZxXEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYwuBm9XpZzsC1g/x3P318rym2ciV5Uavq25+d21r+eu2bHbW+YrG2iXtc26JJNr
	v/69A/Pqx+nv9RfcnjM3UzrdYmFj9+/KN4dOzJo/b8PJ1+84cpRU3Zkqtj49JMsY8F6sJN7p
	0L4m+bp3nevi/lhFJqb9mWvkd1t+o8jxe6r/3DS7cr523TmkxFKckWioxVxUnAgAf5oicFgC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jAV2uXqtgg57/hhbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWZs7H7EVtDMXrHo6zHGBsZLrF2MnBwSAiYSD4/shbLFJC7cW8/WxcjFISSw
	iFHizse7zBBOJ5PEsemrGbsYOTjYBLQlNu83AGkQEWCWWDD1PCNIDbPABEaJ/4ves4AkhAXs
	JKa33gazWQRUJVa9a2QHsXkF3CW+nZ3MBLFNW2Lb84mMExi5FzAyrGIUTS1ILihOSs810itO
	zC0uzUvXS87P3cQIDvFn0jsYVzVYHGIU4GBU4uG1KLcMFmJNLCuuzD3EKMHBrCTCK9JjFSzE
	m5JYWZValB9fVJqTWnyIMRlo+0RmKdHkfGD85ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBI
	ID2xJDU7NbUgtQhmCxMHp1QDo/hblxvJPO+33F/nwuUgcXor70uD42r72o/PD/l03dqa23e3
	eJzSpVaPdSor7Jw/n966Y8+Fn5+9LH4snJXzuX1G5rl/RoyK3C++CiZ/EpBkWPbn/gbDbSmr
	s3Sk31zfP1FdsXhzxJ/YZQ1xL3k3nH8ZNtXpXtkB0YkuFZKv7ENTn2Uvq7r4vkWJpTgj0VCL
	uag4EQDz2Lz8tQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the cleaing of node segments, F2FS can get errored node blocks due to
data race between node page lock and its valid bitmap operations.
In that case, it needs to return an error to skip such the obsolete block copy.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index eced8d7..065cd99 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -958,7 +958,7 @@ repeat:
 		goto got_it;
 
 	lock_page(page);
-	if (unlikely(!PageUptodate(page))) {
+	if (unlikely(!PageUptodate(page) || nid != nid_of_node(page))) {
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
@@ -967,7 +967,6 @@ repeat:
 		goto repeat;
 	}
 got_it:
-	f2fs_bug_on(nid != nid_of_node(page));
 	mark_page_accessed(page);
 	return page;
 }
-- 
1.8.4.474.g128a96c

