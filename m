Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaJFPH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:07:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbaJFPHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:07:54 -0400
Date: Mon, 6 Oct 2014 18:11:19 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v2 11/15] virtio_net: enable VQs early
Message-ID: <1412608214-31944-12-git-send-email-mst@redhat.com>
References: <1412608214-31944-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412608214-31944-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio spec requires drivers to set DRIVER_OK before using VQs.
This is set automatically after probe returns, virtio net violated this
rule by using receive VQs within probe.

To fix, call virtio_enable_vqs_early before using VQs.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ef04d23..430f3ae 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1792,6 +1792,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 		goto free_vqs;
 	}
 
+	virtio_enable_vqs_early(vdev);
+
 	/* Last of all, set up some receive buffers. */
 	for (i = 0; i < vi->curr_queue_pairs; i++) {
 		try_fill_recv(&vi->rq[i], GFP_KERNEL);
-- 
MST

