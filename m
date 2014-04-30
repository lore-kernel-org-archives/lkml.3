Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaD3CgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:36:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30116 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbaD3CgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:36:00 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-c2-5360618c0b5e
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Chao Yu <chao2.yu@samsung.com>
Subject: [PATCH 2/4] f2fs: avoid grab_cache_page_write_begin for data pages
Date: Wed, 30 Apr 2014 11:33:41 +0900
Message-id: <1398825223-23062-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1398825223-23062-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1398825223-23062-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t8zY92exIRgg1+/5Sz+N31ks7i+6y+T
	xaVF7hZ79p5ksbi8aw6bA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr48KbdUwF
	p3krvrx/y9LAOI+7i5GTQ0LAROLt9lvsELaYxIV769m6GLk4hASWMUpM2jeRDaZo1vLTYEVC
	AosYJY4/FIOwO5kk1jyq6GLk4GAT0JbYvN8AJCwiwCyxYOp5RpA5zAKbGCUWvHnHDlIjLOAt
	MfE0C0gNi4CqxN+jO9lAwrwC7hK3VrlDbNKW2PZ8IiOIzSngIXHx9UVGiE3uEvveHIS65j+b
	xNdVMhBjBCS+TT7EAjJGQkBWYtMBZogSSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IWK84Mbe4
	NC9dLzk/dxMjJGj7dzDePWB9iDEZaNxEZinR5Hxg0OeVxBsamxlZmJqYGhuZW5qRJqwkznv/
	YVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsagZQkbihUf3Vy75+qctP2yHxyb9tdnHBf4
	7KL9kXE96zZ11Wuaugc+BBTc23Xp3uG12g09O2Uj55lPP3QgYcHKmbKvM85s63/MnLvH6MqD
	xOp9HFOnbTroy9YlMP1yyv3zH3b474i/aeBU9zpH/Pa2l52tv98u17lgniRsP7+27+GRzM1r
	zYNmKrEUZyQaajEXFScCAMhb7EBwAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jAd2exIRggyvXpCz+N31ks7i+6y+T
	xaVF7hZ79p5ksbi8aw6bA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMePCm3VMBad5K768f8vSwDiPu4uRk0NCwERi1vLT7BC2mMSFe+vZ
	QGwhgUWMEscfikHYnUwSax5VdDFycLAJaEts3m8AEhYRYJZYMPU8YxcjFwezwCZGiQVv3rGD
	1AgLeEtMPM0CUsMioCrx9+hONpAwr4C7xK1V7hCbtCW2PZ/ICGJzCnhIXHx9kRFik7vEvjcH
	2SYw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERwVz6R2MK5ssDjEKMDBqMTDK7A1
	PliINbGsuDL3EKMEB7OSCC9zQEKwEG9KYmVValF+fFFpTmrxIcZkoKMmMkuJJucDIzavJN7Q
	2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhgZzy1/y9bmkvD/mX2u
	gt37755K1hFn786xPJjVbaBzeX6RhFV699Y7bWIfdx8tcD8x311V5YFMceGuvQvWpS65dMuu
	RZeN/b/lg6Uz+SVfrLx58ZEzk6aB+P/aNc47Z+1sFvi+7K5xx10VHpPvsguUwnWnmYVaLV2p
	G7KR6WFI3/yFVfHb525QYinOSDTUYi4qTgQAWNBtH84CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to wait on page writeback for these cases.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c   | 4 ++--
 fs/f2fs/inline.c | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 273fe16..91ff104 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -417,7 +417,7 @@ struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
 	if (unlikely(dn.data_blkaddr == NEW_ADDR))
 		return ERR_PTR(-EINVAL);
 
-	page = grab_cache_page_write_begin(mapping, index, AOP_FLAG_NOFS);
+	page = grab_cache_page(mapping, index);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
@@ -455,7 +455,7 @@ struct page *get_lock_data_page(struct inode *inode, pgoff_t index)
 	int err;
 
 repeat:
-	page = grab_cache_page_write_begin(mapping, index, AOP_FLAG_NOFS);
+	page = grab_cache_page(mapping, index);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 8bf34f0..1bba522 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -95,6 +95,7 @@ static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
 	if (err)
 		goto out;
 
+	f2fs_wait_on_page_writeback(page, DATA);
 	zero_user_segment(page, MAX_INLINE_DATA, PAGE_CACHE_SIZE);
 
 	/* Copy the whole inline data block */
@@ -133,7 +134,7 @@ int f2fs_convert_inline_data(struct inode *inode, pgoff_t to_size)
 	else if (to_size <= MAX_INLINE_DATA)
 		return 0;
 
-	page = grab_cache_page_write_begin(inode->i_mapping, 0, AOP_FLAG_NOFS);
+	page = grab_cache_page(inode->i_mapping, 0);
 	if (!page)
 		return -ENOMEM;
 
-- 
1.8.4.474.g128a96c

