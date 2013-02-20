Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935144Ab3BTAZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:25:36 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:58806 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935000Ab3BTAXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:23:13 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 21/27] raid1: use bio_copy_data()
Date: Tue, 19 Feb 2013 16:22:35 -0800
Message-Id: <1361319761-23873-22-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361319761-23873-1-git-send-email-koverstreet@google.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't really delete any code _yet_, but once immutable bvecs are
done we can just delete the rest of the code in that loop.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8839b8d..1fd0888 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1903,10 +1903,9 @@ static int process_checks(struct r1bio *r1_bio)
 			else
 				bi->bv_len = size;
 			size -= PAGE_SIZE;
-			memcpy(page_address(bi->bv_page),
-			       page_address(pbio->bi_io_vec[j].bv_page),
-			       PAGE_SIZE);
 		}
+
+		bio_copy_data(sbio, pbio);
 	}
 	return 0;
 }
-- 
1.7.12

