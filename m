Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaBCNt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 08:49:56 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:50625 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaBCNty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 08:49:54 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2 2/2] bcache: Drop L-suffix when comparing ssize_t with 0
Date: Mon,  3 Feb 2014 14:49:47 +0100
Message-Id: <1391435387-13062-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391435387-13062-1-git-send-email-geert@linux-m68k.org>
References: <1391435387-13062-1-git-send-email-geert@linux-m68k.org>
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
Issue has migrated from linux-next to Linus' tree

v2: Drop L-suffix instead of using max_t(ssize_t, ...), as suggested by Joe
    Perches

 drivers/md/bcache/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 98cc0a810a36..f08e48f12291 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(struct btree *b)
 	if (b->keys.ops->is_extents)
 		ret -= KEY_MAX_U64S;
 
-	return max(ret, 0L);
+	return max(ret, 0);
 }
 
 static bool bch_btree_insert_keys(struct btree *b, struct btree_op *op,
-- 
1.7.9.5

