Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaKYQm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:42:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaKYQmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:42:53 -0500
Date: Tue, 25 Nov 2014 18:42:37 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH v4 17/42] KVM: s390: enable virtio-ccw revision 1
Message-ID: <1416933600-21398-18-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416933600-21398-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Now that virtio-ccw has everything needed to support virtio 1.0 in
place, try to enable it if the host supports it.

MST: enable virtio 1.0 feature bit

Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/s390/kvm/virtio_ccw.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index 50306b2..8ec68dd 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -103,7 +103,7 @@ struct virtio_rev_info {
 };
 
 /* the highest virtio-ccw revision we support */
-#define VIRTIO_CCW_REV_MAX 0
+#define VIRTIO_CCW_REV_MAX 1
 
 struct virtio_ccw_vq_info {
 	struct virtqueue *vq;
@@ -746,8 +746,7 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 out_free:
 	kfree(features);
 	kfree(ccw);
-	/* TODO: enable virtio 1.0 */
-	return rc & ~BIT_ULL(VIRTIO_F_VERSION_1);;
+	return rc;
 }
 
 static void virtio_ccw_finalize_features(struct virtio_device *vdev)
-- 
MST

