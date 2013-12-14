Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3LNM7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:59:39 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:59075 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3LNM7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:59:37 -0500
Date: Sat, 14 Dec 2013 18:29:29 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH] drivers: md: Mark the function btree_insert_fn() as static
 in btree.c
Message-ID: <20131214125929.GA8200@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function btree_insert_fn() as static in
bcache/btree.c because it is not used outside this file.

Thus, it also eliminates the following warning in bcache/btree.c:
drivers/md/bcache/btree.c:2220:5: warning: no previous prototype for ‘btree_insert_fn’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/md/bcache/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 5e2765a..dc6e2be 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2217,7 +2217,7 @@ struct btree_insert_op {
 	struct bkey	*replace_key;
 };
 
-int btree_insert_fn(struct btree_op *b_op, struct btree *b)
+static int btree_insert_fn(struct btree_op *b_op, struct btree *b)
 {
 	struct btree_insert_op *op = container_of(b_op,
 					struct btree_insert_op, op);
-- 
1.7.9.5

