Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbaD3Cgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:36:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18580 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbaD3Cf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:35:59 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-f5-5360618ccaa4
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 4/4] f2fs: decrease the lock granularity during write_begin
Date: Wed, 30 Apr 2014 11:33:43 +0900
Message-id: <1398825223-23062-4-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1398825223-23062-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1398825223-23062-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t8zY92exIRggy0LdCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyph3LLegh7Ni39OJ
	bA2MS9i7GDk4JARMJO7vkOxi5AQyxSQu3FvP1sXIxSEksIxRYuO9NSwQCROJt90X2SESixgl
	Tn04CJYQEuhkkljzqAJkEJuAtsTm/QYgYREBZokFU88zgtQzC0xglPi/6D1YvbCAt8S5o6vZ
	QOpZBFQlzpyqBQnzCrhLHO1/zAqxS1ti2/OJjCA2p4CHxMXXFxkhVrlL7HtzEOw4CYHfbBKP
	r5wFa2AREJD4NvkQC8QzshKbDjBDzJGUOLjiBssERuEFjAyrGEVTC5ILipPSiwz1ihNzi0vz
	0vWS83M3MUKCtXcH4+0D1ocYk4HGTWSWEk3OBwZ7Xkm8obGZkYWpiamxkbmlGWnCSuK8SQ+T
	goQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwRj86fGxa0Vw9zX0GEgHuPzSWXnrbG+LzxXhp
	RUx70LEf+0N0OftTbuxaYeO3MkNwxWqVhg99TzdtdPnb6rX7Q/LRHUuXHvnJVLWa3VdoxbXT
	qh7MWTEhSk8yDG5e/TRHRc2o0V9sT9rtwMuTjnvaGeQI6Idd5Q7I7tg2YVrx1eBqcbvlkgv+
	KrEUZyQaajEXFScCAO/48fxsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAd2exIRgg9svNSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8yYdyy3oIezYt/TiWwNjEvYuxg5OSQETCTedl+EssUkLtxbz9bFyMUhJLCI
	UeLUh4MsIAkhgU4miTWPKroYOTjYBLQlNu83AAmLCDBLLJh6nhGknllgAqPE/0XvweqFBbwl
	zh1dzQZSzyKgKnHmVC1ImFfAXeJo/2NWiF3aEtueT2QEsTkFPCQuvr7ICLHKXWLfm4NsExh5
	FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjoZnUjsYVzZYHGIU4GBU4uEV2BofLMSa
	WFZcmXuIUYKDWUmElzkgIViINyWxsiq1KD++qDQntfgQYzLQUROZpUST84GRmlcSb2hsYmZk
	aWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjFrGc1e0/dwSa/1Fm8GoXvfT
	y0fMay7wGvz+8jOmqso2cvYBhvR/t398Olas/YtTVpX3JeOlDNuu9TIcgpFyLOamFUsudq5w
	jnPTuTB72syjieEdh64H7kkW+3xrV+PnBxWGAmn7nzJ9vvjwTszBhwVTtqae+f+SK/3hZ+18
	pXY+m2OuV5+ErFNiKc5INNRiLipOBAAyN9r5ygIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reduces the lock granularity during write_begin.
When the system is under memory pressure, it would be better to reduce
the locking time for the data pages.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 91ff104..a7bb98f 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -909,6 +909,10 @@ repeat:
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page)
 		return -ENOMEM;
+
+	/* to avoid latency during memory pressure */
+	unlock_page(page);
+
 	*pagep = page;
 
 	if (f2fs_has_inline_data(inode) && (pos + len) <= MAX_INLINE_DATA)
@@ -920,10 +924,18 @@ repeat:
 	f2fs_unlock_op(sbi);
 
 	if (err) {
-		f2fs_put_page(page, 1);
+		f2fs_put_page(page, 0);
 		return err;
 	}
 inline_data:
+	lock_page(page);
+	if (unlikely(page->mapping != mapping)) {
+		f2fs_put_page(page, 1);
+		goto repeat;
+	}
+
+	f2fs_wait_on_page_writeback(page, DATA);
+
 	if ((len == PAGE_CACHE_SIZE) || PageUptodate(page))
 		return 0;
 
-- 
1.8.4.474.g128a96c

