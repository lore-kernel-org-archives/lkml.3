Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab3G2KpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 06:45:19 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:60526 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab3G2KpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 06:45:17 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] bcache: Correct printf()-style format length modifier
Date: Mon, 29 Jul 2013 12:45:05 +0200
Message-Id: <1375094705-27302-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/md/bcache/btree.c: In function ‘bch_btree_node_read’:
drivers/md/bcache/btree.c:259: warning: format ‘%lu’ expects type ‘long unsigned int’, but argument 3 has type ‘size_t’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/md/bcache/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index ee37288..60908de 100644
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
1.7.9.5

