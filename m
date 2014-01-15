Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaAOKt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:49:58 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:57844 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaAOKtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:49:55 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next 2/2] bcache: Use max_t() when comparing different types
Date: Wed, 15 Jan 2014 10:06:24 +0100
Message-Id: <1389776784-30825-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
References: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/md/bcache/btree.c: In function ‘insert_u64s_remaining’:
drivers/md/bcache/btree.c:1816: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/md/bcache/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 98cc0a810a36..c2ebc850d9a9 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(struct btree *b)
 	if (b->keys.ops->is_extents)
 		ret -= KEY_MAX_U64S;
 
-	return max(ret, 0L);
+	return max_t(ssize_t, ret, 0L);
 }
 
 static bool bch_btree_insert_keys(struct btree *b, struct btree_op *op,
-- 
1.7.9.5

