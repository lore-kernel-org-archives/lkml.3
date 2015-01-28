Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810AbbA1Cod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:44:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbbA1Coc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:44:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.10 26/32] drbd: merge_bvec_fn: properly remap bvm->bi_bdev
Date: Tue, 27 Jan 2015 17:26:56 -0800
Message-Id: <20150128012630.795769100@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012627.081285723@linuxfoundation.org>
References: <20150128012627.081285723@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars Ellenberg <lars.ellenberg@linbit.com>

commit 3b9d35d744bb5139f9fed57f38c019bb8c7d351c upstream.

This was not noticed for many years. Affects operation if
md raid is used a backing device for DRBD.

CC: stable@kernel.org # v3.2+
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/drbd/drbd_req.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1309,6 +1309,7 @@ int drbd_merge_bvec(struct request_queue
 		struct request_queue * const b =
 			mdev->ldev->backing_bdev->bd_disk->queue;
 		if (b->merge_bvec_fn) {
+			bvm->bi_bdev = mdev->ldev->backing_bdev;
 			backing_limit = b->merge_bvec_fn(b, bvm, bvec);
 			limit = min(limit, backing_limit);
 		}


