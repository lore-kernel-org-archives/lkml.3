Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbbALTNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:13:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57401 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbbALSFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>, Jens Axboe <axboe@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 025/216] drbd: merge_bvec_fn: properly remap bvm->bi_bdev
Date: Mon, 12 Jan 2015 18:02:22 +0000
Message-Id: <1421085933-32536-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars Ellenberg <lars.ellenberg@linbit.com>

commit 3b9d35d744bb5139f9fed57f38c019bb8c7d351c upstream.

This was not noticed for many years. Affects operation if
md raid is used a backing device for DRBD.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/drbd/drbd_req.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 09803d0d5207..eeba503ee7bb 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1343,6 +1343,7 @@ int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct
 		struct request_queue * const b =
 			device->ldev->backing_bdev->bd_disk->queue;
 		if (b->merge_bvec_fn) {
+			bvm->bi_bdev = device->ldev->backing_bdev;
 			backing_limit = b->merge_bvec_fn(b, bvm, bvec);
 			limit = min(limit, backing_limit);
 		}
-- 
2.1.4

