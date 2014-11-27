Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaK0MdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:33:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755669AbaK0MdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:33:01 -0500
Date: Thu, 27 Nov 2014 14:32:44 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v5 32/45] vhost/net: larger header for virtio 1.0
Message-ID: <1417091078-24611-33-git-send-email-mst@redhat.com>
References: <1417091078-24611-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417091078-24611-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index cae22f9..1ac58d0 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1027,7 +1027,8 @@ static int vhost_net_set_features(struct vhost_net *n, u64 features)
 	size_t vhost_hlen, sock_hlen, hdr_len;
 	int i;
 
-	hdr_len = (features & (1 << VIRTIO_NET_F_MRG_RXBUF)) ?
+	hdr_len = (features & ((1ULL << VIRTIO_NET_F_MRG_RXBUF) |
+			       (1ULL << VIRTIO_F_VERSION_1))) ?
 			sizeof(struct virtio_net_hdr_mrg_rxbuf) :
 			sizeof(struct virtio_net_hdr);
 	if (features & (1 << VHOST_NET_F_VIRTIO_NET_HDR)) {
-- 
MST

