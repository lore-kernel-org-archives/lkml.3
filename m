Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaBIMxB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 07:53:01 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36101 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaBIMxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 07:53:00 -0500
Date: Sun, 9 Feb 2014 18:22:53 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, josh@joshtriplett.org
Subject: [PATCH 03/21] fs: Mark function as static in fs/bio-integrity.c
Message-ID: <3e778679e08fc73189ffaf4233fde057a0e75e68.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in bio-integrity.c because it is not used
outside this file.

This eliminates the following warnings in bio-integrity.c:
fs/bio-integrity.c:224:5: warning: no previous prototype for ‘bio_integrity_tag’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 fs/bio-integrity.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 0bad24d..51d15ae 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -226,7 +226,8 @@ unsigned int bio_integrity_tag_size(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_integrity_tag_size);
 
-int bio_integrity_tag(struct bio *bio, void *tag_buf, unsigned int len, int set)
+static int bio_integrity_tag(struct bio *bio, void *tag_buf, unsigned int len,
+			     int set)
 {
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
-- 
1.7.9.5

