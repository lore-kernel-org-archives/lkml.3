Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab3H3ElO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:41:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab3H3ElG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:41:06 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH V2 1/6] vhost_net: make vhost_zerocopy_signal_used() returns void
Date: Fri, 30 Aug 2013 12:29:17 +0800
Message-Id: <1377836962-49780-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1377836962-49780-1-git-send-email-jasowang@redhat.com>
References: <1377836962-49780-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of its caller use its return value, so let it return void.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 969a859..280ee66 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -276,8 +276,8 @@ static void copy_iovec_hdr(const struct iovec *from, struct iovec *to,
  * of used idx. Once lower device DMA done contiguously, we will signal KVM
  * guest used idx.
  */
-static int vhost_zerocopy_signal_used(struct vhost_net *net,
-				      struct vhost_virtqueue *vq)
+static void vhost_zerocopy_signal_used(struct vhost_net *net,
+				       struct vhost_virtqueue *vq)
 {
 	struct vhost_net_virtqueue *nvq =
 		container_of(vq, struct vhost_net_virtqueue, vq);
@@ -297,7 +297,6 @@ static int vhost_zerocopy_signal_used(struct vhost_net *net,
 	}
 	if (j)
 		nvq->done_idx = i;
-	return j;
 }
 
 static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
-- 
1.7.1

