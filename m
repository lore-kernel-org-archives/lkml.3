Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3KRNMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:12:20 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44438 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3KRNMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:12:14 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] bio: fix argument of __bio_add_page() for max_sectors > 0xffff
Date: Mon, 18 Nov 2013 22:11:42 +0900
Message-Id: <1384780302-25009-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data type of max_sectors and max_hw_sectors in queue settings are
unsigned int.  But these values are passed to __bio_add_page() as an
argument whose data type is unsigned short.  In the worst case such as
max_sectors is 0x10000, bio_add_page() can't add a page and IOs can't
proceed.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 fs/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bio.c b/fs/bio.c
index 2bdb4e2..33d79a4 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -601,7 +601,7 @@ EXPORT_SYMBOL(bio_get_nr_vecs);
 
 static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 			  *page, unsigned int len, unsigned int offset,
-			  unsigned short max_sectors)
+			  unsigned int max_sectors)
 {
 	int retried_segments = 0;
 	struct bio_vec *bvec;
-- 
1.8.3.2

