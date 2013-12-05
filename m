Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab3LERg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:36:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38138 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab3LERgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:36:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 22/90] block: properly stack underlying max_segment_size to DM device
Date: Thu,  5 Dec 2013 17:35:04 +0000
Message-Id: <1386264972-5399-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 block/blk-settings.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d3234fc..191d33e 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -144,6 +144,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_segments = USHRT_MAX;
 	lim->max_hw_sectors = UINT_MAX;
 
+	lim->max_segment_size = UINT_MAX;
 	lim->max_sectors = BLK_DEF_MAX_SECTORS;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
-- 
1.8.3.2

