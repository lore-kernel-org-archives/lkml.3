Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbbAHKGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:06:04 -0500
Received: from cpanel09.rubas.ch ([195.182.222.79]:58061 "EHLO
	cpanel09.tophost.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbbAHKGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:06:02 -0500
From: =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
Subject: [PATCH] virtio_blk: fix blk_mq_init_queue() error handling
Date: Thu,  8 Jan 2015 11:05:40 +0100
Message-Id: <1420711540-17425-1-git-send-email-j@bitron.ch>
X-Mailer: git-send-email 2.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel09.tophost.ch
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - bitron.ch
X-Get-Message-Sender-Via: cpanel09.tophost.ch: authenticated_id: juerg@bitron.ch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_mq_init_queue() returns ERR_PTR() on failure, not NULL.

Signed-off-by: Jürg Billeter <j@bitron.ch>
---
 drivers/block/virtio_blk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 7ef7c09..b1b5c75 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -638,8 +638,8 @@ static int virtblk_probe(struct virtio_device *vdev)
 		goto out_put_disk;
 
 	q = vblk->disk->queue = blk_mq_init_queue(&vblk->tag_set);
-	if (!q) {
-		err = -ENOMEM;
+	if (IS_ERR(q)) {
+		err = PTR_ERR(q);
 		goto out_free_tags;
 	}
 
-- 
2.2.1

