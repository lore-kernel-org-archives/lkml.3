Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaJEQFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 12:05:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbaJEQDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 12:03:53 -0400
Date: Sun, 5 Oct 2014 19:07:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH 11/16] virtio_net: minor cleanup
Message-ID: <1412525038-15871-12-git-send-email-mst@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412525038-15871-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	goto done;
done:
	return;
is ugly, it was put there to make diff review easier.
replace by open-coded return.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d80fef4..4c8c314 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1403,7 +1403,7 @@ static void virtnet_config_changed_work(struct work_struct *work)
 
 	if (virtio_cread_feature(vi->vdev, VIRTIO_NET_F_STATUS,
 				 struct virtio_net_config, status, &v) < 0)
-		goto done;
+		return;
 
 	if (v & VIRTIO_NET_S_ANNOUNCE) {
 		netdev_notify_peers(vi->dev);
@@ -1414,7 +1414,7 @@ static void virtnet_config_changed_work(struct work_struct *work)
 	v &= VIRTIO_NET_S_LINK_UP;
 
 	if (vi->status == v)
-		goto done;
+		return;
 
 	vi->status = v;
 
@@ -1425,8 +1425,6 @@ static void virtnet_config_changed_work(struct work_struct *work)
 		netif_carrier_off(vi->dev);
 		netif_tx_stop_all_queues(vi->dev);
 	}
-done:
-	return;
 }
 
 static void virtnet_config_changed(struct virtio_device *vdev)
-- 
MST

