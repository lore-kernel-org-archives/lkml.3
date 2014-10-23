Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbaJWNGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:06:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbaJWNGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:06:24 -0400
Date: Thu, 23 Oct 2014 16:09:55 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] virtio_blk: make serial attribute static
Message-ID: <1414069787-17287-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's never declared so no need to make it extern.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/block/virtio_blk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 93e23a7..a68f4c6 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -332,7 +332,8 @@ static ssize_t virtblk_serial_show(struct device *dev,
 
 	return err;
 }
-DEVICE_ATTR(serial, S_IRUGO, virtblk_serial_show, NULL);
+
+static DEVICE_ATTR(serial, S_IRUGO, virtblk_serial_show, NULL);
 
 static void virtblk_config_changed_work(struct work_struct *work)
 {
-- 
MST
