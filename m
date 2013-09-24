Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108Ab3IXGSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 02:18:13 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39796 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3IXGSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 02:18:11 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Cc: axboe@kernel.dk, Kent Overstreet <kmo@daterainc.com>,
        stable@vger.kernel.org
Subject: [PATCH 01/11] block: Fix bio_copy_data()
Date: Mon, 23 Sep 2013 23:17:26 -0700
Message-Id: <1380003456-19938-2-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
References: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memcpy() in bio_copy_data() was using the wrong offset vars, leading
to data corruption in weird unusual setups.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.9
---
 fs/bio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index b3b20ed..ea5035d 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -917,8 +917,8 @@ void bio_copy_data(struct bio *dst, struct bio *src)
 		src_p = kmap_atomic(src_bv->bv_page);
 		dst_p = kmap_atomic(dst_bv->bv_page);
 
-		memcpy(dst_p + dst_bv->bv_offset,
-		       src_p + src_bv->bv_offset,
+		memcpy(dst_p + dst_offset,
+		       src_p + src_offset,
 		       bytes);
 
 		kunmap_atomic(dst_p);
-- 
1.8.4.rc3

