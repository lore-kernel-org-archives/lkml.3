Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbaJVPrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:47:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbaJVPrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:47:33 -0400
Date: Wed, 22 Oct 2014 18:50:55 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
        Thomas Huth <thuth@linux.vnet.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH RFC v2 11/16] virtio_blk: use virtio v1.0 endian
Message-ID: <1413992894-22976-12-git-send-email-mst@redhat.com>
References: <1413992894-22976-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413992894-22976-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Note that we care only about the fields still in use for virtio v1.0.

Reviewed-by: Thomas Huth <thuth@linux.vnet.ibm.com>
Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/block/virtio_blk.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index c6a27d5..327e601 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -113,6 +113,10 @@ static int __virtblk_add_req(struct virtqueue *vq,
 	sg_init_one(&status, &vbr->status, sizeof(vbr->status));
 	sgs[num_out + num_in++] = &status;
 
+	/* we only care about fields valid for virtio-1 */
+	vbr->out_hdr.type = cpu_to_virtio32(vq->vdev, vbr->out_hdr.type);
+	vbr->out_hdr.sector = cpu_to_virtio64(vq->vdev, vbr->out_hdr.sector);
+
 	return virtqueue_add_sgs(vq, sgs, num_out, num_in, vbr, GFP_ATOMIC);
 }
 
-- 
MST

