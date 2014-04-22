Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaDVFeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:34:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48770 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaDVFeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:34:11 -0400
X-AuditID: cbfee61b-b7f766d00000646c-78-5355ff5226d2
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/2] f2fs: handle inline data independently in
 f2fs_bmap
Date: Tue, 22 Apr 2014 13:34:01 +0800
Message-id: <001901cf5dec$7a6ccf10$6f466d30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9d6pc56+01cBo+TUWRhj4ZXSFMvw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd2g/6HBBkc/cllc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXHk1wemgr2sFX8O
	KjQw7mXpYuTkkBAwkTgzYS4rhC0mceHeerYuRi4OIYFFjBLHLzcxQTg/GCVONP5jBqliE1CR
	WN7xnwnEFhFQlNjwfgM7iM0skClxr2kGWI2wQIjEspmLwDawCKhKrF99H8zmFbCUOL6xH8oW
	lPgx+R4LRK+WxPqdx5kgbHmJzWveMkNcpCCx4+xrRohdehJf915nhqgRl9h45BbLBEaBWUhG
	zUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzIz6R3MK5qsDjEKMDB
	qMTDK2EQGizEmlhWXJl7iFGCg1lJhDf9D1CINyWxsiq1KD++qDQntfgQozQHi5I478FW60Ah
	gfTEktTs1NSC1CKYLBMHp1QDo3jzrGrr/Nm9b3Tjn+e8eWC1cf7R1qNrH6QKya1dUfmoLnVa
	1iaN3OjoqmDbu8mf5PQlRVfyhs1YGZi8gD/unEiJ3MoJTDtcVui9rDNYG681lS/MzdpsekpK
	cLHClr6JKUeuMU+fK1Ewfdkj4Uv+1m/ajpzp/fr93/JrizRk2+0F5HQqv7w5ocRSnJFoqMVc
	VJwIAK3V9yJgAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'd better handle inline data case independently in f2fs_bmap().
It can reduce our handling time in f2fs_bmap().

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 6b89b25..150c12a 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1058,6 +1058,11 @@ static int f2fs_set_data_page_dirty(struct page *page)
 
 static sector_t f2fs_bmap(struct address_space *mapping, sector_t block)
 {
+	struct inode *inode = mapping->host;
+
+	if (f2fs_has_inline_data(inode))
+		return 0;
+
 	return generic_block_bmap(mapping, block, get_data_block);
 }
 
-- 
1.7.9.5


