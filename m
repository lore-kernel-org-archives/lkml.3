Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422794Ab3LFXQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:16:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48590 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab3LFXQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:16:07 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 079/152] block: properly stack underlying max_segment_size to DM device
Date: Fri,  6 Dec 2013 15:10:03 -0800
Message-Id: <1386371476-2477-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit d82ae52e68892338068e7559a0c0657193341ce4 upstream.

Without this patch all DM devices will default to BLK_MAX_SEGMENT_SIZE
(65536) even if the underlying device(s) have a larger value -- this is
due to blk_stack_limits() using min_not_zero() when stacking the
max_segment_size limit.

1073741824

before patch:
65536

after patch:
1073741824

Reported-by: Lukasz Flis <l.flis@cyfronet.pl>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 block/blk-settings.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c50ecf0..5330933 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -144,6 +144,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->discard_zeroes_data = 1;
 	lim->max_segments = USHRT_MAX;
 	lim->max_hw_sectors = UINT_MAX;
+	lim->max_segment_size = UINT_MAX;
 	lim->max_sectors = UINT_MAX;
 	lim->max_write_same_sectors = UINT_MAX;
 }
-- 
1.8.3.2

