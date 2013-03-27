Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab3C0R45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:56:57 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:43201 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3C0R4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:56:34 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next 3/3] bcache: Use %zu to format size_t
Date: Wed, 27 Mar 2013 18:56:30 +0100
Message-Id: <1364406990-20541-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1364406990-20541-1-git-send-email-geert@linux-m68k.org>
References: <1364406990-20541-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k/allmodconfig:

drivers/md/bcache/debug.c: In function ‘bch_pbtree’:
drivers/md/bcache/debug.c:86: warning: format ‘%li’ expects type ‘long int’, but argument 4 has type ‘size_t’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/md/bcache/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 141a5ca..210c985 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -82,7 +82,7 @@ struct keyprint_hack bch_pbtree(const struct btree *b)
 {
 	struct keyprint_hack r;
 
-	snprintf(r.s, 40, "%li level %i/%i", PTR_BUCKET_NR(b->c, &b->key, 0),
+	snprintf(r.s, 40, "%zu level %i/%i", PTR_BUCKET_NR(b->c, &b->key, 0),
 		 b->level, b->c->root ? b->c->root->level : -1);
 	return r;
 }
-- 
1.7.0.4

