Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaBCNty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 08:49:54 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:45248 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaBCNtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 08:49:53 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH resend 1/2] bcache: Use %zi to format size_t
Date: Mon,  3 Feb 2014 14:49:46 +0100
Message-Id: <1391435387-13062-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/md/bcache/extents.c: In function ‘btree_ptr_bad_expensive’:
drivers/md/bcache/extents.c:196: warning: format ‘%li’ expects type ‘long int’, but argument 4 has type ‘size_t’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Issue has migrated from linux-next to Linus' tree

 drivers/md/bcache/extents.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index c3ead586dc27..416d1a3e028e 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -194,7 +194,7 @@ err:
 	mutex_unlock(&b->c->bucket_lock);
 	bch_extent_to_text(buf, sizeof(buf), k);
 	btree_bug(b,
-"inconsistent btree pointer %s: bucket %li pin %i prio %i gen %i last_gc %i mark %llu gc_gen %i",
+"inconsistent btree pointer %s: bucket %zi pin %i prio %i gen %i last_gc %i mark %llu gc_gen %i",
 		  buf, PTR_BUCKET_NR(b->c, k, i), atomic_read(&g->pin),
 		  g->prio, g->gen, g->last_gc, GC_MARK(g), g->gc_gen);
 	return true;
-- 
1.7.9.5

