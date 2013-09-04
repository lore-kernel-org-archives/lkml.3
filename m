Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab3IDSCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:02:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34656 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3IDSB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:01:58 -0400
Message-ID: <52277576.5020805@infradead.org>
Date: Wed, 04 Sep 2013 11:01:26 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <kmo@daterainc.com>, linux-bcache@vger.kernel.org
Subject: [PATCH -next] bcache: fix btree printk format warning
References: <20130904181300.06fbf0698863cfaacf9fad9a@canb.auug.org.au>
In-Reply-To: <20130904181300.06fbf0698863cfaacf9fad9a@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix printk format warning on i386:

drivers/md/bcache/btree.c: In function 'bch_btree_node_read':
drivers/md/bcache/btree.c:259:8: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'size_t' [-Wformat]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Kent Overstreet <kmo@daterainc.com>
Cc:	linux-bcache@vger.kernel.org
---
 drivers/md/bcache/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20130904.orig/drivers/md/bcache/btree.c
+++ linux-next-20130904/drivers/md/bcache/btree.c
@@ -255,7 +255,7 @@ void bch_btree_node_read(struct btree *b
 
 	return;
 err:
-	bch_cache_set_error(b->c, "io error reading bucket %lu",
+	bch_cache_set_error(b->c, "io error reading bucket %zu",
 			    PTR_BUCKET_NR(b->c, &b->key, 0));
 }
 
