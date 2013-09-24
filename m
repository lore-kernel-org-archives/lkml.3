Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3IXGUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 02:20:52 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:57905 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab3IXGSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 02:18:46 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Cc: axboe@kernel.dk, Geert Uytterhoeven <geert@linux-m68k.org>,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 05/11] bcache: Correct printf()-style format length modifier
Date: Mon, 23 Sep 2013 23:17:30 -0700
Message-Id: <1380003456-19938-6-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
References: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

drivers/md/bcache/btree.c: In function ‘bch_btree_node_read’:
drivers/md/bcache/btree.c:259: warning: format ‘%lu’ expects type ‘long unsigned int’, but argument 3 has type ‘size_t’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index f9764e6..8fad840 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -255,7 +255,7 @@ void bch_btree_node_read(struct btree *b)
 
 	return;
 err:
-	bch_cache_set_error(b->c, "io error reading bucket %lu",
+	bch_cache_set_error(b->c, "io error reading bucket %zu",
 			    PTR_BUCKET_NR(b->c, &b->key, 0));
 }
 
-- 
1.8.4.rc3

